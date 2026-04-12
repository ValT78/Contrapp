import 'dart:convert';
import 'dart:io';

import 'package:contrapp/main.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/pdf/calendar_object.dart';
import 'package:contrapp/pdf/equipment_object.dart';
import 'package:contrapp/pdf/operation_object.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum _TemplateCommandType {
  equipment,
  operation,
  calendar,
  annexText,
  imageList,
  astreinteText,
  astreintePrice,
  twoColumns,
  boxes,
  separator,
  pageBreak,
}

class _TemplateException implements Exception {
  const _TemplateException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _TemplateLine {
  const _TemplateLine({
    required this.number,
    required this.text,
  });

  final int number;
  final String text;
}

class _TemplateCommand {
  const _TemplateCommand({
    required this.type,
    required this.arguments,
    required this.lineNumber,
  });

  final _TemplateCommandType type;
  final List<String> arguments;
  final int lineNumber;
}

const Map<String, _TemplateCommandType> _commandAliases = {
  'equipment': _TemplateCommandType.equipment,
  'equipement': _TemplateCommandType.equipment,
  'equipements': _TemplateCommandType.equipment,
  'materiel': _TemplateCommandType.equipment,
  'materiels': _TemplateCommandType.equipment,
  'operation': _TemplateCommandType.operation,
  'operations': _TemplateCommandType.operation,
  'calendar': _TemplateCommandType.calendar,
  'calendrier': _TemplateCommandType.calendar,
  'planning': _TemplateCommandType.calendar,
  'visites': _TemplateCommandType.calendar,
  'annexetexte': _TemplateCommandType.annexText,
  'annexetextes': _TemplateCommandType.annexText,
  'annexestexte': _TemplateCommandType.annexText,
  'annexestextes': _TemplateCommandType.annexText,
  'annexe': _TemplateCommandType.annexText,
  'annexes': _TemplateCommandType.annexText,
  'textannexe': _TemplateCommandType.annexText,
  'texteannexe': _TemplateCommandType.annexText,
  'textesannexes': _TemplateCommandType.annexText,
  'texteannexes': _TemplateCommandType.annexText,
  'imagelist': _TemplateCommandType.imageList,
  'image': _TemplateCommandType.imageList,
  'images': _TemplateCommandType.imageList,
  'attachlist': _TemplateCommandType.imageList,
  'piecejointe': _TemplateCommandType.imageList,
  'piecesjointes': _TemplateCommandType.imageList,
  'astreintetexte': _TemplateCommandType.astreinteText,
  'texteastreinte': _TemplateCommandType.astreinteText,
  'astreinteprice': _TemplateCommandType.astreintePrice,
  'astreinteprix': _TemplateCommandType.astreintePrice,
  'prixastreinte': _TemplateCommandType.astreintePrice,
  'tab': _TemplateCommandType.twoColumns,
  'ligne': _TemplateCommandType.twoColumns,
  'deuxcolonnes': _TemplateCommandType.twoColumns,
  'twocolumns': _TemplateCommandType.twoColumns,
  'cadre': _TemplateCommandType.boxes,
  'cadres': _TemplateCommandType.boxes,
  'boite': _TemplateCommandType.boxes,
  'boites': _TemplateCommandType.boxes,
  'boxes': _TemplateCommandType.boxes,
  'separator': _TemplateCommandType.separator,
  'separateur': _TemplateCommandType.separator,
  'trait': _TemplateCommandType.separator,
  'barre': _TemplateCommandType.separator,
  'pagebreak': _TemplateCommandType.pageBreak,
  'sautdepage': _TemplateCommandType.pageBreak,
  'nouvellepage': _TemplateCommandType.pageBreak,
};

const Map<String, String> _variableAliases = {
  'entreprise': 'entreprise',
  'societe': 'entreprise',
  'client': 'entreprise',
  'adresse1': 'adresse1',
  'adresse2': 'adresse2',
  'adresseprestataire': 'adressePrestataire',
  'prestataireadresse': 'adressePrestataire',
  'adresseprestataireinline': 'adressePrestataireInline',
  'prestataireadresseligne': 'adressePrestataireInline',
  'prestataireadresseinline': 'adressePrestataireInline',
  'numerocontrat': 'numeroContrat',
  'numcontrat': 'numeroContrat',
  'capital': 'capital',
  'matricule': 'matricule',
  'montantht': 'montantHT',
  'totalht': 'totalHT',
  'customtva': 'customTva',
  'tva': 'customTva',
  'montantttc': 'montantTTC',
  'date': 'date',
};

const List<String> _supportedVariables = [
  'entreprise',
  'adresse1',
  'adresse2',
  'adressePrestataire',
  'adressePrestataireInline',
  'numeroContrat',
  'capital',
  'matricule',
  'montantHT',
  'totalHT',
  'customTva',
  'montantTTC',
  'date',
  'equipment',
  'operation',
  'calendar',
  'annexeTexte',
  'imageList',
  'hasAstreinte',
  'astreintePrice',
  'twoColumns',
  'boxes',
  'separator',
  'pageBreak',
];

Future<void> createPdfFromMarkdown() async {
  try {
    // Chargement des assets utilisées dans le PDF
    final bytes5 = await rootBundle.load('assets/titleCadre.png');
    final titleCadre = pw.MemoryImage(bytes5.buffer.asUint8List());
    final bytes = await rootBundle.load('assets/footer.png');
    final footerImage = pw.MemoryImage(bytes.buffer.asUint8List());
    final bytes2 = await rootBundle.load('assets/header.png');
    final headerImage = pw.MemoryImage(bytes2.buffer.asUint8List());
    final bytes3 = await rootBundle.load('assets/signature.png');
    final signatureImage = pw.MemoryImage(bytes3.buffer.asUint8List());
    final bytes4 = await rootBundle.load('assets/bulletPoint.png');
    final bulletImage = pw.MemoryImage(bytes4.buffer.asUint8List());
    final font = await rootBundle.load('assets/fonts/Gotham-Book.ttf');
    final boldFont = await rootBundle.load('assets/fonts/Gotham-Bold.ttf');
    final italicFont =
        await rootBundle.load('assets/fonts/Gotham-BookItalic.ttf');

    // Synchronisation des données du contrat avant la génération du PDF
    syncContractCalendarWithSelectedEquipments();
    variablesContrat['numeroContrat'] = generateNumeroContrat();
    variablesContrat['equipPicked'] = equipPicked.equipList;
    ensureContractorAddressSelection();
    ensureContractAnnexStructure();

    final pdf = pw.Document();
    final markdownData = await rootBundle.loadString('assets/template.md');
    final markdownPages = _parseTemplate(
        markdownData); // Vérifie la syntaxe et renvoie des pages avec des éléments interprétables

    final classicStyle = pw.TextStyle(
      font: pw.Font.ttf(font),
      fontSize: 12,
      lineSpacing: 5,
    );
    final boldStyle = pw.TextStyle(
      font: pw.Font.ttf(boldFont),
      fontSize: 12,
      lineSpacing: 2,
    );
    final italicStyle = pw.TextStyle(
      font: pw.Font.ttf(italicFont),
      fontSize: 12,
      lineSpacing: 0.3,
    );
    final underlineStyle = pw.TextStyle(
      font: pw.Font.ttf(italicFont),
      decoration: pw.TextDecoration.underline,
    );
    const highlightedStyle = pw.TextStyle(
      background: pw.BoxDecoration(color: PdfColors.yellow),
    );
    final titleStyle = pw.TextStyle(
      font: pw.Font.ttf(boldFont),
      fontSize: 20,
      color: PdfColors.white,
    );

    final footer = pw.Container(
      alignment: pw.Alignment.bottomCenter,
      child: pw.Image(footerImage),
    );

    final header = pw.Container(
      alignment: pw.Alignment.topCenter,
      child: pw.Image(headerImage),
    );

    // Apparence d'une page classique (sans image dans l'en-tête)
    final mainPageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: footer,
        );
      },
    );

    // Apparence de la première page (avec image dans l'en-tête)
    final firstPageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        final pageWidth = PdfPageFormat.a4.width;
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Stack(
            children: [
              pw.Positioned(
                top: 0,
                child: pw.SizedBox(
                  width: pageWidth,
                  child: pw.FittedBox(
                    fit: pw.BoxFit.scaleDown,
                    child: header,
                  ),
                ),
              ),
              pw.Positioned(
                bottom: 0,
                child: pw.SizedBox(
                  width: pageWidth,
                  child: pw.FittedBox(
                    fit: pw.BoxFit.scaleDown,
                    child: footer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (markdownPages.length <= 2) {
      throw _TemplateException(
        "Template PDF : trop peu d'éléments dans le template pour générer un PDF",
      );
    } else {
      // Première page : on prend les éléments de la première page du template
      pdf.addPage(
        pw.Page(
          pageTheme: firstPageTheme,
          build: (pw.Context context) {
            return pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: _markdownToWidget(
                markdownPages.first,
                classicStyle,
                boldStyle,
                italicStyle,
                underlineStyle,
                titleStyle,
                highlightedStyle,
                bulletImage,
                titleCadre,
              ),
            );
          },
        ),
      );

      // Pages suivantes : on prend les éléments des pages suivantes sauf la dernière
      for (int i = 1; i < markdownPages.length - 1; i++) {
        pdf.addPage(
          pw.MultiPage(
            maxPages: 200,
            pageTheme: mainPageTheme,
            build: (pw.Context context) {
              return _markdownToWidget(
                markdownPages[i],
                classicStyle,
                boldStyle,
                italicStyle,
                underlineStyle,
                titleStyle,
                highlightedStyle,
                bulletImage,
                titleCadre,
              );
            },
          ),
        );
      }

      // Dernière page : on ajoute la signature
      pdf.addPage(
        pw.Page(
          pageTheme: mainPageTheme,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: _markdownToWidget(
                    markdownPages.last,
                    classicStyle,
                    boldStyle,
                    italicStyle,
                    underlineStyle,
                    titleStyle,
                    highlightedStyle,
                    bulletImage,
                    titleCadre,
                  ),
                ),
                pw.Positioned(
                  bottom: 0,
                  right: 0,
                  child: pw.Image(signatureImage, width: 300, height: 200),
                ),
              ],
            );
          },
        ),
      );
    }

    // Enregistrement du PDF dans le dossier "Contrat" de l'appareil
    final directory = Directory('Contrat');
    if (!await directory.exists()) {
      await directory.create();
    }

    await File('Contrat/${generateNomFichier()}.pdf')
        .writeAsBytes(await pdf.save());
  } on _TemplateException {
    rethrow;
  } catch (e) {
    throw _TemplateException('Erreur génération du PDF : $e');
  }
}

