# Cròniques del Setè Mar

Web de GitHub Pages per publicar una campanya de 7th Sea: el diari de partida,
material de construcció del món, personatges, naus i recursos visuals.

## Estructura general

El lloc esta muntat amb Jekyll i separa el contingut en tres grans blocs:

- `index.md`: portada principal del web. Usa `layout: landing`.
- `diari/`: subcomponent narratiu del web. Conte el Diari d'en Reiv, organitzat per capitols i actes.
- `mon/`: material de construcció del món, separat ara mateix en `personatges/` i `naus/`.
- `assets/images/`: recursos visuals compartits del web. El logo del joc viu a `assets/images/brand/7thseatitle.gif`.
- `assets/images/brand/`: logos i identitat visual.
- `assets/images/ui/`: lloc previst per a botons, marcs, fletxes, panells i altres peces d'interficie.

La navegacio global viu a `_layouts/default.html` i apunta sempre a:

- `/diari/`
- `/mon/personatges/`
- `/mon/naus/`

El text visible del header identifica el web com `Cròniques del Setè Mar`. El diari no es tracta com a marca global, sino com una seccio concreta del site.

Els estils visuals compartits son a `assets/css/style.css`. La idea estetica actual es una base de pergami beix, vermell fosc i detalls daurats, amb tipografia serif classica per mantenir un to de joc d'aventura i fantasia.

## Convencio de noms

El text que veu el lector ha d'estar sempre en catala: titols, menus, botons, textos d'ajuda, resums, labels visibles i contingut narratiu.

Els elements tecnics del codi han d'estar en angles:

- noms de layouts;
- classes CSS;
- variables Liquid;
- claus de front matter;
- valors interns com `type: chapter` o `type: character`;
- fitxers de dades dins `_data/`.

Les rutes publiques poden quedar en catala quan formen part de l'experiencia editorial del web, per exemple `/diari/`, `/mon/personatges/` i `/mon/naus/`.

Exemple de front matter correcte:

```yaml
---
layout: world_entry
type: character
title: "Reiv Anvil"
section_label: "Personatge"
summary: "Noble aventurer i cronista."
back_url: "/mon/personatges/"
order: 1
sheet:
  age: "Per determinar"
  origin: "Valdeluna, Castella"
---
```

## Layouts

Els layouts de `_layouts/` defineixen com es renderitza cada tipus de pagina. En general, les pagines `.md` nomes declaren metadades al front matter i el layout s'encarrega de llistar, ordenar i pintar el contingut.

### `default.html`

Layout base de tot el web.

Inclou:

- l'estructura HTML comuna;
- el `<head>` amb titol, descripcio i CSS;
- el logo superior;
- la navegacio principal;
- el contenidor `<main>` on s'injecta `{{ content }}`.

La resta de layouts hereten d'aquest amb:

```yaml
---
layout: default
---
```

Si cal canviar el menu superior, el logo o el CSS global, aquest es el fitxer que s'ha de tocar.

### `landing.html`

Layout de la portada principal del web, usat per `index.md`.

Renderitza:

- un bloc hero amb el logo del joc carregat des de `assets/images/brand/7thseatitle.gif`;
- un menu de contingut amb tres entrades: `diari d'en Reiv`, `personatges` i `naus`.

No llista contingut automaticament. Esta pensat com a porta d'entrada editorial i visual al site.

Front matter minim:

```yaml
---
layout: landing
title: "Portada"
---
```

### `home.html`

Layout de l'index del diari, usat per `diari/index.md`.

Busca automaticament totes les pagines amb:

```yaml
type: chapter
```

Les ordena per `order` i les mostra com a targetes amb:

- `cover`
- `title`
- `summary`
- `order`

Aquest layout no conte el text dels capitols; nomes en fa l'index.

Front matter minim:

```yaml
---
layout: home
title: "Diari d'en Reiv"
summary: "Text introductori del diari."
---
```

### `chapter.html`

Layout per a cada capitol del diari, per exemple `diari/capitol01/index.md`.

Busca automaticament tots els actes amb:

```yaml
type: act
chapter: chapter01
```

El valor de `chapter` de cada acte ha de coincidir amb el `slug` del capitol. Els actes es mostren ordenats per `order`.

Metadades principals d'un capitol:

```yaml
---
layout: chapter
type: chapter
slug: chapter01
title: "Titol del capitol"
summary: "Resum breu."
cover: "/diari/capitol01/cover.webp"
order: 1
---
```

Opcions especials:

- `hide_chapter_chrome: true`: amaga portada, resum i index d'actes. Va be per capitols especials o prolegs d'un sol acte.

El layout tambe crea els botons flotants:

