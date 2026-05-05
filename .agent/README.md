# Agents del Diari d'en Reiv

Aquest directori conte instruccions modulars per a agents IA que produeixen, revisen i il.lustren actes del Diari d'en Reiv.

## Estructura

- `globals/`: instruccions estables que defineixen estil textual i visual.
- `actions/`: protocols de tasca per redactar, revisar, il.lustrar o produir actes.
- `canon/`: biblioteca canonica de personatges, naus, llocs i objectes.
- `examples/`: exemples bons de sortida per calibrar futurs agents.

## Globals

- `globals/estil-text.md`: veu narrativa, criteris literaris, temps verbal, estructura i coherencia del diari.
- `globals/estil-imatge.md`: canon visual, criteris d'il.lustracio, us de fitxes de personatges i prompts d'imatge.

## Accions

- `actions/redaccio-acte.md`: transforma un esborrany brut en un acte narratiu curat.
- `actions/revisio-acte.md`: postprodueix un acte existent i el poleix dins el context del diari.
- `actions/illustracio-acte.md`: selecciona escenes i genera un conjunt coherent de prompts visuals per a l'acte.
- `actions/produccio-acte.md`: orquestra redaccio, il.lustracio i revisio per produir un acte complet.

## Canon

- `canon/personatges/`: fitxes visuals canonices dels personatges.
- `canon/naus/`: fitxes visuals canonices de naus i elements recurrents.
- `canon/llocs/`: llocs recurrents, quan calgui formalitzar-los.
- `canon/objectes/`: objectes recurrents, quan calgui formalitzar-los.

## Regla d'us

Els fitxers d'accio han de carregar sempre els fitxers globals que indiquen a la seccio `Carrega obligatoria`. Les fitxes canonices nomes s'han de llegir quan el personatge, nau, lloc o objecte apareix en l'acte.

Els fitxers de l'arrel `reiv-postproduccio.md` i `personatges-imatges.md` son compatibilitat historica. Les fonts operatives viuen a `globals/`, `actions/` i `canon/`.
