#!/bin/bash

# --- CONFIGURATION DES COULEURS (selon les conseils) ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Liste des services à surveiller
# Tu peux changer apache2 par nginx si besoin, ou ajouter d'autres services
SERVICES=("ssh" "cron" "apache2")

# --- 1. VÉRIFICATION ROOT ---
# Pour démarrer/arrêter des services, il faut être administrateur.
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Erreur : Ce script doit être lancé avec sudo.${NC}"
    exit 1
fi

# --- FONCTION D'AFFICHAGE ---
afficher_etat() {
    echo ""
    echo -e "${YELLOW}--- ÉTAT DES SERVICES ---${NC}"
    
    # On boucle sur chaque service de notre liste
    for SERVICE in "${SERVICES[@]}"; do
        
        # Vérification si le service est actif (tourne actuellement)
        if systemctl is-active --quiet "$SERVICE"; then
            ETAT="${GREEN}ACTIF${NC}"
        else
            ETAT="${RED}INACTIF${NC}"
        fi

        # Vérification si le service se lance au démarrage (enabled)
        if systemctl is-enabled --quiet "$SERVICE"; then
            BOOT="OUI"
        else
            BOOT="NON"
        fi

        # Affichage formaté
        # -e permet d'interpréter les couleurs
        echo -e "Service : ${YELLOW}$SERVICE${NC} | État : $ETAT | Au démarrage : $BOOT"
    done
    echo "-------------------------"
}

# --- BOUCLE PRINCIPALE (MENU) ---
while true; do
    afficher_etat
    
    echo ""
    echo "Que voulez-vous faire ?"
    echo "1) Démarrer un service"
    echo "2) Arrêter un service"
    echo "3) Quitter"
    
    read -p "Votre choix : " CHOIX

    case $CHOIX in
        1)
            read -p "Nom du service à DÉMARRER : " SERV_TO_START
            echo "Tentative de démarrage de $SERV_TO_START..."
            systemctl start "$SERV_TO_START"
            
            # Vérification du succès ($? contient le code de retour de la commande précédente)
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Succès ! $SERV_TO_START a été démarré.${NC}"
            else
                echo -e "${RED}Erreur lors du démarrage de $SERV_TO_START.${NC}"
            fi
            ;;
        2)
            read -p "Nom du service à ARRÊTER : " SERV_TO_STOP
            echo "Arrêt de $SERV_TO_STOP..."
            systemctl stop "$SERV_TO_STOP"
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Succès ! $SERV_TO_STOP a été arrêté.${NC}"
            else
                echo -e "${RED}Erreur lors de l'arrêt de $SERV_TO_STOP.${NC}"
            fi
            ;;
        3)
            echo "Au revoir !"
            break # Sort de la boucle while
            ;;
        *)
            echo -e "${RED}Choix invalide.${NC}"
            ;;
    esac
    
    # Petite pause pour laisser le temps de lire
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
done
