#!/bin/bash

SOURCE=$1
CIBLE=$2

# 1. Vérifier si les arguments sont là
if [ -z "$SOURCE" ] || [ -z "$CIBLE" ]; then
    echo "Erreur : Il manque des arguments."
    echo "Utilisation : $0 <dossier_source> <dossier_cible>"
    exit 1
fi

# 2. Vérifier si la source existe
if [ ! -d "$SOURCE" ]; then
    echo "Erreur : Le dossier source '$SOURCE' n'existe pas."
    exit 1
fi

# 3. Vérifier ou créer la cible
if [ -d "$CIBLE" ]; then
    echo "Le dossier cible existe déjà."
else
    echo "Création du dossier cible..."
    mkdir -p "$CIBLE"
fi

# 4. Copier le contenu
echo "Copie en cours..."
cp -r "$SOURCE/"* "$CIBLE/"

echo "Terminé avec succès !"
