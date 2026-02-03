#!/bin/bash

# On définit le seuil d'alerte (Mets un chiffre bas pour tester, ex: 10 ou 5)
SEUIL=10

# 1. Récupérer le pourcentage d'occupation
# df -h /       : Affiche les infos du disque principal
# grep "/"      : Garde la ligne qui concerne la racine "/"
# awk '{print $5}' : Garde la 5ème colonne (le pourcentage) -> ex: "24%"
# tr -d '%'     : "Translate delete". Ça efface le signe "%" pour avoir juste "24"
USAGE=$(df -h / | grep "/" | awk '{print $5}' | tr -d '%')

# 2. Comparaison
if [ "$USAGE" -ge "$SEUIL" ]; then
    # On construit le message
    MESSAGE="⚠️ ALERTE : Espace disque critique ! Utilisation : $USAGE%"

    # On l'affiche à l'écran (pour tester)
    echo "$MESSAGE"

    # ET on l'écrit dans un fichier journal avec la date
    # ">>" ajoute à la fin du fichier sans l'écraser
    echo "$(date) - $MESSAGE" >> /home/val/alerte_disque.log
else
    echo "Tout va bien. Utilisation : $USAGE%"
fi
