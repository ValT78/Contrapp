import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;

// import 'package:markdown/markdown.dart' show UnorderedList;

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

  final font = await rootBundle.load("assets/fonts/Metropolis-Regular.ttf");
  final boldFont = await rootBundle.load("assets/fonts/Metropolis-Bold.ttf");
  
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(font),
    bold: pw.Font.ttf(boldFont),
    italic: pw.Font.ttf(await rootBundle.load("assets/fonts/Metropolis-RegularItalic.ttf")),

  );

  final pdf = pw.Document(theme: theme);
  final markdownData = await rootBundle.loadString('assets/template.md');
  final parsedMarkdown = md.Document().parseLines(markdownData.split('\n'));


  // for (final element in parsedMarkdown) {
  //   if (element is md.Element) {
  //     if (element.children != null) {
  //       for (final child in element.children!) {
  //         if (child is md.Text) {
  //           print(child.text); // Print the text here
  //         }
  //       }
  //     }
  //   }
  // }

  final style = pw.TextStyle(font: pw.Font.ttf(font));
  final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldFont));

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
        children: parsedMarkdown.expand<pw.Widget>((element) {
          if(element is md.Element) {
            if(element.children != null) {
              return element.children!.map<pw.Widget>((child) {
                if(child is md.Text) {
                  return pw.Paragraph(text: child.text, style: style);
                }
                else if(child is md.Element && child.tag == 'strong') {
                  return pw.Paragraph(text: child.textContent, style: boldStyle);
                }
                return pw.Container();
              });
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
      return parsedMarkdown.skip(1).expand<pw.Widget>((element) {
        if(element is md.Element) {
          if(element.children != null) {
            return element.children!.map<pw.Widget>((child) {
              if(child is md.Text) {
                return pw.Paragraph(text: child.text, style: style);
              }
              else if(child is md.Element && child.tag == 'strong') {
                return pw.Paragraph(text: child.textContent, style: boldStyle);
              }
              return pw.Container();
            });
          }
        }
        return [];
      }).toList();
    },
  ),
);


  // pdf.addPage(
  //   pw.Page(
  //     build: (pw.Context context) => pw.Column(
  //       children: <pw.Widget>[
  //         pw.Image(yourImage),  // Remplacez `yourImage` par votre image
  //         pw.Text(htmlData, style: pw.TextStyle(fontSize: 40)),
  //         pw.Footer(
  //           child: pw.Image(yourFooterImage),  // Remplacez `yourFooterImage` par votre image de pied de page
  //         ),
  //       ],
  //     ),
  //   ),
  // );

  await File('Contrat/monFichier.pdf').writeAsBytes(await pdf.save());
}