import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:markdown/markdown.dart' as md;
import 'package:docx_template/docx_template.dart';

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
  final f = File("template.docx");
  final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

  /* 
    Or in the case of Flutter, you can use rootBundle.load, then get bytes
    
    final data = await rootBundle.load('lib/assets/users.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);
  */

  // Load test image for inserting in docx
  final testFileContent = await File('test.jpg').readAsBytes();

  final listNormal = ['Foo', 'Bar', 'Baz'];
  final listBold = ['ooF', 'raB', 'zaB'];

  final contentList = <Content>[];

  final b = listBold.iterator;
  for (var n in listNormal) {
    b.moveNext();

    final c = PlainContent("value")
      ..add(TextContent("normal", n))
      ..add(TextContent("bold", b.current));
    contentList.add(c);
  }

  Content c = Content();
  c
    ..add(TextContent("docname", "Simple docname"))
    ..add(TextContent("passport", "Passport NE0323 4456673"))
    ..add(TableContent("table", [
      RowContent()
        ..add(TextContent("key1", "Paul"))
        ..add(TextContent("key2", "Viberg"))
        ..add(TextContent("key3", "Engineer"))
        ..add(ImageContent('img', testFileContent)),
      RowContent()
        ..add(TextContent("key1", "Alex"))
        ..add(TextContent("key2", "Houser"))
        ..add(TextContent("key3", "CEO & Founder"))
        ..add(ListContent("tablelist", [
          TextContent("value", "Mercedes-Benz C-Class S205"),
          TextContent("value", "Lexus LX 570")
        ]))
        ..add(ImageContent('img', testFileContent))
    ]))
    ..add(ListContent("list", [
      TextContent("value", "Engine")
        ..add(ListContent("listnested", contentList)),
      TextContent("value", "Gearbox"),
      TextContent("value", "Chassis")
    ]))
    ..add(ListContent("plainlist", [
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Paul"))
            ..add(TextContent("key2", "Viberg"))
            ..add(TextContent("key3", "Engineer")),
          RowContent()
            ..add(TextContent("key1", "Alex"))
            ..add(TextContent("key2", "Houser"))
            ..add(TextContent("key3", "CEO & Founder"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Mercedes-Benz C-Class S205"),
              TextContent("value", "Lexus LX 570")
            ]))
        ])),
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Nathan"))
            ..add(TextContent("key2", "Anceaux"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent(
                "tablelist", [TextContent("value", "Peugeot 508")])),
          RowContent()
            ..add(TextContent("key1", "Louis"))
            ..add(TextContent("key2", "Houplain"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Range Rover Velar"),
              TextContent("value", "Lada Vesta SW Sport")
            ]))
        ])),
    ]))
    ..add(ListContent("multilineList", [
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 1')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 2')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 3'))
    ]))
    ..add(TextContent('multilineText2', 'line 1\nline 2\n line 3'))
    ..add(ImageContent('img', testFileContent));

  final d = await docx.generate(c);
  final of = File('generated.docx');
  if (d != null) await of.writeAsBytes(d);
}

// void _createPdfFromMarkdown() async {
//   final pdf = pw.Document();
//   final markdownData = await rootBundle.loadString('assets/document.md');
//   final parsedMarkdown = md.Document().parseLines(markdownData.split('\n'));

//   for (final element in parsedMarkdown) {
//     if (element is md.Text) {
//       pdf.addPage(pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text(element.text, style: pw.TextStyle(fontSize: 40)),
//         ),
//       ));
//     } else if (element is md.UnorderedList) {
//       // Remplacez chaque point de liste par une image
//       final children = <pw.Widget>[];
//       for (final item in element.children) {
//         if (item is md.ListItem) {
//           children.add(pw.Row(
//             children: <pw.Widget>[
//               pw.Image(PdfImageProvider(
//                 pdf.document,
//                 bytes: (await rootBundle.load('assets/bullet_point_image.png')).buffer.asUint8List(),
//               )),
//               pw.Text(item.textContent),
//             ],
//           ));
//         }
//       }
//       pdf.addPage(pw.Page(
//         build: (pw.Context context) => pw.Column(children: children),
//       ));
//     }
//   }

//   final file = File('Contrat/monFichier.pdf');
//   await file.writeAsBytes(await pdf.save());
// }