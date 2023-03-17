# miage
Ce projet consistais à développer une version light de l’application Vinted que j'ai nommé 'NassouFashion'. 

##### le [MVP] que j'ai développé 

US#1 : [MVP] Interface de login
En tant qu'utilisateur, je souhaite pouvoir me connecter à l'application afin d'accéder à la page suivante.
Critère d'acceptance #1 : Au lancement de l'application, une interface de login composée d'un headerBar qui contient le nom de l'application, de deux champs et d'un bouton m'est proposée
Critère d'acceptance #2 : Les deux champs de saisie sont : Login et Password
Critère d'acceptance #3 : Le champ de saisie du password est obfusqué
Critère d'acceptance #4 : Le label du bouton est : Se connecter
Critère d'acceptance #5 : Au clic sur le bouton « Se connecter », une vérification en base est réalisée. Si l'utilisateur existe, celui-ci est redirigé sur la page suivante. Si celui-ci n'existe pas, à minima un log est affiché dans la console et l'application reste fonctionnelle
Critère d'acceptance #6 : Au clic sur le bouton « Se connecter » avec les deux champs vides, l'application doit rester fonctionnelle

US#2 : [MVP] Liste de vêtements
En tant qu'utilisateur connecté, je souhaite voir la liste des vêtements afin de choisir ceux qui m'intéressent.
Critère d'acceptance #1 : Une fois connecté, l'utilisateur arrive sur cette page composée du contenu principal et d'une BottomNavigationBar composée de trois entrées et leurs icônes correspondantes : Acheter, Panier et Profil
Critère d'acceptance #2 : La page actuelle est la page Acheter. Son icône et son texte sont d'une couleur différente des autres entrées
Critère d'acceptance #3 : Une liste déroulante de tous les vêtements m'est proposée à l'écran
Critère d'acceptance #4 : Chaque vêtement affiche les informations suivantes :
Une image (ne pas gérer les images dans l'application, seulement insérer des liens vers des images d'internet)
Un titre
La taille
Le prix
Critère d'acceptance #5 : Au clic sur une entrée de la liste, le détail est affiché (voir US#3)
Critère d'acceptance #6 : Cette liste de vêtements est récupérée de la base de données

US#3 : [MVP] Détail d’un vêtement
US#4 : [MVP] Le panier
US#5 : [MVP] Profil utilisateur
US#6 : Filtrer sur la liste des vêtements
US#7 : Laisser libre cours à votre imagination


### Pour la connection:
J'ai créer deux utilisateurs
Users1
-Login:test@gmail.com
-Password: test96
Users2
-Login:nassouk96@gmail.com
-Password: nassou


