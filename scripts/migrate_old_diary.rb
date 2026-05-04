#!/usr/bin/env ruby
# frozen_string_literal: true

require "cgi"
require "fileutils"
require "nokogiri"
require "set"
require "yaml"

ROOT = File.expand_path("..", __dir__)
OLD_HTML = File.join(ROOT, ".olddiary", "olddiary.html")
OLD_IMAGES = File.join(ROOT, ".olddiary", "images")
DIARI_DIR = File.join(ROOT, "diari")

STOPWORDS = %w[
  aquest aquesta aquests aquestes aquell aquella aquells aquelles abans aleshores alla al llarg
  amb com contra dels des dins doncs durant entre fins havia hi les los mes molt molts nomes
  nostre nostra nostres pels per pero qual quan que qui seva seves seus sense sobre sota tots
  una unes uns dels les els del qui vaig vam van seu seus seva seves aqui aquesta aquell aquell
  mentre cada havia havien encara després abans aquell aquella aquell mateix mateixa
].to_set

ROMAN_VALUES = {
  "I" => 1,
  "V" => 5,
  "X" => 10,
  "L" => 50,
  "C" => 100,
  "D" => 500,
  "M" => 1000
}.freeze

MANUAL_IMAGE_HINTS = {
  "image44" => "poble-valdeluna",
  "image47" => "taverna-valdeluna",
  "image52" => "viatge-sete-mar",
  "image8" => "vaixell-vermell",
  "image96" => "illa-misteriosa"
}.freeze

def roman_to_i(roman)
  chars = roman.upcase.chars
  chars.each_with_index.sum do |char, index|
    value = ROMAN_VALUES.fetch(char)
    next_value = ROMAN_VALUES[chars[index + 1]] || 0
    value < next_value ? -value : value
  end
end

def slugify(text)
  text.to_s
      .downcase
      .unicode_normalize(:nfkd)
      .encode("ASCII", invalid: :replace, undef: :replace, replace: "")
      .gsub(/[^a-z0-9]+/, "-")
      .gsub(/^-|-$/, "")
end

def yaml_front_matter(data)
  data.compact.to_yaml.sub(/\A---\n/, "---\n")
end

def clean_text(text)
  CGI.unescapeHTML(text.to_s)
     .tr("\u00a0", " ")
     .gsub(/[[:space:]]+/, " ")
     .strip
end

def markdown_escape(text)
  clean_text(text)
end

def inline_markdown(node)
  return markdown_escape(node.text) if node.text?

  if node.element? && node.name == "br"
    return "\n"
  end

  rendered = node.children.map { |child| inline_markdown(child) }.join
  return rendered unless node.element?

  classes = (node["class"] || "").split
  if classes.include?("c5")
    "***#{rendered.strip}***"
  elsif classes.include?("c6")
    "**#{rendered.strip}**"
  elsif classes.include?("c8") || classes.include?("c9")
    "*#{rendered.strip}*"
  else
    rendered
  end
end

def words_for_name(context)
  clean_text(context)
    .downcase
    .unicode_normalize(:nfkd)
    .encode("ASCII", invalid: :replace, undef: :replace, replace: "")
    .scan(/[a-z0-9]{4,}/)
    .reject { |word| STOPWORDS.include?(word) }
    .uniq
    .first(5)
end

def unique_name(base, used)
  candidate = base
  index = 2
  while used.include?(candidate)
    candidate = "#{base}-#{index}"
    index += 1
  end
  used << candidate
  candidate
end

def make_image_name(src, context, used)
  stem = File.basename(src, ".*")
  base = MANUAL_IMAGE_HINTS[stem]
  base ||= words_for_name(context).join("-")
  base = "escena-diari" if base.empty?
  unique_name(base, used)
end

def convert_image(src_path, dest_path)
  FileUtils.mkdir_p(File.dirname(dest_path))
  if system("cwebp", "-quiet", src_path, "-o", dest_path)
    return
  end

  FileUtils.cp(src_path, dest_path.sub(/\.webp\z/, File.extname(src_path)))
end

def paragraph_markdown(node, section, used_names)
  blocks = []

  node.css("img").each do |img|
    src = img["src"]
    next unless src

    source = File.join(OLD_IMAGES, File.basename(src))
    unless File.exist?(source)
      warn "Missing image: #{src}"
      next
    end

    context = [
      section[:label],
      section[:title],
      node.previous_element&.text,
      node.next_element&.text
    ].join(" ")
    image_base = make_image_name(src, context, used_names)
    image_file = "#{image_base}.webp"
    image_dest = File.join(section[:dir], image_file)
    convert_image(source, image_dest)
    alt = image_base.tr("-", " ")
    blocks << "![#{alt}](#{image_file})"
    section[:images] << image_file
  end

  clone = node.dup
  clone.css("span").each do |span|
    span.remove if span.css("img").any?
  end
  clone.css("img").remove
  text = clean_text(clone.children.map { |child| inline_markdown(child) }.join)
  blocks.unshift(text) unless text.empty?
  blocks
