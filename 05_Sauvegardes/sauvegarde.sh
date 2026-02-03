#!/bin/bash

DOSSIER_A_SAUVEGARDER=$1

# 1. Vérification : A-t-on donné un dossier en argument ?
if [ -z "$DOSSIER_A_SAUVEGARDER" ]; then
    echo "Erreur : Vous devez spécifier le dossier à sauvegarder."
    echo "Usage : $0 <nom_du_dossier>"
    exit 1
fi

# 2. Vérification : Le dossier existe-t-il ?
if [ ! -d "$DOSSIER_A_SAUVEGARDER" ]; then
    echo "Erreur : Le dossier '$DOSSIER_A_SAUVEGARDER' n'existe pas."
    exit 1
fi

# 3. Construction du nom de l'archive avec la date
# $(date +%F) récupère la date au format YYYY-MM-DD (ex: 2023-10-25)
DATE_ACTUELLE=$(date +%F)
NOM_ARCHIVE="archive_$DATE_ACTUELLE.tar.gz"

echo "Création de l'archive '$NOM_ARCHIVE' en cours..."

# 4. Création de l'archive compressée
# -c : créer une archive
# -z : compresser avec gzip (.gz)
# -f : indiquer le nom du fichier de sortie
tar -czf "$NOM_ARCHIVE" "$DOSSIER_A_SAUVEGARDER"

# 5. Vérification du succès
if [ $? -eq 0 ]; then
    echo "Succès ! Sauvegarde créée : $NOM_ARCHIVE"
else
    echo "Une erreur est survenue lors de la compression."
fi
