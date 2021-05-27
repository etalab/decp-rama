#!/usr/bin/env bash

if [[ -z ${dateNotifDebut} ]]
then
    dateDebut="$(date +%Y)-01-01"
fi

if [[ -z ${dateNotifFin} ]]
then
    dateFin=$(date -I -d '-1 days')
fi

dateNotifDebut="$dateDebut"
dateNotifFin="$(date -I -d "$dateNotifDebut + 3 days")"

# Téléchargement des données
while [[ "${dateFin}" > "${dateNotifFin}" ]]
do
  echo "${dateNotifDebut} - ${dateNotifFin}"
  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'IDE=DE&IDN=X&listeCPV=&IDP=X&IDR=X&txtLibre=&txtLibreLieuExec=&dateNotifDebut='$(date -I -d "$dateNotifDebut")'&dateNotifFin='$(date -I -d "$dateNotifFin")'&txtAcheteurNom=&txtAcheteurSiret=&txtTitulaireNom=&txtTitulaireSiret=&txtLibreAcheteur=&txtLibreVille=&txtLibreRef=&txtLibreObjet=&dateParution=&dateExpiration=&annee=X&Rechercher=Rechercher' -c aws-cookie.txt -s -o /dev/null


  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'btnTelecharger=T%C3%A9l%C3%A9charger+les+Donn%C3%A9es+des+consultations' -b aws-cookie.txt -o aws-marchespublics-${dateNotifFin}.json -s

  cat aws-marchespublics-${dateNotifFin}.json | jq type 2> /dev/null
  is_valid="$?"
  # JSON mal formé : tentative de correction
  if [[ "${is_valid}" != "0" ]]
  then
    echo "Fichier aws-marchespublics-${dateNotifFin}.json mal formé, tentative de correction"
    sed 's/([^,:{])\"([^,}:])/&1\\"&2/g' -i aws-marchespublics-${dateNotifFin}.json

    cat aws-marchespublics-${dateNotifFin}.json | jq type 2> /dev/null
    is_valid="$?"
    if [[ "${is_valid}" != "0" ]]
    then
      rm "aws-marchespublics-${dateNotifFin}.json"
      echo "Fichier aws-marchespublics-${dateNotifFin}.json mal formé donc non conservé"
    fi
  fi

  sleep 2s

  dateNotifDebut="$(date -I -d "$dateNotifFin")"
  dateNotifFin="$(date -I -d "$dateNotifDebut + 3 days")"
done

jq -n '{ marches: [ inputs.marches ] | add }' aws-marchespublics-$(date +%Y)*.json > aws-marchespublics-$(date +%Y).json
rm aws-marchespublics-$(date +%Y)*.json

# TODO un fichier annuel a poussé sur data.gouv.fr
#   sur un autre UID que le publish

# Faire un job séparé et donc pas d'intégration dans decp-rama
