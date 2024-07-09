import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;

Map<String, String> variablesContrat = {
  'Entreprise': 'TWitter.com',
  'Adresse1': 'Ar;:;!;:!;:ds.+--sq+d-+qsd',
  'adresse2': '12 rue de la Paix',
  'Numero': '12313(12)',
  'Capital': '123125€',
  'Matricule': '123  23-556 546',
  'Montant_HT': '1255€',
  'Montant_TTC': '1000€',
  'Date': '01/01/2022',
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

  // print(markdownData.substring(0, 40));
  final formattedMarkdownData = markdownData.replaceAll(RegExp(r'\r\n\r\n'), '\r\n \r\n');
  print(formattedMarkdownData.split('\n')[0]);
  final parsedMarkdown = md.Document().parseLines(formattedMarkdownData.split('\r\n'));
  print(parsedMarkdown[0].textContent);

  final font = await rootBundle.load("assets/fonts/Metropolis-Regular.ttf");
  final boldFont = await rootBundle.load("assets/fonts/Metropolis-Bold.ttf");
  final italicFont = await rootBundle.load("assets/fonts/Metropolis-RegularItalic.ttf");
  
  
  final classicStyle = pw.TextStyle(font: pw.Font.ttf(font));
  final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldFont));
  final italicStyle = pw.TextStyle(font: pw.Font.ttf(italicFont));

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

int i = 0;
// Ensuite, ajoutez les pages suivantes sans l'image dans l'en-tête
// Générez d'abord la première page avec le thème firstPageTheme
pdf.addPage(
  pw.Page(
    pageTheme: firstPageTheme,
    build: (pw.Context context) {
      return pw.Column(
        children: parsedMarkdown.expand<pw.Widget>((element) {
          if(i < 3) {
              i++;
                print(element.textContent);
            }
          
          if(element is md.Element) {
            if(element.children != null) {
              return element.children!.map<pw.Widget>((child) {
                
                return _formatMarkdown(child, classicStyle, boldStyle, italicStyle);
              });
            }
          }
          else if(element.textContent == '' || element.textContent == '\n' || element.textContent == ' ') {
            return [pw.SizedBox(height: 10)]; // Add this line to create a space between paragraphs
          }
          return [];
        }).toList(),
      );
    },
  ),
);

print('Nombre d\'éléments dans parsedMarkdown: ${parsedMarkdown.length}');

int wordInFirstParagraph = 20;
int skippedWords = 0;

// Ensuite, générez les pages suivantes avec le thème mainPageTheme
pdf.addPage(
  pw.MultiPage(
    pageTheme: mainPageTheme,
    build: (pw.Context context) {
      // Ici, vous pouvez ajouter le contenu des pages suivantes
      // Par exemple, vous pouvez ajouter tous les éléments de parsedMarkdown sauf le premier
      return parsedMarkdown.expand<pw.Widget>((element) {
        if(element is md.Element) {
          if(element.children != null) {
            return element.children!.map<pw.Widget>((child) {
              skippedWords++;
              if(skippedWords < wordInFirstParagraph) {
                return pw.Container();
              }
              return _formatMarkdown(child, classicStyle, boldStyle, italicStyle);
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

pw.Widget _formatMarkdown(child, pw.TextStyle classicStyle, pw.TextStyle boldStyle, pw.TextStyle italicStyle) {

  String mdText = _insertInformation(child.textContent as String);


  if(child is md.Text) {
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
      // print(text);
      // print(variablesContrat[key]);
      return variablesContrat[key]!;
    }
    // Récupérer l'instance de la classe MesVariablesGlobales
      return text; // Add a return statement at the end

  });
}
