# User Requirements: Registre estandarditzat de personatges

## Objectiu

Crear un sistema de fitxes estandarditzades per mantenir el registre dels Herois de la campanya de 7è Mar, separant:

- La fitxa mecanica i evolutiva del personatge.
- La descripcio fisica, estetica i de caracter, estable i independent de l'evolucio mecanica.
- Les imatges canon de referencia visual.
- La publicacio inicial de descripcions breus a la pestanya `Personatges` de la web.

El sistema ha de permetre actualitzar els personatges durant la campanya sense perdre la seva identitat visual canonica ni barrejar dades de joc amb descripcio narrativa.

## Fonts d'entrada

- Full de personatge editable: `assets/guides/full-personatje-edit.pdf`.
- Guia resum de regles: `assets/guides/guia-resum-7mar.md`.
- Canon existent: `.agent/canon/personatges/`.
- Imatges font actuals: `.olddiary/septimo-mar-portada-<personatge>.png`.
- Web actual de personatges: `mon/personatges/`.

## Analisi del full de personatge

El PDF `full-personatje-edit.pdf` te dues pagines.

La pagina principal conte:

- Caracteristiques: `Musculo`, `Mana`, `Ingenio`, `Brio`, `Donaire`.
- Informacio: nom, jugador, nacionalitat, professio, organitzacions, experiencia.
- Trasfons.
- Avantatges.
- Reputacio i daus totals.
- Arcano.
- Habilitats civils.
- Motxilla.

La pagina de combat i evolucio conte:

- Daus d'accio.
- Capacitats de defensa, amb defensa passiva i activa.
- Ferides superficials, ferides dramatiques, tirada de ferides, inconsciencia.
- Escola d'esgrima i mestratge.
- Herencia de bruixeria i mestratge.
- Habilitats marcials.
- Armes, amb tipus, nivell, dany, abast, curt/llarg i recarrega.
- Habilitats especials.

Aixo suggereix que la fitxa mecanica ha de ser una estructura de dades amb llistes repetibles, no un document lliure. Les habilitats, armes, avantatges, trasfons, defenses i transformacions han de poder creixer durant la campanya.

## Decisio de format

S'utilitzara `YAML` com a format principal.

Motivacio:

- Ja s'utilitza YAML al front matter de Jekyll.
- Es llegible i editable a ma.
- Permet comentaris.
- Representa be llistes de capacitats, armes, variants i notes.
- Es pot convertir facilment a JSON si mes endavant cal una API, validacio automatica o base de dades.

No es requereix una base de dades en aquesta fase. La font de veritat sera el sistema de fitxers del repositori.

## Estructura de carpetes requerida

Les plantilles viuran a `.agent/templates/`:

```text
.agent/templates/personatge-fitxa.yml
.agent/templates/personatge-descripcio.yml
```

Cada personatge documentat viura a:

```text
mon/personatges/<nompersonatge>/
```

Cada carpeta de personatge contindra com a minim:

```text
mon/personatges/<nompersonatge>/fitxa.yml
mon/personatges/<nompersonatge>/descripcio.yml
mon/personatges/<nompersonatge>/index.md
mon/personatges/<nompersonatge>/portada.<ext>
```

La imatge `portada.<ext>` sera una copia local de la imatge canon trobada a `.olddiary/`. La imatge de portada ha de considerar-se la font visual de referencia per a la descripcio fisica i per a futures generacions d'imatge.

## Regles per valors desconeguts

- Camps obligatoris textuals desconeguts: `null`.
- Camps obligatoris numerics desconeguts: `0`.
- Camps opcionals textuals desconeguts: `""`.
- Camps opcionals de llista desconeguts: `[]`.
- Camps opcionals d'objecte desconeguts: `{}`.

Cada plantilla ha d'indicar quins camps son obligatoris.

## Template 1: `personatge-fitxa`

La fitxa representa l'estat mecanic i evolutiu del personatge. Pot canviar despres de cada sessio.

### Estructura base requerida

Totes les instancies han de conservar aquestes claus. Cada valor pot ser obligatori o opcional segons la politica de valors desconeguts.

```yaml
schema: "personatge-fitxa/v1"
id: null
nom: null
jugador: ""
estat_campanya:
  actiu: true
  ultima_actualitzacio: null
  sessio_o_acte: ""
identitat_joc:
  nacionalitat: null
  professio: ""
  organitzacions: []
  reputacio:
    punts: 0
    daus_totals: 0
  experiencia:
    total: 0
    gastada: 0
    disponible: 0
caracteristiques:
  musculo: 0
  mana: 0
  ingenio: 0
  brio: 0
  donaire: 0
arcano:
  tipus: ""
  nom: ""
  efecte_resum: ""
avantatges: []
trasfons: []
habilitats:
  civils: []
  marcials: []
combat:
  daus_accio: []
  defenses: []
  ferides:
    superficials_actuals: 0
    dramatiques_actuals: 0
    tirada_ferides: 0
    inconscient: false
  armes: []
esgrima:
  escoles: []
bruixeria:
  herencies: []
habilitats_especials: []
motxilla: []
formes_i_vestimentes: []
notes: ""
```