end

def list_markdown(node)
  node.css("> li").map.with_index(1) do |li, index|
    "#{index}. #{clean_text(li.children.map { |child| inline_markdown(child) }.join)}"
  end
end

def truncate_summary(text)
  clean = clean_text(text)
  return clean if clean.length <= 180

  clean[0, 177].sub(/\s+\S*\z/, "") + "..."
end

def parse_sections
  abort "No existeix #{OLD_HTML}" unless File.exist?(OLD_HTML)

  doc = Nokogiri::HTML(File.read(OLD_HTML))
  sections = []
  current_chapter = nil
  current_act = nil

  doc.css("body > *").each do |node|
    classes = (node["class"] || "").split
    text = clean_text(node.text)

    if node.name == "p" && classes.include?("title") && text.match?(/\ACap[ií]tol\b/i)
      roman = text[/Cap[ií]tol\s+([IVXLCDM]+)/i, 1]
      order = roman_to_i(roman)
      current_chapter = {
        order: order,
        slug: format("capitol%02d", order),
        title: text,
        acts: []
      }
      sections << current_chapter
      current_act = nil
      next
    end

    if node.name == "p" && classes.include?("subtitle") && text.match?(/\APr[oò]leg\z/i)
      current_chapter = {
        order: 0,
        slug: "capitol00",
        title: "Pròleg",
        acts: []
      }
      sections << current_chapter
      current_act = {
        order: 1,
        label: "Pròleg",
        title: "Pròleg",
        content_nodes: [],
        images: []
      }
      current_chapter[:acts] << current_act
      next
    end

    if node.name == "p" && classes.include?("subtitle") && text.match?(/\AActe\b/i)
      roman = text[/Acte\s+([IVXLCDM]+)/i, 1]
      order = roman_to_i(roman)
      title = text.sub(/\AActe\s+[IVXLCDM]+\.\s*/i, "")
      current_act = {
        order: order,
        label: "Acte #{roman}",
        title: title,
        content_nodes: [],
        images: []
      }
      current_chapter[:acts] << current_act
      next
    end

    current_act[:content_nodes] << node if current_act
  end

  sections
end

def write_act(chapter, act)
  local_order = chapter[:slug] == "capitol00" ? 1 : act[:order]
  act_slug = format("acte%02d", local_order)
  act_dir = File.join(DIARI_DIR, chapter[:slug], act_slug)
  FileUtils.mkdir_p(act_dir)
  act[:dir] = act_dir

  used_names = Set.new
  body = act[:content_nodes].flat_map do |node|
    if node.name == "p"
      paragraph_markdown(node, act, used_names)
    elsif node.name == "ol" || node.name == "ul"
      list_markdown(node)
    else
      []
    end
  end.reject(&:empty?)

  data = {
    "layout" => "acte",
    "tipus" => "acte",
    "chapter" => chapter[:slug],
    "title" => act[:title],
    "label" => act[:label],
    "order" => act[:order]
  }
  data["published"] = false if body.empty?

  path = File.join(act_dir, "#{act_slug}.md")
  File.write(path, "#{yaml_front_matter(data)}---\n\n#{body.join("\n\n")}\n")
  act[:path] = path
  act[:body] = body
  act
end

def write_chapter(chapter)
  chapter_dir = File.join(DIARI_DIR, chapter[:slug])
  FileUtils.mkdir_p(chapter_dir)

  first_published = chapter[:acts].find { |act| act[:body]&.any? }
  first_text = first_published&.dig(:body)&.find { |block| !block.start_with?("![") }
  cover = first_published&.dig(:images)&.first
  cover_path = cover && "/diari/#{chapter[:slug]}/#{File.basename(File.dirname(first_published[:path]))}/#{cover}"

  data = {
    "layout" => "capitol",
    "tipus" => "capitol",
    "slug" => chapter[:slug],
    "title" => chapter[:title],
    "resum" => truncate_summary(first_text || chapter[:title]),
    "cover" => cover_path,
    "order" => chapter[:order]
  }

  File.write(File.join(chapter_dir, "index.md"), "#{yaml_front_matter(data)}---\n")
end

def main
  sections = parse_sections

  sections.each do |chapter|
    FileUtils.rm_rf(File.join(DIARI_DIR, chapter[:slug]))
  end

  sections.each do |chapter|
    chapter[:acts].each { |act| write_act(chapter, act) }
    write_chapter(chapter)
  end

  puts "Migrated #{sections.size} chapters and #{sections.sum { |chapter| chapter[:acts].size }} acts."
end

main if $PROGRAM_NAME == __FILE__
