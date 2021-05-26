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

while [[ "${dateFin}" > "${dateNotifFin}" ]]
do
  echo "${dateNotifDebut} - ${dateNotifFin}"
  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'IDE=DE&IDN=X&listeCPV=&IDP=X&IDR=X&txtLibre=&txtLibreLieuExec=&dateNotifDebut='$(date -I -d "$dateNotifDebut")'&dateNotifFin='$(date -I -d "$dateNotifFin")'&txtAcheteurNom=&txtAcheteurSiret=&txtTitulaireNom=&txtTitulaireSiret=&txtLibreAcheteur=&txtLibreVille=&txtLibreRef=&txtLibreObjet=&dateParution=&dateExpiration=&annee=X&Rechercher=Rechercher' -c aws-cookie.txt -s -o /dev/null


  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'btnTelecharger=T%C3%A9l%C3%A9charger+les+Donn%C3%A9es+des+consultations' -b aws-cookie.txt -o aws-marchespublics-${dateNotifFin}.json -s

  cat aws-marchespublics-${dateNotifFin}.json | jq type 2> /dev/null
  is_valid=$?
  if [[ ${is_valid} -ne 0 ]]
  then
    rm "aws-marchespublics-${dateNotifFin}.json"
  fi


  dateNotifDebut="$(date -I -d "$dateNotifFin")"
  dateNotifFin="$(date -I -d "$dateNotifDebut + 3 days")"
done
