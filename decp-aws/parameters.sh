#!/usr/bin/env bash


export api="https://www.data.gouv.fr/api/1"
export dataset_id="5cdb1722634f41416ffe90e2"

if [[ -z ${dateDebut} ]]
then
    dateDebut="$(date +%Y)-01-01"
fi

if [[ -z ${dateFin} ]]
then
    dateFin=$(date -I -d '-1 days')
fi
