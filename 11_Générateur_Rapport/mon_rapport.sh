#!/bin/bash

# Nom du fichier de sortie
FICHIER="rapport_systeme.html"

# --- 1. RÉCUPÉRATION DES DONNÉES ---
TITRE="Rapport Système - $(hostname)"
DATE_GEN=$(date "+%d/%m/%Y à %H:%M")
OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
UPTIME=$(uptime -p)
KERNEL=$(uname -r)

# Récupération CPU (Charge moyenne sur 1min)
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1)

# Récupération RAM
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_USED=$(free -h | grep Mem | awk '{print $3}')

# --- 2. GÉNÉRATION DU HTML (Here-Doc) ---
# Tout ce qui est entre "cat << EOF" et "EOF" sera écrit dans le fichier HTML
cat << EOF > "$FICHIER"
<!DOCTYPE html>
<html>
<head>
    <title>$TITRE</title>
    <meta charset="UTF-8">
    <style>
        /* --- STYLE CSS (Le Design) --- */
        body { font-family: sans-serif; background-color: #1a1a1a; color: #f0f0f0; margin: 40px; }
        h1 { color: #00ff9d; border-bottom: 2px solid #00ff9d; padding-bottom: 10px; }
        h2 { color: #00b8ff; margin-top: 30px; }
        .box { background-color: #2b2b2b; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.3); }
        .info { font-size: 1.2em; margin-bottom: 10px; }
        pre { background-color: #000; color: #0f0; padding: 15px; border-radius: 5px; overflow-x: auto; }
        .badge { background-color: #e74c3c; color: white; padding: 5px 10px; border-radius: 4px; font-size: 0.8em; }
    </style>
</head>
<body>

    <h1>🖥️ $TITRE</h1>
    <p>Généré le : $DATE_GEN</p>

    <div class="box">
        <h2>ℹ️ Informations Générales</h2>
        <div class="info"><strong>Système :</strong> $OS_INFO</div>
        <div class="info"><strong>Noyau (Kernel) :</strong> $KERNEL</div>
        <div class="info"><strong>Uptime :</strong> $UPTIME</div>
    </div>

    <div class="box">
        <h2>⚡ Ressources</h2>
        <div class="info"><strong>CPU (Charge) :</strong> $LOAD</div>
        <div class="info"><strong>Mémoire :</strong> $RAM_USED utilisés sur $RAM_TOTAL</div>
    </div>

    <h2>💾 Espace Disque</h2>
    <pre>$(df -h /)</pre>

    <h2>⚙️ Top 10 Services Actifs</h2>
    <pre>$(systemctl list-units --type=service --state=running | head -n 15)</pre>

    <h2>👤 Dernières Connexions</h2>
    <pre>$(last | head -n 5)</pre>

    <br>
    <footer style="text-align: center; color: #666;">
        Généré automatiquement par le script Bash de Val
    </footer>

</body>
</html>
EOF

# --- 3. OUVERTURE DU RAPPORT ---
echo "Rapport généré avec succès : $FICHIER"

# On essaie d'ouvrir le fichier si une interface graphique est dispo
if command -v xdg-open &> /dev/null; then
    xdg-open "$FICHIER"
else
    echo "Astuce : Si tu ne peux pas ouvrir le navigateur ici, fais :"
    echo "cat $FICHIER"
fi