### Estructura recomanada de llistes

`avantatges`:

```yaml
- nom: "Dureza"
  cost_ph: 5
  font: "Guia del Jugador"
  efecte: "Dau guardat addicional a tirades de ferides."
  notes: ""
```

`trasfons`:

```yaml
- nom: "Vendetta"
  valor: 2
  estat: "actiu"
  descripcio: ""
  resolucio: ""
```

`habilitats.civils` i `habilitats.marcials`:

```yaml
- nom: "Cazador"
  tipus: "civil"
  capacitats:
    - nom: "Rastrear"
      nivell: 3
      tipus: "basica"
      notes: ""
```

`combat.defenses`:

```yaml
- nom: "Juego de Piernas"
  passiva: 15
  activa: 0
  font_capacitat: "Atleta"
  notes: ""
```

`combat.armes`:

```yaml
- nom: "Espasa d'esgrima"
  tipus: "cos_a_cos"
  nivell: 0
  dany: "2g2"
  abast: ""
  curt_llarg: ""
  recarrega: ""
  notes: ""
```

`esgrima.escoles`:

```yaml
- nom: "Aldana"
  pais: "Castilla"
  grau: "Aprendiz"
  mestratge: 1
  capacitats:
    - nom: "Finta"
      nivell: 1
  debilitat_coneguda: ""
  notes: ""
```

`bruixeria.herencies`:

```yaml
- nom: "Pyeryem"
  tipus_sang: "Sangre Pura"
  grau: "Aprendiz"
  punts_hechiceria: 0
  capacitats:
    - nom: "Llop"
      nivell: 0
      efecte: ""
  notes: ""
```

### Camp especial: `formes_i_vestimentes`

Aquest camp documenta variants visuals o funcionals del personatge que poden apareixer en joc. Ha de cobrir transformacions magiques, disfresses, canvis d'armadura i vestimenta contextual.

Exemples previstos:

- `Reiv disfressat de pobre`.
- `Kamui sense armadura`.
- `Alina transformada en llop`.
- `Alina transformada en mussol`.
- `Alina amb roba de caçadora d'hivern`.

Estructura:

```yaml
- id: "alina-llop"
  nom: "Alina transformada en llop"
  tipus: "transformacio"
  estat: "canon"
  vinculada_a:
    sistema: "Pyeryem"
    capacitat: "Llop"
  descripcio_curta: ""
  efectes_mecanics: ""
  restriccions: ""
  imatge_referencia: ""
  notes_visuals: ""
  notes_joc: ""
```

Valors recomanats per `tipus`:

- `vestimenta`
- `disfressa`
- `armadura`
- `transformacio`
- `ferida_o_estat`
- `altre`

## Template 2: `personatge-descripcio`

La descripcio representa la identitat fisica, estetica, veu i caracter del personatge. No hauria de canviar per increments d'experiencia, ferides temporals o equip puntual, excepte quan es consolidi un canvi canon.

### Estructura base requerida

Totes les instancies han de conservar aquestes claus. Cada valor pot ser obligatori o opcional segons la politica de valors desconeguts.

```yaml
schema: "personatge-descripcio/v1"
id: null
nom: null
imatge_portada:
  path: null
  source_of_truth: true
  origen: ""
resum_web: null
descripcio_fisica:
  edat_aparent: ""
  edat_real: ""
  alcada: ""
  constitucio: ""
  pell: ""
  ulls: ""
  cabell: ""
  rostre: ""
  marques_distintives: []
  postura_i_moviment: ""
  veu: ""
  olor_o_presencia: ""
  mans: ""
  gestos_recorrents: []
vestuari_base:
  silueta: ""
  peces_principals: []
  colors: []
  materials: []
  armes_visibles: []
  joies_i_objectes: []
  notes: ""
caracter:
  primera_impressio: ""
  temperament: ""
  virtuts_visibles: []
  defectes_visibles: []
  pors_o_tensions: []
  manera_de_parlar: ""
  relacio_amb_el_grup: ""
  contradiccions: []
biografia_breu: ""
referencies_visuals:
  prompts_base: []
  evitar: []
variants_visuals: []
notes_canon: ""
```

### `resum_web`

`resum_web` es el paragraf curt que es publicara a la pestanya `Personatges` en aquesta fase. Ha de ser prosa, no llista.

Requisits del paragraf:

- 40-90 paraules.
- Escrit en catala.
- Centrat en descripcio fisica i presencia.
- Pot insinuar caracter, pero no ha d'explicar tota la biografia.
- Ha de respectar la imatge `portada` com a font estetica.

