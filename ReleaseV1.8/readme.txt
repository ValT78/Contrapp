Tous les assets utilisés pour l'application se trouvent dans le dossier :
data/flutter_assets/assets

Cela inclut :
- Les images utilisées dans le contrat. Vous pouvez en supprimer, et en placer une autre avec le même nom à la place. Les futurs contrats utiliseront les nouvelles images.
- Le template de contrat "template.md".


PRINCIPE GENERAL

Le contrat se rédige dans "template.md".
Vous pouvez écrire du texte libre, comme dans un document classique.
Certaines syntaxes permettent d'ajouter des informations de l'application.

La syntaxe utilise des doubles accolades :
{{ ... }}

Important :
- Les espaces et les tabulations autour des accolades et des "|" sont ignorés.
- En cas d'erreur, l'application indique maintenant la ligne à corriger lors de la génération du PDF.


MISE EN FORME SIMPLE

- Texte normal : tant que vous ne sautez pas de ligne, le texte reste dans le même paragraphe.
- Ligne vide : ajoute un petit espace vertical.
- # Titre : affiche un grand titre centré avec le cadre.
- **texte** : met le texte en gras.
- _texte_ : met le texte en italique.
- <u>texte</u> : souligne le texte.
- - texte : crée une puce.
- --- : crée un trait horizontal.


VARIABLES

Pour afficher une donnée venant de l'application, utilisez :
{{ entreprise }}

Exemples :
- {{ entreprise }}
- {{ adresse1 }}
- {{ adresse2 }}
- {{ numeroContrat }}
- {{ capital }}
- {{ matricule }}
- {{ montantHT }}
- {{ totalHT }}
- {{ customTva }}
- {{ montantTTC }}
- {{ date }}

Les variables peuvent être utilisées dans une phrase :
Le client {{ entreprise }} est situé à {{ adresse1 }}.

Vous pouvez aussi les combiner avec le gras :
**{{ entreprise }}**


COMMANDES SPECIALES

Ces commandes doivent être seules sur leur ligne.

- {{ equipements }}
  Affiche la liste des équipements.

- {{ operations }}
  Affiche la liste des opérations.

- {{ calendrier }}
  Affiche le calendrier des visites.

- {{ pieces_jointes }}
  Affiche les pièces jointes.

- {{ astreinte_texte | texte si astreinte | texte si pas d'astreinte }}
  Affiche automatiquement l'un des deux textes.

- {{ astreinte_prix | Libellé du supplément }}
  Affiche le prix de l'astreinte si l'astreinte est activée.

- {{ ligne | texte de gauche | texte de droite }}
  Affiche une ligne avec un texte à gauche et un texte à droite.

- {{ cadres | texte gauche 1 | texte droite 1 | texte gauche 2 | texte droite 2 }}
  Remplit 2 cadres. Les textes impairs vont à gauche, les textes pairs à droite.

- {{ separateur }}
  Ajoute un trait horizontal.

- {{ saut_de_page }}
  Force un saut de page.


CONSEILS

- Ne modifiez pas une commande spéciale si vous ne souhaitez pas changer son comportement.
- Pour éviter les erreurs, laissez chaque commande spéciale seule sur sa ligne.
- Faites un test de génération après une modification importante.
- Si l'application signale une erreur, ouvrez le template, allez à la ligne indiquée et corrigez uniquement cette ligne.
