!/bin/bash

# fail on error
set -e

source $(dirname $0)/parameters.sh

newFileName="aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"


if [[ ! -f ${newFileName} ]]
then
    echo "Le fichier agrégé ./json/decp.json doit d'abord être généré avec la commande './merge_all_sources.sh'."
    exit 1
fi

resource_id="$(curl "https://www.data.gouv.fr/api/1/datasets/${dataset_id}/" | jq -r '.resources[] | select(.url | test(".*/'$(basename $newFileName)'")) | .id')"
if [[ -z $resource_id ]]
then
  curl "$api/datasets/$dataset_id/upload/" -F "file=@@${newFileName}" -F "filename=$(basename ${newFileName})" -H "X-API-KEY: $api_key" > resource.json
  resource_id=`jq -r '.id' resource.json`
fi

curl "$api/datasets/${dataset_id}/resources/${resource_id}/upload/" -F "file=@${newFileName}" -H "X-API-KEY: $api_key"
