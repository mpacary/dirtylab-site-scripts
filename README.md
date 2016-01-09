# dirtylab-site-scripts

Ce repository contient les **scripts bash** et **templates [Liquid](https://github.com/Shopify/liquid/wiki)** ([Jekyll](jekyllrb.com)) permettant d'automatiser la publication des fichiers **.MD** du dépôt [sveinburne/letsplayscience](https://github.com/sveinburne/lets-play-science) vers le site statique [dirtylab.github.io](http://dirtylab.github.io) (issu du repo [dirtylab/dirtylab.github.io](https://github.com/dirtylab/dirtylab.github.io) à l'aide de la mécanique [GitHub pages](https://pages.github.com/))

A lancer dans un répertoire comportant en sous-dossier les repos **lets-play-science**, **dirtylab.github.io**, et les dossiers **[php_emojize](php_emojize)** et **[jekyll-stuff](jekyll-stuff)** de ce repo.

On doit donc avoir dans un dossier à part :

```
- /dirtylab.github.io
- /jekyll-stuff
- /lets-play-science
- /php_emojize
- 1_process.sh
- 2_push.sh
```

## Détail des scripts :

`1_process.sh`

* Récupération des **.MD** du repo **lets-play-science** dans un répertoire temporaire **tmp_site**
* Déplacement des **.MD** dans **_include**
* Création de **.html** à la racine (un pour chaque **.MD**) comportant les instructions de conversion de **Markdown** vers **HTML**
* Ajout de templates header / footer / navigation / style (contenu du répertoire [jekyll-stuff](jekyll-stuff))

`2_push.sh`

* Instructions **git** permettant le commit + push des traitements automatiques 
