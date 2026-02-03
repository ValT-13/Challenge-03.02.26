#!/bin/bash

# --- CONFIGURATION ---
FICHIER_LISTE="liste_paquets.txt"
RAPPORT="rapport_installation.txt"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Vérification Root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Erreur : Ce script doit être lancé avec sudo.${NC}"
    exit 1
fi

# 2. Vérification de la liste
if [ ! -f "$FICHIER_LISTE" ]; then
    echo -e "${RED}Erreur : Le fichier $FICHIER_LISTE est introuvable.${NC}"
    exit 1
fi

# Initialisation du rapport
echo "--- RAPPORT D'INSTALLATION ($(date)) ---" > "$RAPPORT"

# Compter le nombre total de paquets (wc -l compte les lignes)
# < "$FICHIER_LISTE" permet d'éviter d'afficher le nom du fichier dans le résultat
TOTAL_PAQUETS=$(wc -l < "$FICHIER_LISTE")
CURRENT=0
SUCCES=0
ECHECS=0

echo -e "${BLUE}Début de l'installation de $TOTAL_PAQUETS paquets...${NC}"
echo "---------------------------------------------------"

# 3. Boucle de lecture du fichier ligne par ligne
# On lit tout le fichier d'un coup dans une variable
# Cela libère l'entrée standard pour tes réponses au clavier
for PAQUET in $(cat "$FICHIER_LISTE"); do
    
    # On saute les lignes vides
    if [ -z "$PAQUET" ]; then continue; fi

    ((CURRENT++))
    PREFIX="[$CURRENT/$TOTAL_PAQUETS] $PAQUET"

    # Vérification si déjà installé
    if dpkg -s "$PAQUET" &> /dev/null; then
        echo -e "${YELLOW}✔ $PREFIX est déjà installé.${NC}"
        echo "[DÉJÀ LÀ] $PAQUET" >> "$RAPPORT"
        ((SUCCES++))
    else
        # Si pas installé, on propose de le faire
        echo -e "${BLUE}➜ $PREFIX n'est pas installé.${NC}"
        
        # Ici, le read va bien attendre ton clavier !
        read -p "   Voulez-vous l'installer maintenant ? (o/n) : " REPONSE 

        if [[ "$REPONSE" == "o" || "$REPONSE" == "O" ]]; then
            echo "   Installation en cours..."
            sudo apt update -qq && sudo apt install -y "$PAQUET" &> /dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}   ✔ Installation réussie !${NC}"
                echo "[OK] $PAQUET installé avec succès" >> "$RAPPORT"
                ((SUCCES++))
            else
                echo -e "${RED}   ✖ Échec de l'installation.${NC}"
                echo "[ERREUR] Impossible d'installer $PAQUET" >> "$RAPPORT"
                ((ECHECS++))
            fi
        else
            echo "   Installation ignorée."
            echo "[IGNORÉ] $PAQUET" >> "$RAPPORT"
        fi
    fi
    echo "---------------------------------------------------"

done

# 4. Résumé Final
echo ""
echo -e "${BLUE}=== BILAN FINAL ===${NC}"
echo -e "Succès (ou déjà là) : ${GREEN}$SUCCES${NC}"
echo -e "Erreurs             : ${RED}$ECHECS${NC}"
echo "Le rapport détaillé est dans : $RAPPORT"