List<List<_TemplateLine>> _parseTemplate(String markdownData) {
  final normalizedMarkdown = markdownData
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n'); // Normalisation des sauts de ligne
  final rawLines = const LineSplitter().convert(
      normalizedMarkdown); // Split en lignes tout en conservant les numéros de ligne pour les erreurs
  final pages = <List<_TemplateLine>>[
    <_TemplateLine>[],
  ];

  for (int index = 0; index < rawLines.length; index++) {
    final line = _TemplateLine(
        number: index + 1,
        text: rawLines[
            index]); // Numéro de ligne pour les messages d'erreur plus clairs
    _validateTemplateLine(line); // Vérification de la syntaxe de chaque ligne

    if (_isPageBreakLine(line.text, line.number)) {
      // Si commande de saut de page, on démarre une nouvelle page
      pages.add(<_TemplateLine>[]);
      continue;
    }

    pages.last.add(
        line); // Sinon, on ajoute la ligne à la page courante (on utilise un multi-page, donc pas de vérification s'il y a la place)
  }

  return pages;
}

void _validateTemplateLine(_TemplateLine line) {
  _validateClosingBranckets(line);

  final trimmed = line.text.trim();
  if (trimmed.isEmpty) {
    return;
  }

  final templateCommand = _parseTemplateCommand(trimmed,
      line.number); // Renvoie la commande et ses arguments correctement parsés
  if (templateCommand != null) {
    return;
  }

  _validateInlineVariables(line);
}

