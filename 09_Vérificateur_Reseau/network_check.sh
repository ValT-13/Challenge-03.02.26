#!/bin/bash

# --- CONFIGURATION ---
# Liste de 5 serveurs (IPs ou Domaines)
# J'ai mis une adresse qui n'existe pas (bad.server) pour tester l'erreur
SERVEURS=("google.com" "1.1.1.1" "github.com" "stackoverflow.com" "bad.server.test")
FICHIER_RESULTAT="rapport_reseau.txt"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialisation du fichier de log (on l'écrase à chaque lancement pour avoir un rapport frais)
echo "--- RAPPORT RÉSEAU DU $(date) ---" > "$FICHIER_RESULTAT"

echo -e "${BLUE}=== DÉBUT DU TEST DE CONNECTIVITÉ ===${NC}"
echo "Test en cours sur ${#SERVEURS[@]} serveurs..."
echo "---------------------------------------------------"

# Compteurs
TOTAL=${#SERVEURS[@]}
UP=0
DOWN=0

# Boucle sur chaque serveur
for SERV in "${SERVEURS[@]}"; do
    
    # Explication de la commande ping :
    # -c 3 : On envoie 3 paquets (pour être sûr)
    # -W 2 : On attend max 2 secondes (Timeout) pour ne pas bloquer le script si ça plante
    # -q   : Mode "quiet" (silencieux), n'affiche pas tout le blabla
    OUTPUT=$(ping -c 3 -W 2 "$SERV" 2>&1) # On capture aussi les erreurs (2>&1)
    CODE_RETOUR=$? # 0 = Succès, autre = Échec

    if [ $CODE_RETOUR -eq 0 ]; then
        # Extraction du temps moyen (ping affiche : min/avg/max/mdev = 10.2/12.5/...)
        # On utilise awk pour récupérer la valeur "avg" (moyenne)
        TEMPS=$(echo "$OUTPUT" | tail -n 1 | awk -F '/' '{print $5}')
        
        # Indicateur de qualité
        # Comme bash ne gère pas bien les virgules (ex: 12.5), on convertit en entier pour comparer
        TEMPS_INT=${TEMPS%.*} 

        if [ "$TEMPS_INT" -lt 50 ]; then
            QUALITE="${GREEN}🚀 EXCELLENT${NC}"
        elif [ "$TEMPS_INT" -lt 150 ]; then
            QUALITE="${YELLOW}😐 MOYEN${NC}"
        else
            QUALITE="${RED}🐢 LENT${NC}"
        fi

        MSG="[OK] $SERV : Réponse en ${TEMPS}ms -> $QUALITE"
        echo -e "${GREEN}✔${NC} $MSG"
        echo "$MSG" >> "$FICHIER_RESULTAT" # Sauvegarde sans les couleurs
        ((UP++))
    else
        MSG="[KO] $SERV : Inaccessible"
        echo -e "${RED}✖ $MSG${NC}"
        echo "$MSG" >> "$FICHIER_RESULTAT"
        ((DOWN++))
    fi

done

# --- RÉSUMÉ ---
echo "---------------------------------------------------"
echo -e "Résumé : ${GREEN}$UP/$TOTAL accessibles${NC} | ${RED}$DOWN/$TOTAL échecs${NC}"
echo ""
echo "Résumé : $UP/$TOTAL accessibles | $DOWN/$TOTAL échecs" >> "$FICHIER_RESULTAT"

echo -e "${BLUE}Le rapport complet a été sauvegardé dans : $FICHIER_RESULTAT${NC}"
