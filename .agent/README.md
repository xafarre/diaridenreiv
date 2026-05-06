# Agents per a una campanya de 7e Mar

Aquest directori conte instruccions modulars per a agents IA que redacten, revisen, il.lustren i produeixen actes d'una campanya de 7e Mar.

`.agent` ha de ser independent de la partida concreta. No hi ha d'haver canon de personatges, llocs, naus, objectes ni trames dins d'aquest directori. El context viu al projecte, principalment a `mon/` i `diari/`.

## Estructura

- `globals/`: instruccions estables d'estil textual i visual.
- `actions/`: protocols de tasca per redactar, revisar, il.lustrar o produir actes.
- `templates/`: plantilles reutilitzables de dades, com fitxes de personatge.
- `examples/`: exemples bons de sortida per calibrar futurs agents.

## Fonts de context de partida

Els agents han de buscar informacio especifica de la campanya fora de `.agent`:

- `mon/personatges/`: personatges, fitxes, descripcions completes, imatge inicial source of truth, variants visuals i notes lliures.
- `mon/naus/`: naus i embarcacions recurrents.
- `mon/llocs/`: llocs recurrents.
- `mon/objectes/`: objectes, reliquies, armes o artefactes recurrents, si existeix.
- `diari/capitolXX/`: capitols i actes ja escrits.
- `diari/capitolXX/acteYY/acteYY.md`: estructura esperada d'un acte.

## Accions

- `actions/redaccio-acte.md`: transforma un esborrany brut en un acte narratiu curat.
- `actions/revisio-acte.md`: postprodueix un acte existent i el poleix dins el context de la campanya.
- `actions/illustracio-acte.md`: selecciona escenes i genera prompts visuals coherents.
- `actions/produccio-acte.md`: orquestra redaccio, il.lustracio i revisio per produir un acte complet.

## Regla d'us

Els fitxers d'accio han de carregar sempre els globals que indiquen a la seccio `Carrega obligatoria`.

Abans de redactar, revisar o il.lustrar, l'agent ha d'identificar quina informacio de `mon/` i `diari/` es rellevant per a la tasca. No ha de carregar tot el canon indiscriminadament: ha de cercar noms, llocs, naus, objectes, capitol i actes propers, i obrir nomes els fitxers necessaris.

## Compatibilitat

Els fitxers d'arrel `postproduccio.md` i `personatges-imatges.md` son recordatoris historics i redirigeixen cap a les accions actuals. Les fonts operatives son `globals/`, `actions/`, `templates/`, `mon/` i `diari/`.
