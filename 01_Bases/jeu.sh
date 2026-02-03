#!/bin/bash

# 1. Générer un nombre aléatoire entre 1 et 100
# $RANDOM donne un nombre au hasard entre 0 et 32767.
# % 100 permet de garder le reste de la division par 100 (donc entre 0 et 99).
# + 1 permet d'avoir un résultat entre 1 et 100.
CIBLE=$(( $RANDOM % 100 + 1 ))

# On initialise la variable du joueur à 0 pour entrer dans la boucle
GUESS=0

echo "=== JEU DU PLUS OU MOINS ==="
echo "Je pense à un nombre entre 1 et 100. Devine lequel !"

# 2. La boucle : Tant que le nombre deviné n'est pas égal (-ne) à la cible
while [ "$GUESS" -ne "$CIBLE" ]; do

    # Demander à l'utilisateur d'entrer un nombre
    # -p permet d'afficher le message sur la même ligne
    read -p "Votre proposition : " GUESS

    # 3. Comparaisons
    if [ "$GUESS" -lt "$CIBLE" ]; then
        echo "C'est PLUS grand (+) !"
    elif [ "$GUESS" -gt "$CIBLE" ]; then
        echo "C'est PLUS petit (-) !"
    else
        echo "BRAVO ! Vous avez trouvé le nombre mystère ($CIBLE) !"
    fi
done