void _validateClosingBranckets(_TemplateLine line) {
  final mustacheOpenCount = RegExp(r'\{\{').allMatches(line.text).length;
  final mustacheCloseCount = RegExp(r'\}\}').allMatches(line.text).length;
  if (mustacheOpenCount != mustacheCloseCount) {
    throw _TemplateException(
      'Template PDF : ligne ${line.number} - les accolades "{{ ... }}" ne sont pas fermées correctement.',
    );
  }
}

void _validateInlineVariables(_TemplateLine line) {
  for (final match
      in RegExp(r'\{\{\s*([^{}]+?)\s*\}\}').allMatches(line.text)) {
    final rawToken = match.group(1)!;
    if (_resolveVariableKey(rawToken) != null) {
      continue;
    }

    if (_resolveCommandType(rawToken) != null) {
      throw _TemplateException(
        'Template PDF : ligne ${line.number} - la commande "{{ ${rawToken.trim()} }}" doit être seule sur sa ligne.',
      );
    }

    throw _unknownVariableException(rawToken, line.number);
  }
}

_TemplateCommand? _parseTemplateCommand(String trimmedLine, int lineNumber) {
  final match = RegExp(r'^\{\{\s*(.*?)\s*\}\}$').firstMatch(trimmedLine);
  if (match == null) {
    return null; // Aucune commande à cette ligne
  }

  final commandContent = match.group(1)!.trim();
  if (commandContent.isEmpty) {
    throw _TemplateException(
      'Template PDF : ligne $lineNumber - accolade vide. Utilisez par exemple {{ entreprise }} ou {{ equipements }}.',
    );
  }

  final parts = commandContent.split('|').map((part) => part.trim()).toList();
  final commandType = _resolveCommandType(parts
      .first); // On cherche le vrai nom de la commande (sans alias et normalisé)

  if (commandType == null) {
    if (parts.length > 1) {
      throw _unknownCommandException(parts.first, lineNumber);
    }
    return null;
  }

  return _buildCommand(commandType, parts.skip(1).toList(), lineNumber);
}

