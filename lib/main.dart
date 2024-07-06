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
  final pdf = pw.Document();
  final markdownData = await rootBundle.loadString('assets/template.md');
final parsedMarkdown = md.Document().parseLines(markdownData.split(RegExp(r'\n(?!\n)')));
  // final ttf = pw.Font.ttf(font);

  // final style = pw.TextStyle(font: ttf);

  for (final element in parsedMarkdown) {
    if (element is md.Element) {
      if (element.children != null) {
        for (final child in element.children!) {
          if (child is md.Text) {
            print(child.text); // Print the text here
          }
        }
      }
    }
  }
  final font = await rootBundle.load("fonts/Metropolis-Regular.ttf");
  final boldFont = await rootBundle.load("fonts/Metropolis-Bold.ttf");
  final style = pw.TextStyle(font: pw.Font.ttf(font));
  final boldStyle = pw.TextStyle(font: pw.Font.ttf(boldFont));

//   pdf.addPage(
//   pw.MultiPage(
//     build: (pw.Context context) => parsedMarkdown.expand<pw.Widget>((element) {
//       if(element is md.Element) {
//         if(element.children != null) {
//           return element.children!.map<pw.Widget>((child) {
//             if(child is md.Text) {
//               if (element.tag == 'strong') {  // Si l'élément est en gras dans le markdown
//                 print(child.text);  // Imprimez le texte ici

//                 return pw.Paragraph(text: child.text, style: boldStyle);
//               }
//               return pw.Paragraph(text: child.text, style: style);
//             }
//             return pw.Container();
//           });
//         }
//       }
//       return [];
//     }).toList(),
//   ),
// );


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

  final file = File('Contrat/monFichier.pdf');
  await file.writeAsBytes(await pdf.save());
}