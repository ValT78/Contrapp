import 'dart:io';
import 'package:contrapp/object/equipment.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;
import 'package:contrapp/main.dart';
import 'dart:convert';

import 'package:contrapp/pdf/calendar_object.dart';
import 'package:contrapp/pdf/operation_object.dart';
import 'package:contrapp/pdf/equipment_object.dart';

final titleCadre = pw.MemoryImage(
    File('assets/titleCadre.png').readAsBytesSync(),
);

final footerImage = pw.MemoryImage(
  File('assets/footer.png').readAsBytesSync(),
  );
  final headerImage = pw.MemoryImage(
  File('assets/header.png').readAsBytesSync(),
  );
  final signatureImage = pw.MemoryImage(
  File('assets/signature.png').readAsBytesSync(),
  );
  final bulletImage = pw.MemoryImage(
  File('assets/bulletPoint.png').readAsBytesSync(),
  );


void createPdfFromMarkdown() async {
  variablesContrat['numeroContrat'] = generateNumeroContrat(variablesContrat['date'], variablesContrat['versionContrat']);
  
  final pdf = pw.Document();

  final markdownData = await rootBundle.loadString('assets/template.md');
  final markdownWithReturn = markdownData.replaceAll(RegExp(r'\r\n\r\n'), '\r\n \r\n');
  final parsedMarkdown = markdownWithReturn.split("___");
  final markdownParagraph = parsedMarkdown.map((e) => e.split('\r\n')).toList();

  final font = await rootBundle.load("assets/fonts/Gotham-Book.ttf");
  final boldFont = await rootBundle.load("assets/fonts/Gotham-Bold.ttf");
  final italicFont = await rootBundle.load("assets/fonts/Gotham-BookItalic.ttf");
  
  final classicStyle = pw.TextStyle(font: pw.Font.ttf(font), fontSize: 12, lineSpacing: 5);
  final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldFont), fontSize: 12, lineSpacing: 2);
  final italicStyle = pw.TextStyle(font: pw.Font.ttf(italicFont), fontSize: 12, lineSpacing: 0.3);
  final underlineStyle = pw.TextStyle(font: pw.Font.ttf(italicFont), decoration: pw.TextDecoration.underline);
  const highlightedStyle = pw.TextStyle(background: pw.BoxDecoration(color: PdfColors.yellow));
  final titleStyle = pw.TextStyle(
    font: pw.Font.ttf(boldFont),
    fontSize: 20,
    color: PdfColors.white, // Rend l'écriture blanche

  );
  

  final footer = pw.Container(
    alignment: pw.Alignment.bottomCenter,
    child: pw.Image(footerImage),
  );

  final header = pw.Container(
    alignment: pw.Alignment.topCenter,
    child: pw.Image(headerImage)
  );

  final mainPageTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: footer,
      );
    },
  );

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
                  child: header, // Votre widget d'en-tête
                  fit: pw.BoxFit.scaleDown,
                ),
              ),
            ),
            pw.Positioned(
              bottom: 0,
              child: pw.SizedBox(
                width: pageWidth,
                child: pw.FittedBox(
                  child: footer, // Votre widget de pied de page
                  fit: pw.BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

// Ensuite, ajoutez les pages suivantes sans l'image dans l'en-tête
// Générez d'abord la première page avec le thème firstPageTheme
  pdf.addPage(
    pw.Page(
      pageTheme: firstPageTheme,
      build: (pw.Context context) {
        return pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: _markdownToWidget(markdownParagraph[0], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle),
        );
      },
    ),
  );



  // Ensuite, générez les pages suivantes avec le thème mainPageTheme
  pdf.addPage(
  pw.MultiPage(
    pageTheme: mainPageTheme,
    build: (pw.Context context) {
      return [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20), // Ajustez cette valeur selon vos besoins
          child: pw.Column(
            children: _markdownToWidget(markdownParagraph[1], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle)
          ),
        ),
      ];
    },
  ),
);



  // Ajouter l'image de signature en bas à droite de la feuille
  pdf.addPage(
    pw.Page(
      pageTheme: mainPageTheme,
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: _markdownToWidget(markdownParagraph[2], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle),
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

  await File('Contrat/monFichier.pdf').writeAsBytes(await pdf.save());
}

String generateNumeroContrat(String date, int versionContrat) {
  final elements = date.split('/');
  String version = versionContrat.toString().padLeft(3, '0');
  
  return '${elements[2].padLeft(2)}${elements[1]}${elements[0]}$version';
}

List<pw.Widget> _markdownToWidget(List<String> markdownParagraph, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle underlineStyle, pw.TextStyle titleStyle, pw.TextStyle highlightedStyle) {
  return markdownParagraph.expand<pw.Widget>((element) {
  if(element == ' ') {
    return [pw.SizedBox(height: 12)]; // Réduisez l'espace entre les paragraphes en ajustant la hauteur
  }
  else if(element.startsWith('&&')) {
    return _insertGraph(element, titleStyle, classicStyle, boldStyle, italicStyle, underlineStyle, highlightedStyle);
  }
  else {
    final mdElement = md.Document().parse(element).firstOrNull;
    if(mdElement is md.Element) {
      return [_formatMarkdown(mdElement, classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle)];
    }          
  }
  return [pw.Container()];
}).toList();
}

String _insertInformation(String text) {
  return text.replaceAllMapped(RegExp('==(.+?)=='), (Match m) {

    final key = m.group(1);
    if(variablesContrat.containsKey(key)) {
      return variablesContrat[key].toString();
    }
    // Récupérer l'instance de la classe MesVariablesGlobales
      return text; // Add a return statement at the end

  });
}

List<pw.Widget> _insertGraph(String element, pw.TextStyle titleStyle, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle underlineStyle, pw.TextStyle highlightedStyle) {
  if(element.contains('attachList')) {
    // Vérifiez si attachList est vide
    if (attachList.isEmpty) {
      return [pw.Container()]; // Retournez un widget vide
    }

    // Déterminez le texte à utiliser en fonction du nombre d'images
    final String text = attachList.length > 1 ? "Pièces Jointes" : "Pièce Jointe";

    // Créez une nouvelle liste de pw.Widget
    List<pw.Widget> widgets = [];

    // Ajoutez votre pw.SizedBox à la liste
    widgets.add(
      pw.SizedBox(
        width: double.infinity, // ou une autre valeur pour la largeur
        height: titleCadre.height! / (titleCadre.width as num) * (PdfPageFormat.a4.width - PdfPageFormat.a4.marginLeft - PdfPageFormat.a4.marginRight),
        child: pw.Stack(
          children: [
            pw.Image(titleCadre, fit: pw.BoxFit.cover), // Utilisez l'image ici
            pw.Center(
              child: pw.Text(text, style: titleStyle), // Utilisez le texte déterminé ici
            ),
          ],
        ),
      ),
    );

    // Ajoutez vos images à la liste
    widgets.addAll(
      attachList.map((imageItem) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(10), // Ajoutez un espace autour de l'image
          child: pw.Container(
            width: 500, // Contrôlez la largeur de l'image
            height: 500, // Contrôlez la hauteur de l'image
            child: pw.Image(pw.MemoryImage(base64Decode(imageItem))),
          ),
        );
      }).toList(),
    );

    // Renvoie la liste de widgets
    return widgets;
  }
  else if(element.contains('astreinteTexte')) {
    final String astreinteTexte;
    if(variablesContrat['hasAstreinte']) {
      astreinteTexte = "Accès au service de dépannage 24h/24 et 7j/7";
    }
    else {
      astreinteTexte = "Pas d'astreinte";
    }
    return [pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20), 
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3), // Ajustez la valeur du padding en haut selon vos besoins
                child: pw.Image(bulletImage, width: 10, height: 10), // Remplacez la taille par celle qui vous convient
              ),
              pw.SizedBox(width: 5), // Espace entre l'image et le texte
              pw.Expanded(child: pw.Text(astreinteTexte, style: classicStyle)),
            ],
          ),
        )];
  }

  else if(element.contains('astreintePrice')) {
    if(variablesContrat['hasAstreinte']) {
      return [pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20), // Utilisez la valeur de leftPadding
          child: pw.Expanded(
            child: pw.Row(
                  children: [
                    pw.Text("Supplément Astreinte 24/24", style: boldStyle),
                    pw.Spacer(), // Utilisez Spacer pour pousser le reste du texte à droite
                    variablesContrat['montantAstreinte'] == 0 ? pw.Text("Offerte", style: boldStyle) : pw.Text("${variablesContrat['montantAstreinte']} €", style: boldStyle),
                  ],
                )
          ),
        )
      ];
    }
  }
  else if(element.contains('calendar')) {
    return buildCalendar(variablesContrat['selectedCalendar'] as Map<String, Map<String, bool>>, classicStyle, boldStyle);
  }

  else if(element.contains('operation')) {
    return buildOperation(variablesContrat['equipPicked'] as List<Equipment>, classicStyle, boldStyle);
  }

  else if(element.contains('equipment')) {
    return buildEquipment(variablesContrat['equipPicked'] as List<Equipment>, classicStyle, boldStyle);
  }

  return [pw.Container()];
}


  pw.Widget _formatMarkdown(mdContent, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle underlineStyle, pw.TextStyle titleStyle, pw.TextStyle highlightedStyle) {

    String mdText = _insertInformation(mdContent.textContent);

    final child = mdContent.children[0];
    if(mdContent is md.Element) {

      if(mdContent.tag == 'h1') {
        return pw.SizedBox(
          width: double.infinity, // ou une autre valeur pour la largeur
          height: titleCadre.height! / (titleCadre.width as num) * (PdfPageFormat.a4.width - PdfPageFormat.a4.marginLeft - PdfPageFormat.a4.marginRight),
          child: pw.Stack(
            children: [
              pw.Image(titleCadre, fit: pw.BoxFit.cover), // Utilisez l'image ici
              pw.Center(
                child: pw.Text(mdText, style: titleStyle),
              ),
            ],
          ),
        );
      }
      else if(child is md.Element && child.tag == 'strong') {
        final highlightedMatch = RegExp(r'<s>(.*?)</s>').firstMatch(mdText);
        if(highlightedMatch != null) {
          return pw.Text(highlightedMatch.group(1)!, style: underlineStyle);
        }
        return pw.Text(mdText, style: boldStyle);
      }

      else if (mdContent.tag == 'ul') {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20), 
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3), // Ajustez la valeur du padding en haut selon vos besoins
                child: pw.Image(bulletImage, width: 10, height: 10), // Remplacez la taille par celle qui vous convient
              ),
              pw.SizedBox(width: 5), // Espace entre l'image et le texte
              pw.Expanded(child: pw.Text(mdText, style: classicStyle)),
            ],
          ),
        );
      }
      else if (mdContent.tag == 'em') {
        return pw.Text(mdText, style: italicStyle);
      }
      else if(mdText.startsWith('<tab>')) {
        mdText = mdText.replaceFirst('<tab>', '');
        List<String> parts = mdText.split('|'); // Divisez le texte en deux parties à partir de :

        return pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20), // Utilisez la valeur de leftPadding
          child: pw.Expanded(
            child: parts.length > 1
              ? pw.Row(
                  children: [
                    pw.Text(parts[0], style: boldStyle),
                    pw.Spacer(), // Utilisez Spacer pour pousser le reste du texte à droite
                    pw.Text(parts.sublist(1).join('|'), style: boldStyle),
                  ],
                )
              : pw.Text(mdText, style: classicStyle),
          ),
        );
      }
      else if (mdContent.tag == 'p') {
        final underlinedMatch = RegExp(r'<u>(.*?)</u>').firstMatch(mdText);
        if(underlinedMatch != null) {
          return pw.Text(underlinedMatch.group(1)!, style: underlineStyle);
        }
        return pw.Text(mdText, style: classicStyle);
      }
    }
    
    return pw.Container();
  }