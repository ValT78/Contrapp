Tous les assets utilisés pour l'application se trouvent dans le dossier : data/flutter_assets/assets

Cela inclus :
- Les images utilisés dans le contrat. Vous pouvez en supprimer, et en placer une autre avec le même nom à la place. Les futurs contrats utiliseront les nouvelles images
- Le template de contrat "template.md"



Le contrat se rédige en markdown. En gros c'est du texte, et vous pouvez rajouter des effets de style en utilisant certains caractères. Voici la liste :


- Du texte sur la même ligne : Tant que vous ne sautez pas de ligne, le texte sera écrit sur le même paragraphe dans le pdf

- Retour à la ligne : Les retour à la ligne créent volontairement peu d'espace. N'hésitez pas à faire plusieurs saut de ligne pour ajouter plus d'espace entre 2 éléments

- && equipment/operation/calendar/attachList/astreinteTexte/astreintePrice : && permet d'afficher un élément custom. Il faut préciser l'un de ces mots pour afficher celui que vous souhaitez :
	1) equipment : La liste des équipements
	2) operation : La liste des opérations
	3) calendar : Le calendrier des visites
	4) attachList : Les pièces jointes
	5) astreinteTexte : Le texte pour annoncer la nature de l'astreinte. On doit rajouter un "|", un texte 1, un "|", un texte 2 derrière. S'il y a ou non astreinte, cela affichera le texte 1 ou le texte 2
	6) astreintePrice : Affiche le prix de l'astreinte. On doit rajouter un "|" puis un texte. Cela modifie le texte afficher en face du prix

- # : Permet d'afficher un titre en gros, centré, avec un cadre autour

- **texte** : Entourer du texte avec 4 astérisques permet de le mettre en gras

- <u>texte</u> : Entourer du texte avec les balises <u></u> permet de le souligner

- _texte_ : Entourer du texte avec 2 underscore permet de mettre en italique

- <tab>texte1|texte2 : Permet d'afficher le texte1 à gauche, et le texte2 à droite (en gras)

- /// : Crée une barre horizontale sur toute la longueur du document

- ___ : 3 underscore permettent de faire un retour à la page. Le reste de la page reste vide, on recommence à écrire sur la page suivante

- <cadre>texte1|texte2|texte3|texte4 : Crée 2 boîtes, l'une à gauche, l'autre à droite. Vous pouvez ajouter autant de texte que vous voulez (avec un "|" avant). Les textes impairs (premier, troisième,...) iront dans le cadre de gauche, les textes paires (deuxième, quatrième,...) iront dans le cadre de droite

- ==variable== : Les 4 signes "égale" permettent d'afficher une variable entrée dans l'application. C'est compatible avec les styles au dessus (**==entreprise==** mettra le nom de l'entreprise en gras) Attention à l'orthographe et aux majuscules :
	1) entreprise
	2) adresse1
	3) adresse2
	4) numeroContrat
	5) capital
	6) matricule
	7) montantHT : sans astreinte
	8) totalHT : avec astreinte
	9) customTva : la tva, par défaut à 20%
	10) montantTTC : totalHT après la TVA
	11) date

