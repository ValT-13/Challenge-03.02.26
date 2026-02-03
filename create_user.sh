#!/bin/bash

NOM_UTILISATEUR=$1

# 1. Vérification : Est-ce que l'utilisateur est root (admin) ?
# id -u renvoie 0 si on est root. Sinon, on arrête le script.
if [ "$(id -u)" -ne 0 ]; then
   echo "Ce script doit être lancé avec sudo (droits administrateur)."
   exit 1
fi

# 2. Vérification de l'argument
if [ -z "$NOM_UTILISATEUR" ]; then
    echo "Erreur : Nom d'utilisateur manquant."
    echo "Usage : sudo $0 <nom_utilisateur>"
    exit 1
fi

# 3. Vérifier si l'utilisateur existe déjà
# id <nom> renvoie une erreur si l'utilisateur n'existe pas, on redirige la sortie vers le néant (> /dev/null) pour que ce soit silencieux
if id "$NOM_UTILISATEUR" &>/dev/null; then
    echo "L'utilisateur '$NOM_UTILISATEUR' existe déjà."
    exit 1
fi

# 4. Génération d'un mot de passe aléatoire
# On utilise openssl pour générer 12 caractères aléatoires
MOT_DE_PASSE=$(openssl rand -base64 12)

echo "Création de l'utilisateur '$NOM_UTILISATEUR'..."

# 5. Création de l'utilisateur
# -m : Crée le dossier personnel (/home/nom)
# -s : Définit le shell par défaut (/bin/bash)
useradd -m -s /bin/bash "$NOM_UTILISATEUR"

# 6. Attribution du mot de passe
# On envoie "utilisateur:motdepasse" à la commande chpasswd
echo "$NOM_UTILISATEUR:$MOT_DE_PASSE" | chpasswd

# 7. Affichage du résultat
if [ $? -eq 0 ]; then
    echo "---------------------------------------"
    echo "✅ Utilisateur créé avec succès !"
    echo "👤 Nom : $NOM_UTILISATEUR"
    echo "🔑 Mot de passe : $MOT_DE_PASSE"
    echo "---------------------------------------"
else
    echo "Erreur lors de la création de l'utilisateur."
fi
