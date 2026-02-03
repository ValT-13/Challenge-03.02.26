# 🐧 Challenge Scripting Linux & Bash

Ce dépôt contient l'intégralité des scripts réalisés lors de mon parcours intensif d'apprentissage du **Scripting Bash** et de l'**Administration Système Linux**.

Le projet a été réalisé sur une machine virtuelle **Debian 13 (Trixie)** et couvre l'automatisation, la surveillance, la gestion de paquets et la sauvegarde.

---

## 📂 Structure du Projet

Les scripts sont classés par ordre de progression et par thématique :

### 🔹 Les Fondamentaux
| Dossier | Contenu | Description |
| :--- | :--- | :--- |
| **`01_Bases`** | *Hello World, Calculatrice, Météo...* | Découverte des variables, conditions (`if/else`), boucles et interaction utilisateur. |

### 🛠️ Administration Système & Automatisation
| Dossier | Script Principal | Objectif & Compétences |
| :--- | :--- | :--- |
| **`05_Sauvegarde`** | `sauvegarde.sh` | **Archivage** : Création d'archives `.tar.gz` avec horodatage automatique pour les backups. |
| **`06_Services`** | `services.sh` | **Surveillance** : Vérifie si un service (ex: Apache/SSH) tourne et le redémarre automatiquement s'il est arrêté. |
| **`07_Nettoyage_Logs`** | `cleaner.sh` | **Maintenance** : Rotation et archivage des logs système pour libérer de l'espace disque. |
| **`08_Surveillance_Disque`** | `analyse_disque.sh` | **Alerting** : Surveille l'espace disque et alerte si un seuil critique (ex: 90%) est dépassé. |
| **`09_Verificateur_Reseau`** | `network_check.sh` | **Réseau** : Test de connectivité (Ping) vers plusieurs serveurs avec analyse de la latence (Rapide/Lent). |
| **`10_Installateur_Paquets`** | `installateur.sh` | **Provisioning** : Script idempotent qui installe une liste de logiciels, vérifie s'ils sont déjà là et gère les erreurs. |
| **`11_Generateur_Rapport`** | `mon_rapport.sh` | **Reporting Web** : Génère une page **HTML/CSS (Dark Mode)** avec l'état complet du système (RAM, CPU, Uptime) visible via un navigateur. |
| **`12_Synchronisation`** | `synchro.sh` | **Backup Avancé** : Wrapper autour de `rsync`. Gère la copie incrémentale et inclut un **"Mode Miroir"** (suppression des fichiers obsolètes). |

---

## 🚀 Compétences Acquises

* **Langage** : Bash (Shell Scripting)
* **Système** : Linux Debian 13
* **Concepts Clés** :
    * Gestion des entrées/sorties (stdin/stdout/stderr) et redirections.
    * Algorithmique (Boucles `for/while`, conditions complexes).
    * Interaction utilisateur (Menus, `read`).
    * Codes de retour (`exit codes $?`) et gestion d'erreurs.
    * Automatisation de tâches administratives (Logs, Updates, Backups).
    * Intégration Web basique (Génération de HTML depuis Bash).

---

## 💻 Utilisation

Pour lancer un script, il suffit de se rendre dans le dossier et de l'exécuter :

```bash
cd 12_Synchronisation
chmod +x synchro.sh
./synchro.sh dossier_source dossier_destination