# DECP JSON

> Toutes les données essentielles de la commande publique converties en JSON.

**Version 1.0.0**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'identifier toutes les sources de DECP, et de créer des scripts permettant de produire des fichiers JSON utilisables ([exemple fictif sur le dépôt officiel](https://github.com/etalab/format-commande-publique/blob/master/exemples/json/paquet.json)).

La procédure standard est la suivante :

1. J'agrège toutes les données possibles dans leur format d'origine, **XML ou JSON** (les DECP n'existent pas dans d'autres formats)
2. Je les stocke dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage, conversion depuis XML)
3. Je les convertis au format JSON réglementaire, en rajoutant un champ `source`. Certaines données sources n'étant pas valide (par exemple si certains champs manquent), les données JSON ne seront pas non plus valides. Je prends le parti de les garder.
4. Je crée une archive ZIP avec le JSON converti. Ces ZIP sont sauvegardés dans le dépot Git, vous les trouverez dans `/json`

**Si vous avez connaissance de données essentielles de la commande publique facilement accessibles (téléchargement en masse possible) et qui ne sont pas encore identifiées ci-dessous, merci de [m'en informer](#contact).**

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON
- [jq](https://stedolan.github.io/jq/) pour la conversion JSON vers JSON (disponible dans les dépôts Ubuntu)
- pouvoir exécuter des scripts bash

## Mode d'emploi

Vous trouverez les `code` possibles dans le tableau plus bas.

### Télécharger les données

```
./get.sh [code]
```
### Convertir les données

Les données doivent avoir été téléchargées.

```
./convert.sh [code]
```

### Créer une archive ZIP des données JSON converties

Les données doivent avoir été converties.

```
./package.sh [code]
```

### Supprimer les données JSON converties

Les données doivent avoir été converties. Il est recommander de créer une archive ZIP auparavant, au cas où.

```
./clean.sh [code]
```


## Sources de données

| Code               | Description                                          | URL                                                           | Statut       |
| ------------------ | ---------------------------------------------------- | ------------------------------------------------------------- | ------------ |
| `data.gouv.fr_pes` | Données des collectivités publiées via le PES Marché | https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57 | **Intégrée** |
|                    | Données de l'État publiées par l'AIFE                | https://www.data.gouv.fr/fr/datasets/5bd789ee8b4c4155bd9a0770 | Identifiée   |

## Contact

Vous pouvez :

- m'écrire un mail à [colin@maudry.com]
- me trouver sur Twitter ([@col1m](https://twitter.com/col1m))
- intéragir avec ce dépôt sur Github (issues, pull request).

## License

Le code source de ce projet est publié sous licence [Unlicense](http://unlicense.org).

## Notes de version

### 1.0.0

- support des [données PES marché publiées sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57/) (`data.gouv.fr_pes`)
