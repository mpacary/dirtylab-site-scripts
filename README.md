# dirtylab-site-scripts

Ce repository contient les **scripts bash** et **templates [Liquid](https://github.com/Shopify/liquid/wiki)** ([Jekyll](jekyllrb.com)) permettant d'automatiser la publication des fichiers **.MD** du dépôt [sveinburne/letsplayscience](https://github.com/sveinburne/lets-play-science) vers le site statique [dirtylab.github.io](http://dirtylab.github.io)

A lancer dans un répertoire comportant en sous-dossier les repos **lets-play-science** et **dirtylab.github.io**.

## Détail des scripts :

`1_process.sh`

* Récupération des **.MD** du repo **lets-play-science** dans un répertoire temporaire
* Déplacement des **.MD** dans **_include**
* Création de **.html** à la racine (un pour chaque **.MD**) comportant les instructions de conversion de **Markdown** vers **HTML**
* Ajout de templates header / footer / navigation / style (contenu du répertoire [jekyll-stuff](jekyll-stuff))

`2_push.sh`

* Instructions **git** permettant le commit + push des traitements automatiques 
