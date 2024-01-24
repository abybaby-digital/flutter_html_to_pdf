import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_html_to_pdf_example/view_pdf.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? generatedPdfFilePath;

  @override
  void initState() {
    super.initState();

    generateExampleDocument();
  }

  Future<String?> getDir() async {
    var dir = await getDownloadsDirectory();
    if (dir != null) {
      String downloadfolder = dir.path;
      log(downloadfolder);
      return downloadfolder;
    } else {
      log("No download folder found.");
    }
  }

  Future<void> generateExampleDocument() async {
    String? htmlContent;

    await getDir();

    dynamic appDocDir =  Platform.isIOS?await  getTemporaryDirectory():await DownloadsPathProvider.downloadsDirectory;
    final targetPath = appDocDir.path;
    final targetFileName = "invoice-26";

    var response = await http
        .get(Uri.parse('https://kv.businessenquiry.co.in/invoice/26'));
    //If the http request is successful the statusCode will be 200
    if (response.statusCode == 200) {
      htmlContent = """${response.body}""";
      print("${response.body.runtimeType}");
      log(htmlContent);
      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          htmlContent, targetPath ?? '', targetFileName);
      generatedPdfFilePath = generatedPdfFile.path;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: ElevatedButton(
                  child: Text("Next"),
                  onPressed: generatedPdfFilePath != null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPDF(
                                        path: generatedPdfFilePath,
                                      )));
                        }
                      : null),
            )));
  }
}
