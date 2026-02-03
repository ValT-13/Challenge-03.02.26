#!/bin/bash

FICHIER_CSV=$1

# 1. Vérification des droits root
if [ "$(id -u)" -ne 0 ]; then
   echo "Il faut lancer ce script avec sudo !"
   exit 1
fi

# 2. Vérification de l'argument (le fichier existe-t-il ?)
if [ -z "$FICHIER_CSV" ] || [ ! -f "$FICHIER_CSV" ]; then
    echo "Erreur : Veuillez fournir un fichier CSV valide."
    echo "Usage : sudo $0 <fichier.csv>"
    exit 1
fi

echo "--- Début de l'import ---"

# 3. La boucle de lecture du fichier
# IFS=, : Définit la virgule comme séparateur (au cas où ton CSV serait "nom,prenom")
# read -r USER : Lit la ligne et met le contenu dans la variable USER
while IFS=, read -r USERNAME || [ -n "$USERNAME" ]; do

    # On saute les lignes vides s'il y en a
    if [ -z "$USERNAME" ]; then
        continue
    fi

    # Vérifier si l'utilisateur existe déjà pour ne pas bloquer le script
    if id "$USERNAME" &>/dev/null; then
        echo "⚠️  L'utilisateur '$USERNAME' existe déjà. On passe."
    else
        # --- Création (même logique que l'exercice précédent) ---
        MOT_DE_PASSE=$(openssl rand -base64 12)
        useradd -m -s /bin/bash "$USERNAME"
        echo "$USERNAME:$MOT_DE_PASSE" | chpasswd

        echo "✅ Créé : $USERNAME (Mdp: $MOT_DE_PASSE)"
    fi

done < "$FICHIER_CSV"

echo "--- Import terminé ! ---"