### `variants_visuals`

Aquest camp pot repetir o ampliar les variants de `formes_i_vestimentes`, pero des del punt de vista visual i descriptiu. La font mecanica continua sent `fitxa.yml`.

```yaml
- id: "kamui-sense-armadura"
  nom: "Kamui sense armadura"
  tipus: "vestimenta"
  descripcio_visual: ""
  diferencies_respecte_base: ""
  prompt_visual: ""
  imatge_referencia: ""
```

## Personatges inicials esperats

Cal crear carpeta i fitxers per als personatges amb imatge de portada present a `.olddiary/`:

- `alina`
- `antonella`
- `cedric`
- `eryn`
- `gunnar`
- `helen`
- `kamui`
- `kelsier`
- `reiv`

Si hi ha personatges canonics sense portada local clara, no s'han de forçar en aquesta primera migracio. Es poden afegir despres quan tinguin imatge font.

## Regles d'analisi d'imatge

Per cada personatge:

1. Obrir la imatge de portada corresponent.
2. Comparar-la amb `.agent/canon/personatges/<nom>.md` si existeix.
3. Si la imatge contradiu el canon textual, preval la imatge per a trets visuals actuals.
4. Registrar diferencies importants a `notes_canon`.
5. No inventar dades mecaniques a partir de la imatge.
6. Les dades estetiques incertes han de quedar com a `""`, no com a afirmacions.

## Requisits de migracio inicial

Per cada personatge inicial:

- Crear `fitxa.yml` a partir de `.agent/templates/personatge-fitxa.yml`.
- Crear `descripcio.yml` a partir de `.agent/templates/personatge-descripcio.yml`.
- Copiar la portada des de `.olddiary/` a `mon/personatges/<nompersonatge>/portada.<ext>`.
- Crear o actualitzar `index.md` del personatge.
- Emplenar dades conegudes des del canon existent.
- Emplenar dades visuals despres d'analitzar la portada.
- Deixar buits els camps desconeguts segons les regles de valors desconeguts.

## Requisits per a la web en aquesta fase

La pestanya `Personatges` ha de mostrar cada personatge documentat.

Per ara, la pagina individual de cada personatge nomes ha d'incloure:

- Nom.
- Imatge de portada.
- Paragraf curt de descripcio fisica, procedent de `descripcio.yml > resum_web`.
- Resum curt per a la targeta/index.

No s'ha d'afegir encara:

- Fitxa mecanica completa.
- Bio extensa.
- Personalitat detallada.
- Llistes d'habilitats, avantatges o arcans.

Aquests blocs quedaran preparats a les dades, pero no visibles fins a una fase posterior.

## Requisits tecnics de la web

- Mantenir compatibilitat amb Jekyll.
- Evitar duplicar dades: `index.md` ha de contenir el minim necessari per renderitzar la pagina.
- Si Jekyll no pot llegir YAML extern de forma senzilla sense plugins, es permet duplicar temporalment `resum_web`, `summary` i `image` al front matter, indicant que la font canonica continua sent `descripcio.yml`.
- No modificar l'estil global mes del necessari.
- La UI ha de mantenir el to visual del lloc actual.

## Criteris d'acceptacio

La primera execucio del projecte es considerara completa quan:

- Existeixin les dues plantilles a `.agent/templates/`.
- Cada personatge inicial amb portada tingui carpeta a `mon/personatges/<nompersonatge>/`.
- Cada carpeta tingui `fitxa.yml`, `descripcio.yml`, `index.md` i `portada.<ext>`.
- Les fitxes mecanices continguin tots els camps obligatoris.
- Les descripcions continguin tots els camps obligatoris.
- Els camps desconeguts compleixin la politica de `null`, `0`, `""`, `[]` o `{}`.
- Les imatges de portada hagin estat revisades i siguin la referencia visual principal.
- La pagina `mon/personatges/` llisti els personatges.
- Cada pagina individual mostri un paragraf curt de descripcio fisica en prosa.
- El projecte Jekyll construeixi sense errors.

## Fora d'abast en aquesta fase

- Crear una base de dades real.
- Crear una API.
- Automatitzar completament la validacio amb JSON Schema.
- Publicar fitxes mecaniques completes a la web.
- Redissenyar la seccio de personatges.
- Generar noves imatges.
- Resoldre totes les dades desconegudes de les fitxes de joc.

## Decisions pendents

- Confirmar si els noms de carpeta han de ser curts (`reiv`) o complets amb slug (`reiv-anvil`).
- Confirmar si els personatges sense imatge de portada s'han d'incloure igualment en una fase posterior.
- Decidir si les variants visuals han de tenir imatge propia quan existeixin, o nomes descripcio.
- Decidir si el canon antic a `.agent/canon/personatges/` es mantindra com a font complementaria o si quedara substituit progressivament per `mon/personatges/<nom>/descripcio.yml`.
