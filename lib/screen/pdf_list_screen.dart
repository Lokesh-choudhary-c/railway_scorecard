import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<FileSystemEntity> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    loadPdfFiles();
  }

  Future<void> loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().where((file) => file.path.endsWith('.pdf')).toList();
    setState(() {
      pdfFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Saved PDFs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: pdfFiles.isEmpty
          ? const Center(child: Text('No PDFs saved yet'))
          : ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                final file = pdfFiles[index];
                final fileName = file.path.split('/').last;
                return ListTile(
                  title: Text(fileName),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => OpenFile.open(file.path),
                );
              },
            ),
    );
  }
}
