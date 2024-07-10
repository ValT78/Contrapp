import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
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
  'Montant_HT': '1255€',
  'Montant_TTC': '1000€',
  'Date': '01/01/2022',
  'NumeroContrat': '220101001',
  'Astreinte': 'Accès au service de dépannage 24h/24 et 7j/7',
  'Astreinte2': 'Offerte'
};

void main() {

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrapp',

      theme: ThemeData(fontFamily: 'Metropolis'),


      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contrapp'),
        ),
        backgroundColor: Colors.blue,
        body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Appuyez sur le bouton pour générer un fichier texte'),
            ElevatedButton(
              onPressed: _createPdfFromMarkdown,
              child: Text('Créer un fichier texte'),
            ),
          ],
        ),
      ),
      ),
    );
  }
} 


void _createPdfFromMarkdown() async {

  
  final pdf = pw.Document();
  final markdownData = await rootBundle.loadString('assets/template.md');

  final markdownWithReturn = markdownData.replaceAll(RegExp(r'\r\n\r\n'), '\r\n \r\n');

  final parsedMarkdown = markdownWithReturn.split("___");
  final markdownParagraph = parsedMarkdown.map((e) => e.split('\r\n')).toList();
  print(markdownParagraph);

  final font = await rootBundle.load("assets/fonts/Metropolis-Regular.ttf");
  final boldFont = await rootBundle.load("assets/fonts/Metropolis-Bold.ttf");
  final italicFont = await rootBundle.load("assets/fonts/Metropolis-RegularItalic.ttf");
  
  
  final classicStyle = pw.TextStyle(font: pw.Font.ttf(font), fontSize: 12);
  final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldFont), fontSize: 12);
  final italicStyle = pw.TextStyle(font: pw.Font.ttf(italicFont), fontSize: 12);
  final titleStyle = pw.TextStyle(
    font: pw.Font.ttf(boldFont),
    fontSize: 20
  );
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('assets/footer.png')).buffer.asUint8List(),
  );
  final headerImage = pw.MemoryImage(
    (await rootBundle.load('assets/header.png')).buffer.asUint8List(),
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
        children: markdownParagraph[0].expand<pw.Widget>((element) {
          if(element == '' || element == ' ') {
            return [pw.Text('\n', style: classicStyle.copyWith(fontSize: 16))]; // Add this line to create a space between paragraphs with increased font size
          }
          else {
            final mdElement = md.Document().parse(element).firstOrNull;
            if(mdElement is md.Element && mdElement.tag == 'h1') {
              print(mdElement.textContent);
              return [_formatMarkdown(mdElement, classicStyle, boldStyle, italicStyle, titleStyle)];
            }
            else if(mdElement is md.Element && mdElement.children != null) {
              return mdElement.children!.map<pw.Widget>((child) {

                return _formatMarkdown(child, classicStyle, boldStyle, italicStyle, titleStyle);
              }).toList();
            }
          }
          return [];
        }).toList(),
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
      return markdownParagraph[1].expand<pw.Widget>((element) {
        if(element == '' || element == ' ') {
            return [pw.Text('\n', style: classicStyle.copyWith(fontSize: 11))]; // Add this line to create a space between paragraphs with increased font size
          }
          else {
            final mdElement = md.Document().parse(element).firstOrNull;
            if(mdElement is md.Element && mdElement.tag == 'h1') {
              print(mdElement.textContent);
              return [_formatMarkdown(mdElement, classicStyle, boldStyle, italicStyle, titleStyle)];
            }
            else if(mdElement is md.Element && mdElement.children != null) {
              return mdElement.children!.map<pw.Widget>((child) {
                return _formatMarkdown(child, classicStyle, boldStyle, italicStyle, titleStyle);
              });
            }
          }
        return [];
      }).toList();
    },
  ),
);

  await File('Contrat/monFichier.pdf').writeAsBytes(await pdf.save());
}

pw.Widget _formatMarkdown(child, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle, pw.TextStyle titleStyle) {

  String mdText = _insertInformation(child.textContent as String);
  if(child is md.Element && child.tag == 'h1') {
    return pw.SizedBox(
    width: double.infinity, // ou une autre valeur pour la largeur
    height: 50, // ou une autre valeur pour la hauteur
    child: pw.Container(
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xff0000ff), // Couleur de fond bleue
        border: pw.Border.all(width: 2.0, color: const PdfColor.fromInt(0xff000000)), // Bordure noire
      ),
      child: pw.Center(
        child: pw.Text(mdText, style: classicStyle),
      ),
    ),
  );
  }

  else if(child is md.Text) {
    return pw.Paragraph(text: mdText, style: classicStyle);
  }
  else if(child is md.Element && child.tag == 'strong') {
    return pw.Paragraph(text: mdText, style: boldStyle);
  }
  else if (child is md.Element && child.tag == 'li') {
    return pw.Bullet(text: mdText, style: classicStyle);
  }
  else if (child is md.Element && child.tag == 'em') {
    return pw.Paragraph(text: mdText, style: italicStyle);
  }
  return pw.Container();
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