_TemplateCommand _buildCommand(
  _TemplateCommandType type,
  List<String> arguments,
  int lineNumber,
) {
  switch (type) {
    case _TemplateCommandType.equipment:
    case _TemplateCommandType.operation:
    case _TemplateCommandType.calendar:
    case _TemplateCommandType.annexText:
    case _TemplateCommandType.imageList:
    case _TemplateCommandType.separator:
    case _TemplateCommandType.pageBreak:
      if (arguments.any((argument) => argument.isNotEmpty)) {
        throw _TemplateException(
          'Template PDF : ligne $lineNumber - cette commande ne doit pas avoir de paramètre.',
        );
      }
      return _TemplateCommand(
          type: type, arguments: const [], lineNumber: lineNumber);
    case _TemplateCommandType.astreinteText:
      if (arguments.length < 2 ||
          arguments[0].isEmpty ||
          arguments[1].isEmpty) {
        throw _TemplateException(
          'Template PDF : ligne $lineNumber - la commande astreinte_texte attend 2 textes : {{ astreinte_texte | texte si oui | texte si non }}.',
        );
      }
      _validateTextArguments(arguments.take(2).toList(), lineNumber);
      return _TemplateCommand(
          type: type,
          arguments: arguments.take(2).toList(),
          lineNumber: lineNumber);
    case _TemplateCommandType.astreintePrice:
      if (arguments.isEmpty || arguments.first.isEmpty) {
        throw _TemplateException(
          'Template PDF : ligne $lineNumber - la commande astreinte_prix attend 1 libellé : {{ astreinte_prix | Supplément astreinte }}.',
        );
      }
      _validateTextArguments([arguments.first], lineNumber);
      return _TemplateCommand(
          type: type, arguments: [arguments.first], lineNumber: lineNumber);
    case _TemplateCommandType.twoColumns:
      if (arguments.length < 2 ||
          arguments[0].isEmpty ||
          arguments[1].isEmpty) {
        throw _TemplateException(
          'Template PDF : ligne $lineNumber - la commande ligne attend 2 textes : {{ ligne | texte de gauche | texte de droite }}.',
        );
      }
      _validateTextArguments(arguments, lineNumber);
      return _TemplateCommand(
          type: type, arguments: arguments, lineNumber: lineNumber);
    case _TemplateCommandType.boxes:
      if (arguments.length < 2 ||
          arguments.any((argument) => argument.isEmpty)) {
        throw _TemplateException(
          'Template PDF : ligne $lineNumber - la commande cadres attend au moins 2 textes : {{ cadres | gauche | droite }}.',
        );
      }
      _validateTextArguments(arguments, lineNumber);
      return _TemplateCommand(
          type: type, arguments: arguments, lineNumber: lineNumber);
  }
}

void _validateTextArguments(List<String> arguments, int lineNumber) {
  for (final argument in arguments) {
    final line = _TemplateLine(number: lineNumber, text: argument);
    _validateClosingBranckets(line);
    _validateInlineVariables(line);
  }
}

