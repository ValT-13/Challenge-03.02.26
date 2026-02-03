#!/bin/bash

# --- CONFIGURATION ---
JOURS=$1
JOURNAL_OPERATION="historique_nettoyage.log"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Vérifications de base (Sudo + Argument)
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Erreur : Il faut être root (sudo) pour nettoyer /var/log.${NC}"
    exit 1
fi

if [ -z "$JOURS" ]; then
    echo -e "${YELLOW}Usage : sudo $0 <nombre_de_jours>${NC}"
    echo "Exemple : sudo $0 7 (Supprime les logs de plus de 7 jours)"
    exit 1
fi

echo -e "${YELLOW}Recherche des fichiers logs de plus de $JOURS jours dans /var/log...${NC}"

# 2. Recherche des fichiers
# find /var/log : cherche dans le dossier logs
# -type f : cherche seulement des fichiers (pas des dossiers)
# \( ... \) : groupe les conditions de nom (.log OU .gz)
# -mtime +$JOURS : "modification time" supérieur à X jours
FICHIERS=$(find /var/log -type f \( -name "*.log" -o -name "*.gz" \) -mtime +$JOURS)

# 3. Si aucun fichier n'est trouvé, on arrête
if [ -z "$FICHIERS" ]; then
    echo -e "${GREEN}Aucun fichier ancien trouvé. Votre système est propre !${NC}"
    exit 0
fi

# 4. Affichage de la liste et calcul de la taille
echo ""
echo "Voici la liste des fichiers à supprimer :"
echo "---------------------------------------"
# On passe la liste des fichiers à 'du -h' pour voir leur taille
echo "$FICHIERS" | xargs du -h
echo "---------------------------------------"

# Calcul de l'espace total qui sera libéré (la dernière ligne de du -ch donne le total)
TAILLE_TOTALE=$(echo "$FICHIERS" | xargs du -ch | tail -n 1 | awk '{print $1}')
echo -e "Espace disque qui sera libéré : ${RED}$TAILLE_TOTALE${NC}"

# 5. Demande de confirmation
echo ""
read -p "Voulez-vous vraiment supprimer ces fichiers ? (o/n) : " REPONSE

if [ "$REPONSE" == "o" ] || [ "$REPONSE" == "O" ]; then
    echo "Suppression en cours..."
    
    # Suppression réelle
    echo "$FICHIERS" | xargs rm
    
    echo -e "${GREEN}Nettoyage terminé !${NC}"
    
    # Écriture dans le fichier de log (Exercice)
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$DATE] Nettoyage effectué (-$JOURS jours). Espace libéré : $TAILLE_TOTALE" >> "$JOURNAL_OPERATION"
    echo "L'opération a été enregistrée dans $JOURNAL_OPERATION"
else
    echo "Opération annulée."
fi
