# Cròniques del Setè Mar

Web del Diari d’en Reiv: relats de la campanya, personatges i naus.

El contingut narratiu és a `diari/`, les pàgines del món a `mon/` i els
estils i recursos compartits a `assets/`. El web es construeix amb Jekyll.

## Desenvolupament del web

Cal Ruby 3.3.4 i Bundler. Instal·la les dependències i genera el lloc:

```sh
bundle install
bundle exec jekyll build
```

Per previsualitzar-lo localment:

```sh
bundle exec jekyll serve
```

La configuració pública és a `_config.yml` i el resultat es genera a `_site/`.
Les aportacions públiques contenen només prosa, pàgines i recursos seleccionats.
