## Utilisation du module `ProjetN7.jl` :

Si vous téléchargez le package en local, une facçon simple pour l'utiliser est d'ajouter la commande suivante dans un fichier `startup.jl` et de le mettre dans un dossier `.julia\config` que vous créez si il n'existe pas : 

```
push!(LOAD_PATH, "your_path_to_directory\\projet_long_n7\\src")
```

Un exemple est donné dans le dossier `projet_long_n7\example`. Le fichier `parameters.yaml` contient l'ensemble des paramètres spécifiés par l'utilisateur et `student_file.jl` correspond au fichier de l'étudiant.
