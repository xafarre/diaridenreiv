# Diari d'en Reiv

Blog de GitHub Pages per publicar un diari de campanya de 7th Sea.

## Com afegir un capitol

Crea una carpeta nova dins `diari/`, per exemple `diari/capitol02/`, amb un `index.md`:

```yaml
---
layout: capitol
tipus: capitol
slug: capitol02
title: "Titol del capitol"
resum: "Resum breu per a la portada."
cover: "/diari/capitol02/cover.webp"
order: 2
---
```

## Com afegir un acte

Crea una carpeta nova dins el capitol, per exemple `diari/capitol02/acte01/acte01.md`:

```yaml
---
layout: acte
tipus: acte
chapter: capitol02
title: "Titol de l'acte"
order: 1
---
```

Les imatges de l'acte poden viure dins la mateixa carpeta i es poden referenciar de manera relativa:

```markdown
![Descripcio de la imatge](imatge-illa.webp)
```

La portada llistara automaticament els capitols i cada pagina de capitol llistara automaticament els actes ordenats per `order`.
