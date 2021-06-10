import json
import sys
import time

# Nouveau fichier decp.json (du jour)
newFile = sys.argv[1]
oldFile = sys.argv[2]
todayIds = sys.argv[3]
outFile = sys.argv[4]
print('Fichier généré:', newFile)
print('Ancien fichier:', oldFile)
print('Fichier d\'ids d\'aujourd\'hui:', todayIds)
print('Fichier d\'aujourd\'hui (généré par ce script):', outFile)

debut = time.time()

listIdFile = open(todayIds, encoding='utf8')
content = listIdFile.read().splitlines()
f = open(newFile, encoding='utf8')
marches = json.load(f)
outFile = open(outFile, "w", encoding='utf8')

newMarches = {"marches" :[]}
for marche in marches['marches']:
    if str(marche['id']) in content:
        newMarches['marches'].append(marche)

outFile.write(json.dumps(newMarches,ensure_ascii=False, indent=4, sort_keys=True))
temps_ecoule = time.time() - debut
print("Temps de traitement en secondes", int(temps_ecoule))
outFile.close()
f.close()
