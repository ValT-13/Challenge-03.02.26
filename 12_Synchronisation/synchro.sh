#!/bin/bash

# --- CONFIGURATION ---
SOURCE=$1
DEST=$2
LOG_FILE="journal_synchro.log"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Vérification des arguments
if [ -z "$SOURCE" ] || [ -z "$DEST" ]; then
    echo -e "${YELLOW}Usage : $0 <Dossier_Source> <Dossier_Destination>${NC}"
    echo "Exemple : $0 /home/val/Images /backup/Images"
    exit 1
fi

# 2. Vérification que la source existe
if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Erreur : Le dossier source '$SOURCE' n'existe pas.${NC}"
    exit 1
fi

# 3. Vérification de l'outil rsync
if ! command -v rsync &> /dev/null; then
    echo -e "${YELLOW}L'outil 'rsync' n'est pas installé. Installation...${NC}"
    sudo apt update -qq && sudo apt install -y rsync
fi

# 4. Préparation de la destination
if [ ! -d "$DEST" ]; then
    echo -e "${BLUE}Le dossier destination '$DEST' n'existe pas. Création...${NC}"
    mkdir -p "$DEST"
fi

# 5. Gestion du BONUS (Suppression)
echo ""
echo -e "${BLUE}--- OPTION DE SYNCHRONISATION ---${NC}"
echo "Voulez-vous activer le mode MIROIR ?"
echo "⚠️  Cela SUPPRIMERA dans la destination les fichiers qui ne sont plus dans la source."
read -p "Activer le mode miroir ? (o/n) : " REPONSE

OPTIONS="-av --stats --human-readable"

if [[ "$REPONSE" == "o" || "$REPONSE" == "O" ]]; then
    OPTIONS="$OPTIONS --delete"
    echo -e "${YELLOW}⚡ Mode MIROIR activé (avec suppression).${NC}"
else
    echo -e "${GREEN}✅ Mode CLASSIQUE (copie seulement).${NC}"
fi

echo ""
echo "Démarrage de la synchronisation..."
echo "-----------------------------------"

# 6. Lancement de la synchronisation
# -a : archive (garde les permissions, dates, tout)
# -v : verbose (affiche les fichiers copiés)
# --stats : affiche le résumé à la fin
# --delete : (optionnel) supprime les fichiers en trop
rsync $OPTIONS "$SOURCE/" "$DEST/"

# Vérification du code de retour ($?)
if [ $? -eq 0 ]; then
    echo "-----------------------------------"
    echo -e "${GREEN}✔ Synchronisation terminée avec succès !${NC}"
    
    # Log de l'opération
    echo "[$(date)] SUCCESS: $SOURCE -> $DEST" >> "$LOG_FILE"
else
    echo "-----------------------------------"
    echo -e "${RED}✖ Erreur lors de la synchronisation.${NC}"
    echo "[$(date)] ERROR: $SOURCE -> $DEST" >> "$LOG_FILE"
fi
