#!/usr/bin/env bash

if [[ -z ${dateNotifDebut} ]]
then
    dateNotifDebut=$(date -I -d '-2 days')
fi


if [[ -z ${dateNotifFin} ]]
then
    dateNotifFin=$(date -I -d '-1 days')
fi

curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'IDE=DE&IDN=X&listeCPV=&IDP=X&IDR=X&txtLibre=&txtLibreLieuExec=&dateNotifDebut='$(date -I -d "$dateNotifDebut")'&dateNotifFin='$(date -I -d "$dateNotifFin")'&txtAcheteurNom=&txtAcheteurSiret=&txtTitulaireNom=&txtTitulaireSiret=&txtLibreAcheteur=&txtLibreVille=&txtLibreRef=&txtLibreObjet=&dateParution=&dateExpiration=&annee=X&Rechercher=Rechercher' -c aws-cookie.txt


curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'btnTelecharger=T%C3%A9l%C3%A9charger+les+Donn%C3%A9es+des+consultations' -b aws-cookie.txt -o aws-marchespublics-$(date -I).json
