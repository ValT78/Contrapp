# AGENTS.md

## Projet
Application Flutter Frontend pour générer des contrats. On entre les informations de l'entreprise, la commandes, les informations, puis on génère le pdf à envoyer au client

## Structure
- `lib/...` = base de l'application
- `lib/pages/...` = composant racine de chaque page
- `lib/skeleton/...` = contient la structure d'une page
- `lib/specific_tiles/...` = éléments spécifique à une image
- `lib/common_tiles/...` = éléments réutilisés à plusieurs endroits
- `lib/pdf/...` = Composant spécifiques pour le pdf
- `lib/domain/...` = pricing and business logic

## Commands
- Run app: `flutter run`
- Analyze: `flutter analyze`
- Tests: `flutter test`

## Rules
- Do not add dependencies without asking.
- Prefer minimal diffs.
- Do not refactor unrelated files.
- Keep business logic out of widgets.
- Explains to the user the reason why you make a technical change, and explain how it works

## Done when
- Code compiles
- Changes are limited to the requested scope