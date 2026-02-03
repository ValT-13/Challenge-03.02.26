#!/bin/bash

# On demande la ville
read -p "Quelle ville souhaitez-vous vérifier ? : " VILLE

# Si la ville est vide, on met Paris par défaut
if [ -z "$VILLE" ]; then
    VILLE="Paris"
fi

echo "Interrogation du satellite pour $VILLE..."

# 1. On utilise curl pour récupérer la météo depuis un service gratuit (wttr.in)
# format=j1 demande le format JSON (données brutes)
DONNEES=$(curl -s "https://wttr.in/$VILLE?format=j1&lang=fr")

# 2. On vérifie si ça a marché (si la variable est vide, c'est qu'il y a pas de net ou ville inconnue)
if [ -z "$DONNEES" ]; then
    echo "Erreur : Impossible de récupérer la météo (Vérifie ta connexion ou le nom de la ville)."
    exit 1
fi

# 3. Extraction des infos avec jq (c'est là que la magie opère)
# On va chercher la température dans la structure complexe du JSON
TEMP=$(echo "$DONNEES" | jq -r '.current_condition[0].temp_C')
DESC=$(echo "$DONNEES" | jq -r '.current_condition[0].lang_fr[0].value')
HUMIDITE=$(echo "$DONNEES" | jq -r '.current_condition[0].humidity')

# 4. Affichage joli
echo "---------------------------------"
echo "🌍 Météo actuelle à $VILLE"
echo "🌡️  Température : $TEMP °C"
echo "☁️  Ciel        : $DESC"
echo "💧 Humidité    : $HUMIDITE %"
echo "---------------------------------"
