# AGENTS.md

## Project
Flutter Frontend application to generate contracts. Enter company information, orders, details, then generate the PDF to send to the client

## Mais Features
- On startup, the application looks for a .contrapp file containing persistent information between sessions (JSON format)
- The user enters contract information in the application. At the very end, a button allows them to generate a PDF: reads a template.md file line by line, and builds the PDF, replacing certain patterns or variables with the information
- Ability to save contract information in a .cntrt file (JSON format), and reopen it in the application to modify it

## Structure
### Folder
- `lib/...` = application base
- `lib/pages/...` = root component of each page
- `lib/skeleton/...` = contains the structure of a page
- `lib/specific_tiles/...` = elements specific to an image
- `lib/common_tiles/...` = elements reused in multiple places
- `lib/pdf/...` = components specific to PDF generation
### Classes
Located in the `lib/object/...` folder
- EquipList : The array containing equipment
- Equipment : Equipment types
- Machine : For each equipment type, there can be multiple machines
- Operation : For each equipment type, multiple operations can be performed
- ContractCalendar : Not a real object, but all the logic to manage the visits per year for every equipments and machines

## Commands
You are on Windows. Use ONLY windows commands. Use ONLY powershell. If a command fails find out the correct syntax and extend AGENTS.md to note down that syntax for future use
- Run app: `flutter run`
- Analyze: `flutter analyze`
- Tests: `flutter test`

## Rules
- Do not add dependencies without asking.
- Prefer minimal diffs.
- Do not refactor unrelated files.
- Keep business logic out of widgets.
- Keep comments in code
- Explain to the user the reason why you make a technical change, and explain how it works

## Done when
- Code compiles
- Changes are limited to the requested scope