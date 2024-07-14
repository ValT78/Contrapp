import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;

Map<String, String> variablesContrat = {
  'Entreprise': 'TWitter.com',
  'Adresse1': 'Ar;:;!;:!;:ds.+--sq+d-+qsd',
  'Adresse2': '12 rue de la Paix',
  'Numero': '12313(12)',
  'Capital': '123125€',
  'Matricule': '123  23-556 546',
  'Montant_HT': '1255',
  'Montant_TTC': '1000',
  'Date': '01/01/2022',
  'NumeroContrat': '220101001',
  'Astreinte': 'Accès au service de dépannage 24h/24 et 7j/7',
  'PrixAstreinte': 'Offerte'
};

void _createPdfFromMarkdown() async {

  
  final pdf = pw.Document();
  final markdownData = await rootBundle.loadString('assets/template.md');

  final markdownWithReturn = markdownData.replaceAll(RegExp(r'\r\n\r\n'), '\r\n \r\n');

  final parsedMarkdown = markdownWithReturn.split("___");
  final markdownParagraph = parsedMarkdown.map((e) => e.split('\r\n')).toList();

  final font = await rootBundle.load("assets/fonts/Metropolis-Regular.ttf");
  final boldFont = await rootBundle.load("assets/fonts/Metropolis-Bold.ttf");
  final italicFont = await rootBundle.load("assets/fonts/Metropolis-RegularItalic.ttf");
  
  
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
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('assets/footer.png')).buffer.asUint8List(),
  );
  final headerImage = pw.MemoryImage(
    (await rootBundle.load('assets/header.png')).buffer.asUint8List(),
  );
  final signatureImage = pw.MemoryImage(
    (await rootBundle.load('assets/signature.png')).buffer.asUint8List(),
  );
  final bulletImage = pw.MemoryImage(
    (await rootBundle.load('assets/bulletPoint.png')).buffer.asUint8List(),
  );

  final titleCadre = pw.MemoryImage(
    File('assets/titleCadre.png').readAsBytesSync(),
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
        children: _markdownToWidget(markdownParagraph[0], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle, titleCadre, bulletImage),
      );
    },
  ),
);



// Ensuite, générez les pages suivantes avec le thème mainPageTheme
pdf.addPage(
  pw.MultiPage(
    pageTheme: mainPageTheme,
    build: (pw.Context context) {
      // Ici, vous pouvez ajouter le contenu des pages suivantes
      // Par exemple, vous pouvez ajouter tous les éléments de parsedMarkdown sauf le premier
      return _markdownToWidget(markdownParagraph[1], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle, titleCadre, bulletImage);
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
            children: _markdownToWidget(markdownParagraph[2], classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle, titleCadre, bulletImage),
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

List<pw.Widget> _markdownToWidget(List<String> markdownParagraph, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle underlineStyle, pw.TextStyle titleStyle, pw.TextStyle highlightedStyle, pw.ImageProvider titleCadre, pw.ImageProvider bulletImage) {
  return markdownParagraph.expand<pw.Widget>((element) {
  if(element == ' ') {
    return [pw.SizedBox(height: 12)]; // Réduisez l'espace entre les paragraphes en ajustant la hauteur
  }
  else {
    final mdElement = md.Document().parse(element).firstOrNull;
    if(mdElement is md.Element) {
      return [_formatMarkdown(mdElement, classicStyle, boldStyle, italicStyle, underlineStyle, titleStyle, highlightedStyle, titleCadre, bulletImage)];
    }          
  }
  return [pw.Container()];
}).toList();
}

String _insertInformation(String text) {
  return text.replaceAllMapped(RegExp('==(.+?)=='), (Match m) {

    final key = m.group(1);
    if(variablesContrat.containsKey(key)) {
      return variablesContrat[key]!;
    }
    // Récupérer l'instance de la classe MesVariablesGlobales
      return text; // Add a return statement at the end

  });
}


  pw.Widget _formatMarkdown(mdContent, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle underlineStyle, pw.TextStyle titleStyle, pw.TextStyle highlightedStyle, pw.ImageProvider titleCadre, pw.ImageProvider bulletImage) {

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
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3), // Ajustez la valeur du padding en haut selon vos besoins
              child: pw.Image(bulletImage, width: 10, height: 10), // Remplacez la taille par celle qui vous convient
            ),
            pw.SizedBox(width: 5), // Espace entre l'image et le texte
            pw.Expanded(child: pw.Text(mdText, style: classicStyle)),
          ],
        );
      }
      else if (mdContent.tag == 'em') {
        return pw.Text(mdText, style: italicStyle);
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