bool _isPageBreakLine(String line, int lineNumber) {
  final trimmed = line.trim();
  final command = _parseTemplateCommand(trimmed, lineNumber);
  return command?.type == _TemplateCommandType.pageBreak;
}

String _normalizeToken(String value) {
  final trimmed = removeDiacritics(value).toLowerCase().trim();
  return trimmed.replaceAll(RegExp(r'[\s_\-]+'), '');
}

_TemplateCommandType? _resolveCommandType(String rawToken) {
  return _commandAliases[_normalizeToken(rawToken)];
}

String? _resolveVariableKey(String rawToken) {
  final normalizedToken = _normalizeToken(rawToken);
  return _variableAliases[normalizedToken];
}

_TemplateException _unknownVariableException(String rawToken, int lineNumber) {
  return _TemplateException(
    'Template PDF : ligne $lineNumber - variable "${rawToken.trim()}" inconnue. Variables disponibles : ${_supportedVariables.join(', ')}.',
  );
}

_TemplateException _unknownCommandException(
  String rawToken,
  int lineNumber,
) {
  return _TemplateException(
    'Template PDF : ligne $lineNumber - commande "${rawToken.trim()}" inconnue. Exemple : {{ equipements }}.',
  );
}

List<pw.Widget> _markdownToWidget(
  List<_TemplateLine> markdownLines,
  pw.TextStyle classicStyle,
  pw.TextStyle boldStyle,
  pw.TextStyle italicStyle,
  pw.TextStyle underlineStyle,
  pw.TextStyle titleStyle,
  pw.TextStyle highlightedStyle,
  pw.MemoryImage bulletImage,
  pw.MemoryImage titleCadre,
) {
  return markdownLines.expand<pw.Widget>((line) {
    final trimmed = line.text.trim();
    if (trimmed.isEmpty) {
      return [pw.SizedBox(height: 8)]; // Espacement pour les lignes vides
    }

    final command = _parseTemplateCommand(trimmed, line.number);
    if (command != null) {
      return _buildCommandWidgets(
        command,
        titleStyle,
        classicStyle,
        boldStyle,
        italicStyle,
        underlineStyle,
        highlightedStyle,
        bulletImage,
        titleCadre,
      );
    }

    final mdElement = md.Document().parse(line.text).firstOrNull;
    if (mdElement is md.Element) {
      return [
        _formatMarkdown(
          mdElement,
          line.number,
          classicStyle,
          boldStyle,
          italicStyle,
          underlineStyle,
          titleStyle,
          highlightedStyle,
          bulletImage,
          titleCadre,
        ),
      ];
    }

    return [
      pw.Text(_insertInformation(line.text, line.number), style: classicStyle),
    ];
  }).toList();
}

