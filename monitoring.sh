#!/bin/bash

LOG_FILE=$1

# 1. Vérification de l'argument
if [ -z "$LOG_FILE" ]; then
    echo "Erreur : Veuillez fournir un fichier de log."
    echo "Usage : $0 <fichier_log>"
    exit 1
fi

echo "--- Top 10 des IPs les plus actives ---"
echo "NB_REQUETES  ADRESSE_IP"

# 2. La commande magique (Pipeline)
# awk '{print $1}' : Dans les logs Apache, l'IP est le 1er mot ($1)
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10
