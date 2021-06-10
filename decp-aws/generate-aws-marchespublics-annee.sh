#!/usr/bin/env bash

# set -x

source $(dirname $0)/parameters.sh

oldFileName="old-aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"
intermediateFileName="tmp-aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"
newFileName="aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"

# Génération du fichier global
jq -n '{ marches: [ inputs.marches ] | add }' aws-marchespublics-$(date -d "$dateDebut" +%Y)*.json > "$intermediateFileName"
# rm aws-marchespublics-[0-9\-]*.json

# téléchargement du fichier annee-provisoire précédent
oldFileUrl=$(curl -s "https://www.data.gouv.fr/api/1/datasets/5cdb1722634f41416ffe90e2/"  | jq -r '.resources[].url | select (.|test("annee-'$(date +%Y)'"))')

echo "$oldFileUrl"
if [[ ! -z "$oldFileUrl" ]]
then
  curl $oldFileUrl -o "$oldFileName"
fi

if [[ -z "$(cat "$oldFileName")" ]]
then
  echo '{"marches": []}' > "$oldFileName"
fi

# diff pour extraire les nouveaux marchés
# command qui identifie les différences entre $oldFile et $intermediateFileName
diff_marches='diff <(jq ".marches[].id" $oldFileName | sort -u) <(jq ".marches[].id" $intermediateFileName | sort -u)'
# Sélection des différences correspondant aux nouveaux marchés
nouveaux_marches=$(eval $diff_marches | grep '>' | sed 's/> //g')
# Sélection des différences correspondant aux marchés disparus (plus présent dans $intermediateFileName alors qu'ils existaient dans $oldFile)
marches_disparus=$(eval $diff_marches | grep '<' | sed 's/< //g')

echo -e "Ancien fichier :        $(jq -M ".marches[].id" $oldFileName | sort -u | wc -l ) marchés uniques (via uid)\n
Nouveau fichier :       $(jq -M ".marches[].id" $intermediateFileName | sort -u | wc -l ) marchés uniques\n"

echo -e "$nouveaux_marches" > todayIds
python3.7 $(dirname $0)/generateDaily.py "$intermediateFileName" "$oldFileName" "todayIds" "daily-file.json"


# curl "$api/datasets/$dataset_id/upload/" -F "file=@results/decp_${date}.${ext}" -F "filename=decp_$date" -H "X-API-KEY: $api_key" > dailyResource.json

# ajout dans le nouveau fichier
jq -n '{ marches: [ inputs.marches ] | add }' daily-file.json "old-aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json" > "$newFileName"