String _insertInformation(String text, int lineNumber) {
  String replaceVariable(Match match, String rawToken) {
    final key = _resolveVariableKey(rawToken);
    if (key == null) {
      throw _unknownVariableException(rawToken, lineNumber);
    }

    if (key == 'adressePrestataireInline') {
      return formatContractorAddressInline(
        variablesContrat['adressePrestataire']?.toString() ?? '',
      );
    }

    if (!variablesContrat.containsKey(key)) {
      throw _TemplateException(
        'Template PDF : ligne $lineNumber - la variable "$key" n\'est pas disponible dans l\'application.',
      );
    }

    final value = variablesContrat[key];
    if (key == 'adressePrestataire') {
      return formatContractorAddressForContract(value.toString());
    }

    if (value is double) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  var output = text.replaceAllMapped(
    RegExp(r'\{\{\s*([^{}]+?)\s*\}\}'),
    (match) => replaceVariable(match, match.group(1)!),
  );

  return output;
}

List<pw.Widget> _buildCommandWidgets(
  _TemplateCommand command,
  pw.TextStyle titleStyle,
  pw.TextStyle classicStyle,
  pw.TextStyle boldStyle,
  pw.TextStyle italicStyle,
  pw.TextStyle underlineStyle,
  pw.TextStyle highlightedStyle,
  pw.MemoryImage bulletImage,
  pw.MemoryImage titleCadre,
) {
  switch (command.type) {
    case _TemplateCommandType.annexText:
      final widgets = _buildAnnexTextWidgets(
        titleStyle,
        classicStyle,
        boldStyle,
        bulletImage,
        titleCadre,
      );
      return widgets.isEmpty ? [pw.Container()] : widgets;
    case _TemplateCommandType.imageList:
      if (imageList.isEmpty) {
        return [pw.Container()];
      }

      final widgets = <pw.Widget>[];
      final text = imageList.length > 1 ? 'Pièces Jointes' : 'Pièce Jointe';
      widgets.add(_buildTitleBanner(text, titleStyle, titleCadre));

      for (int i = 0; i < imageList.length; i += 2) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                pw.Container(
                  width: 240,
                  height: 330,
                  child: pw.Image(pw.MemoryImage(base64Decode(imageList[i]))),
                ),
                if (i + 1 < imageList.length)
                  pw.Container(
                    width: 240,
                    height: 330,
                    child: pw.Image(
                        pw.MemoryImage(base64Decode(imageList[i + 1]))),
                  ),
              ],
            ),
          ),
        );
      }

      return widgets;
    case _TemplateCommandType.astreinteText:
      final astreinteTexte = variablesContrat['hasAstreinte']
          ? _insertInformation(command.arguments[0], command.lineNumber)
          : _insertInformation(command.arguments[1], command.lineNumber);
      return [
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3),
                child: pw.Image(bulletImage, width: 10, height: 10),
              ),
              pw.SizedBox(width: 5),
              pw.Expanded(child: pw.Text(astreinteTexte, style: classicStyle)),
            ],
          ),
        ),
      ];
    case _TemplateCommandType.astreintePrice:
      if (!variablesContrat['hasAstreinte']) {
        return [pw.Container()];
      }

      return [
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Row(
            children: [
              pw.Text(
                  _insertInformation(
                      command.arguments.first, command.lineNumber),
                  style: boldStyle),
              pw.Spacer(),
              variablesContrat['montantAstreinte'] == 0.0
                  ? pw.Text('Offerte', style: boldStyle)
                  : pw.Text(
                      '${(variablesContrat['montantAstreinte'] as double).toInt()} €',
                      style: boldStyle),
            ],
          ),
        ),
      ];
    case _TemplateCommandType.calendar:
      if (selectedCalendar.isEmpty) {
        return [pw.Container()];
      }
      return buildCalendar(selectedCalendar, classicStyle, boldStyle);
    case _TemplateCommandType.operation:
      if ((variablesContrat['equipPicked'] as List<dynamic>).isEmpty) {
        return [pw.Container()];
      }
      return buildOperation(variablesContrat['equipPicked'] as List<Equipment>,
          classicStyle, boldStyle);
    case _TemplateCommandType.equipment:
      if ((variablesContrat['equipPicked'] as List<dynamic>).isEmpty) {
        return [pw.Container()];
      }
      return buildEquipment(variablesContrat['equipPicked'] as List<Equipment>,
          classicStyle, boldStyle);
    case _TemplateCommandType.twoColumns:
      return [
        _buildTwoColumns(
          command.arguments
              .map((argument) =>
                  _insertInformation(argument, command.lineNumber))
              .toList(),
          boldStyle,
        ),
      ];
    case _TemplateCommandType.boxes:
      return [
        _buildBoxes(
          command.arguments
              .map((argument) =>
                  _insertInformation(argument, command.lineNumber))
              .toList(),
        ),
      ];
    case _TemplateCommandType.separator:
      return [
        pw.Divider(
          color: PdfColors.black,
          thickness: 1.0,
        ),
      ];
    case _TemplateCommandType.pageBreak:
      return const [];
  }
}

pw.Widget _formatMarkdown(
  dynamic mdContent,
  int lineNumber,
  pw.TextStyle classicStyle,
  pw.TextStyle boldStyle,
  pw.TextStyle italicStyle,
  pw.TextStyle underlineStyle,
  pw.TextStyle titleStyle,
  pw.TextStyle highlightedStyle,
  pw.MemoryImage bulletImage,
  pw.MemoryImage titleCadre,
) {
  final mdText = _insertInformation(mdContent.textContent, lineNumber);

  if (mdContent is md.Element) {
    final children = mdContent.children ?? const <md.Node>[];
    final child = children.isNotEmpty ? children.first : null;

    if (mdContent.tag == 'h1') {
      return _buildTitleBanner(mdText, titleStyle, titleCadre);
    }

    if (mdContent.tag == 'hr') {
      return pw.Divider(
        color: PdfColors.black,
        thickness: 1.0,
      );
    }

    if (child is md.Element && child.tag == 'strong') {
      final highlightedMatch = RegExp(r'<s>(.*?)</s>').firstMatch(mdText);
      if (highlightedMatch != null) {
        return pw.Text(highlightedMatch.group(1)!, style: underlineStyle);
      }
      return pw.Text(mdText, style: boldStyle);
    }

    if (mdContent.tag == 'ul') {
      return _buildBulletRow(mdText, classicStyle, bulletImage);
    }

    if (mdContent.tag == 'em') {
      return pw.Text(mdText, style: italicStyle);
    }

    if (mdContent.tag == 'p') {
      final underlinedMatch = RegExp(r'<u>(.*?)</u>').firstMatch(mdText);
      if (underlinedMatch != null) {
        return pw.Text(underlinedMatch.group(1)!, style: underlineStyle);
      }
      return pw.Text(mdText, style: classicStyle);
    }
  }

  return pw.Container();
}

