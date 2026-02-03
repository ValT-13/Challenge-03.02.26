#!/bin/bash

# Définition de quelques couleurs pour le style (codes ANSI)
VERT='\033[0;32m'
BLEU='\033[0;34m'
GRAS='\033[1m'
RESET='\033[0m' # Pour arrêter la couleur

echo -e "${BLEU}======================================${RESET}"
echo -e "${GRAS}🖥️  TABLEAU DE BORD - $(hostname)${RESET}"
echo -e "${BLEU}======================================${RESET}"

# 1. Uptime (Temps depuis le dernier démarrage)
# -p permet d'avoir un format lisible "up 2 hours, ..."
TEMPS=$(uptime -p | sed 's/up //') # sed supprime le mot "up"
echo -e "🕒 Uptime      : $TEMPS"

# 2. RAM (Mémoire vive)
# free -h donne les tailles en humain (Go, Mo)
# awk va chercher la ligne "Mem:" et prend la 3ème colonne (utilisé) et 2ème (total)
RAM_UTILISE=$(free -h | grep "Mem:" | awk '{print $3}')
RAM_TOTAL=$(free -h | grep "Mem:" | awk '{print $2}')
echo -e "💾 RAM         : ${VERT}$RAM_UTILISE${RESET} / $RAM_TOTAL"

# 3. Disque Dur
# On réutilise ta technique du df
DISQUE=$(df -h / | grep "/" | awk '{print $5}')
echo -e "💿 Disque      : ${VERT}$DISQUE${RESET} utilisé"

# 4. Adresse IP (Un peu complexe à extraire proprement)
# hostname -I donne toutes les IPs, on prend la première avec awk
IP=$(hostname -I | awk '{print $1}')
echo -e "🌍 IP Locale   : $IP"

echo -e "${BLEU}======================================${RESET}"
