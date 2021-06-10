!/bin/bash


#**********************************************************************
#
# Publication des données agrégées dans un jeu de données sur data.gouv.fr
#**********************************************************************

# /!\ Le dataset doit avoir été créé et une ressource decp.json doit avoir été ajoutée
# à ce dataset.

# fail on error
set -e

https://www.data.gouv.fr/fr/datasets/r/


export api="https://www.data.gouv.fr/api/1"
export dataset_id="5cdb1722634f41416ffe90e2"
export resource_id_json="5cdb1722634f41416ffe90e2"


#API_KEY configurée dans les options de build de CircleCI
api_key=$API_KEY

if [[ ! -f ./json/decp.json ]]
then
    echo "Le fichier agrégé ./json/decp.json doit d'abord être généré avec la commande './merge_all_sources.sh'."
    exit 1
fi

echo "Remplacement de decp.json et decp.xml par leur mise à jour quotidienne"

for ext in json xml
do
    case $ext in
        xml)
        resource_id=$resource_id_xml
        ;;

        json)
        resource_id=$resource_id_json
        ;;
    esac

    echo "Mise à jour de decp.${ext}..."

    curl "$api/datasets/$dataset_id/resources/${resource_id}/upload/" -F "file=@${ext}/decp.${ext}" -H "X-API-KEY: $api_key"

    date=`date "+%F"`

    echo "Publication de decp_$date.${ext}..."


    idDailyResource=`jq -r '.id' dailyResource.json`

    # Change le type de ressource de 'main' à 'update'
    curl -X PUT "$api/datasets/$dataset_id/resources/$idDailyResource/" --data '{"type":"update"}' -H "Content-type: application/json" -H "X-API-KEY: $api_key"

    rm dailyResource.json

done

echo "Mise à jour des données au format OCDS..."
curl "$api/datasets/$dataset_id/resources/${resource_id_ocds}/upload/" -F "file=@json/decp.ocds.json" -H "X-API-KEY: $api_key"