List<pw.Widget> _buildAnnexTextWidgets(
  pw.TextStyle titleStyle,
  pw.TextStyle classicStyle,
  pw.TextStyle boldStyle,
  pw.MemoryImage bulletImage,
  pw.MemoryImage titleCadre,
) {
  final annex = contractAnnex;
  final subtitles = annex.displayableSubtitles;
  if (subtitles.isEmpty) {
    return const <pw.Widget>[];
  }

  final widgets = <pw.Widget>[
    _buildTitleBanner(
      annex.title.trim().isNotEmpty ? annex.title.trim() : 'Annexe',
      titleStyle,
      titleCadre,
    ),
  ];

  for (final subtitle in subtitles) {
    final subtitleTitle = subtitle.title.trim();
    if (subtitleTitle.isNotEmpty) {
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
          child: pw.Text(subtitleTitle, style: boldStyle),
        ),
      );
    }

    for (final remark in subtitle.displayableRemarks) {
      widgets.add(
        _buildBulletRow(
          remark.text.trim(),
          classicStyle,
          bulletImage,
        ),
      );
    }
  }

  return widgets;
}

pw.Widget _buildTitleBanner(
  String text,
  pw.TextStyle titleStyle,
  pw.MemoryImage titleCadre,
) {
  return pw.SizedBox(
    width: double.infinity,
    height: titleCadre.height! /
        (titleCadre.width as num) *
        (PdfPageFormat.a4.width -
            PdfPageFormat.a4.marginLeft -
            PdfPageFormat.a4.marginRight),
    child: pw.Stack(
      children: [
        pw.Image(titleCadre, fit: pw.BoxFit.cover),
        pw.Center(
          child: pw.Text(text, style: titleStyle),
        ),
      ],
    ),
  );
}

pw.Widget _buildBulletRow(
  String text,
  pw.TextStyle classicStyle,
  pw.MemoryImage bulletImage,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(left: 20),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 3),
          child: pw.Image(bulletImage, width: 10, height: 10),
        ),
        pw.SizedBox(width: 5),
        pw.Expanded(child: pw.Text(text, style: classicStyle)),
      ],
    ),
  );
}

pw.Widget _buildTwoColumns(List<String> parts, pw.TextStyle boldStyle) {
  final cleanedParts = parts.map((part) => part.trim()).toList();
  return pw.Padding(
    padding: const pw.EdgeInsets.only(left: 20),
    child: cleanedParts.length > 1
        ? pw.Row(
            children: [
              pw.Text(cleanedParts.first, style: boldStyle),
              pw.Spacer(),
              pw.Text(cleanedParts.sublist(1).join(' | '), style: boldStyle),
            ],
          )
        : pw.Text(cleanedParts.isNotEmpty ? cleanedParts.first : '',
            style: boldStyle),
  );
}

pw.Widget _buildBoxes(List<String> phrases) {
  final box1 = <String>[];
  final box2 = <String>[];

  for (int i = 0; i < phrases.length; i++) {
    if (i.isEven) {
      box1.add(phrases[i]);
    } else {
      box2.add(phrases[i]);
    }
  }

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
    children: [
      _buildBox(box1),
      pw.Spacer(),
      _buildBox(box2),
    ],
  );
}

pw.Widget _buildBox(List<String> phrases) {
  return pw.Container(
    width: 200,
    height: 80,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.black),
      color: PdfColors.white,
    ),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: phrases.map((phrase) => pw.Text(phrase)).toList(),
    ),
  );
}
