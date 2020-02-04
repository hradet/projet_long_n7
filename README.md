# Materiel pour le projet long N7

## Prérequis :

* [CSV](https://github.com/JuliaData/CSV.jl) 
* [Seaborn](https://github.com/JuliaPy/Seaborn.jl) (ou le package de votre choix pour "ploter" vos résultats...)
* [DataFrames](https://github.com/JuliaData/DataFrames.jl)
* [JuMP](https://github.com/JuliaOpt/JuMP.jl) (pour l'optimisation...)
* Le solveur de votre choix avec le package associé : par exemple, si vous utilisez CBC, il faut installer le package [Cbc](https://github.com/JuliaOpt/Cbc.jl)

## Utilisation du module `ProjetN7.jl` :

Si vous téléchargez le package en local, une facçon simple pour l'utiliser est d'ajouter la commande suivante dans un fichier `startup.jl` et de le mettre dans le dossier `.julia\config` que vous créez si il n'existe pas : 

```
push!(LOAD_PATH, "your_path_to_directory\\projet_long_n7\\src")
```

Un exemple est donné dans le dossier `projet_long_n7\example`. La fonction `loadGUI().jl` correspond à l'interface virtuelle et permet de charger les paramètres choisis par l'utilisateur. Le script `main.jl` permet de lancer la simulation.

