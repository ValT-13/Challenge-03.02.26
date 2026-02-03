#!/bin/bash

# Fichier temporaire pour stocker le rapport avant de l'afficher/sauvegarder
RAPPORT_TMP=$(mktemp)

# Codes couleurs
ROUGE='\033[0;31m'
VERT='\033[0;32m'
GRAS='\033[1m'
RESET='\033[0m'

# Seuil d'alerte (80% demandé, mais tu pourras le baisser à 10 pour tester !)
SEUIL=80

{
    echo -e "${GRAS}=== 1. UTILISATION DES PARTITIONS ===${RESET}"
    echo "Partitions utilisées à plus de $SEUIL% affichées en ROUGE."
    echo "-----------------------------------------------------------"
    
    # Commande magique avec AWK :
    # NR==1 : C'est la ligne de titre (Filesystem...), on l'affiche normalement.
    # $5 : C'est la 5ème colonne (Pourcentage utilisé).
    # int($5) : On convertit "18%" en nombre "18" pour comparer.
    df -h | awk -v seuil="$SEUIL" -v rouge="$ROUGE" -v reset="$RESET" '
    NR==1 { print $0; next }
    {
        percent = int($5)
        if (percent >= seuil)
            print rouge $0 reset
        else
            print $0
    }
    '

    echo ""
    echo -e "${GRAS}=== 2. TOP 10 DES DOSSIERS DANS /HOME ===${RESET}"
    echo "Recherche des plus gros consommateurs..."
    echo "-----------------------------------------------------------"
    
    # du -h : taille lisible (Ko, Mo, Go)
    # /home : le dossier à analyser
    # 2>/dev/null : cache les erreurs "permission denied"
    # sort -rh : trie (sort) inversé (reverse) et humain (human-readable)
    # head -n 10 : garde les 10 premiers
    
    if [ -d "/home" ]; then
        du -h /home 2>/dev/null | sort -rh | head -n 10
    else
        echo "Le dossier /home n'existe pas (étrange...)."
    fi

} > "$RAPPORT_TMP" 
# L'accolade fermante } capture tout l'affichage précédent dans le fichier temporaire

# --- AFFICHAGE À L'ÉCRAN ---
cat "$RAPPORT_TMP"

# --- EXPORT ---
echo ""
echo "-----------------------------------------------------------"
read -p "Voulez-vous exporter ce rapport dans 'rapport.txt' ? (o/n) : " REPONSE

if [[ "$REPONSE" == "o" || "$REPONSE" == "O" ]]; then
    # On utilise sed pour retirer les codes couleurs du fichier texte (sinon c'est illisible)
    sed 's/\x1b\[[0-9;]*m//g' "$RAPPORT_TMP" > rapport_disque.txt
    echo -e "${VERT}Rapport sauvegardé dans 'rapport_disque.txt' !${RESET}"
else
    echo "Export annulé."
fi

# Nettoyage du fichier temporaire
rm "$RAPPORT_TMP"