- enrere cap a `/diari/`;
- tornar a dalt del capitol.

### `act.html`

Layout per a un acte individual, pensat per si mai es vol obrir un acte com a pagina independent.

Normalment els actes es renderitzen dins `chapter.html`, pero cada acte tambe te el seu propi `.md` amb aquest layout.

Front matter minim:

```yaml
---
layout: act
type: act
chapter: chapter01
title: "Titol de l'acte"
label: "Acte I"
order: 1
---
```

`label` es opcional. Si no existeix, el layout mostra `Acte {{ order }}`.

### `world_index.html`

Layout per als indexs de construcció del món, com:

- `mon/personatges/index.md`
- `mon/naus/index.md`

Busca automaticament les pagines que tenen `type` igual al valor de `item_type`.

Per exemple, `mon/personatges/index.md` fa:

```yaml
---
layout: world_index
title: "Personatges"
item_type: character
---
```

Aixo llista totes les pagines amb:

```yaml
type: character
```

Cada item pot mostrar:

- `section_label`
- `title`
- `summary`
- `order`

El layout tambe inclou botons flotants per tornar a la portada i tornar a dalt.

### `world_entry.html`

Layout per a fitxes concretes de construcció del món, tant personatges com naus.

S'usa ara mateix a:

- `mon/personatges/reiv/index.md`
- `mon/naus/corazon-sombrio/index.md`

Front matter comu:

```yaml
---
layout: world_entry
type: character
title: "Reiv Anvil"
section_label: "Personatge"
summary: "Descripcio breu per a indexs i meta description."
back_url: "/mon/personatges/"
order: 1
---
```

`back_url` controla on porta el boto flotant d'enrere. En personatges hauria de ser `/mon/personatges/`; en naus, `/mon/naus/`.

Quan `type: character` i existeix una clau `sheet:`, el layout renderitza automaticament una fitxa de dades abans del text descriptiu.

Exemple:

```yaml
sheet:
  age: "Per determinar"
  height: "Per determinar"
  build: "Atletica"
  origin: "Valdeluna, Castella"
  hair: "Castany"
  eyes: "Foscos"
  skin: "Clara"
  occupation: "Noble aventurer i cronista"
  affiliations:
    - "Companyia d'Alarik Dantes"
  traits:
    - "Impulsiu"
    - "Lleial"
```

L'ordre i el nom visible dels camps de la fitxa no es defineixen al layout, sino a `_data/character_fields.yml`. Aixo permet afegir o reordenar camps sense tocar HTML.

La plantilla base per crear nous personatges es:

```text
mon/personatges/_template.md
```

## Com afegir un capitol

Crea una carpeta nova dins `diari/`, per exemple `diari/capitol02/`, amb un `index.md`:

```yaml
---
layout: chapter
type: chapter
slug: chapter02
title: "Titol del capitol"
summary: "Resum breu per a la portada."
cover: "/diari/capitol02/cover.webp"
order: 2
---
```

## Com afegir un acte

Crea una carpeta nova dins el capitol, per exemple `diari/capitol02/acte01/acte01.md`:

```yaml
---
layout: act
type: act
chapter: chapter02
title: "Titol de l'acte"
order: 1
---
```

Les imatges de l'acte poden viure dins la mateixa carpeta i es poden referenciar de manera relativa:

```markdown
![Descripcio de la imatge](imatge-illa.webp)
```

La portada llistara automaticament els capitols i cada pagina de capitol llistara automaticament els actes ordenats per `order`.

## Postproduccio narrativa

Les instruccions operatives per convertir esborranys en actes literaris viuen a `.agent/actions/redaccio-acte.md`, `.agent/actions/revisio-acte.md` i `.agent/globals/estil-text.md`. L'arxiu `.agent/reiv-postproduccio.md` es conserva nomes com a compatibilitat historica.

Per usar-les en un xat, referencia l'arxiu al prompt:

```text
Aplica les instruccions de .agent/actions/redaccio-acte.md i transforma aquest esborrany en un fragment del Diari d'en Reiv.
Primer fes la planificacio per paragrafs i despres redacta el text final.
```

La guia operativa per generar o revisar prompts d'imatge viu a `.agent/actions/illustracio-acte.md` i `.agent/globals/estil-imatge.md`. Les fitxes canoniques estan separades per personatge dins `.agent/canon/personatges/`, per carregar nomes les necessaries en cada escena. L'arxiu `.agent/personatges-imatges.md` es conserva nomes com a compatibilitat historica.

```text
Aplica .agent/actions/illustracio-acte.md i revisa aquest prompt d'imatge perquè els personatges siguin coherents amb la biblia visual.
```
