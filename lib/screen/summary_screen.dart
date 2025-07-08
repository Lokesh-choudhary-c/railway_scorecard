// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:railway_report/providers/form_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<FormProvider>(context);
    final data = form.getFormData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Before Submission'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Station: ${data['station'] ?? ''}", style: summaryStyle),
            Text("Supervisor: ${data['supervisor'] ?? ''}", style: summaryStyle),
            Text("Train No: ${data['train'] ?? ''}", style: summaryStyle),
            Text("Coach: ${data['coach'] ?? ''}", style: summaryStyle),
            Text("Toilet: ${data['toilet'] ?? ''}", style: summaryStyle),
            Text("Doorway: ${data['doorway'] ?? ''}", style: summaryStyle),
            Text(
              "📅 Date: ${(data['date']?.toString().split('T').first) ?? ''}",
              style: summaryStyle,
            ),
            const SizedBox(height: 20),
            const Text("Parameters:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...form.parameters.map((e) => Card(
                  child: ListTile(
                    title: Text("${e.title} — ${e.score}/10"),
                    subtitle: Text(e.remarks?.isNotEmpty == true ? e.remarks! : "No remarks"),
                  ),
                )),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                final PdfDocument pdf = PdfDocument();
                var page = pdf.pages.add();
                final contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
                double top = 0;

                page.graphics.drawString(
                  'Scorecard Summary',
                  PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
                  bounds: const Rect.fromLTWH(0, 0, 500, 30),
                );

                top += 40;
                List<String> metadata = [
                  "Station: ${data['station'] ?? ''}",
                  "Supervisor: ${data['supervisor'] ?? ''}",
                  "Train No: ${data['train'] ?? ''}",
                  "Coach: ${data['coach'] ?? ''}",
                  "Toilet: ${data['toilet'] ?? ''}",
                  "Doorway: ${data['doorway'] ?? ''}",
                  "Date: ${(data['date']?.toString().split('T').first) ?? ''}",
                ];

                for (final line in metadata) {
                  page.graphics.drawString(line, contentFont, bounds: Rect.fromLTWH(0, top, 500, 20));
                  top += 20;
                }

                top += 10;
                page.graphics.drawString("Parameters:", contentFont, bounds: Rect.fromLTWH(0, top, 500, 20));
                top += 25;

                for (var p in form.parameters) {
                  if (top > 700) {
                    page = pdf.pages.add();
                    top = 20;
                  }
                  page.graphics.drawString("${p.title}: ${p.score}/10", contentFont,
                      bounds: Rect.fromLTWH(0, top, 500, 20));
                  top += 20;

                  if (p.remarks != null && p.remarks!.isNotEmpty) {
                    page.graphics.drawString("Remarks: ${p.remarks}", contentFont,
                        bounds: Rect.fromLTWH(10, top, 480, 20));
                    top += 20;
                  }
                }

                final bytes = await pdf.save();
                final dir = await getApplicationDocumentsDirectory();
                final station = (data['station'] ?? 'station').toString().replaceAll(' ', '_');
                String rawDate = data['date'] ?? '';
                String dateOnly = rawDate.contains('T') ? rawDate.split('T').first : rawDate;

                final file = File('${dir.path}/${station}_${dateOnly}_scorecard.pdf');
                await file.writeAsBytes(bytes, flush: true);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ PDF saved at: ${file.path}')),
                );
                final Map<String, dynamic> submissionData = {
                  'station': data['station'],
                  'supervisor': data['supervisor'],
                  'train': data['train'],
                  'coach': data['coach'],
                  'toilet': data['toilet'],
                  'doorway': data['doorway'],
                  'date': data['date'],
                  'parameters': form.parameters
                      .map((e) => {
                            'title': e.title,
                            'score': e.score,
                            'remarks': e.remarks,
                          })
                      .toList(),
                };

                final response = await http.post(
                  Uri.parse('https://webhook.site/0565a1cc-9af7-49b1-adf9-01da1493adc6'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(submissionData),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Submitted to Webhook')),
                  );
                  form.clearForm();
                  Navigator.popUntil(context, (r) => r.isFirst);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Submission failed: ${response.statusCode}')),
                  );
                }
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Save as PDF & Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                form.clearForm();
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel & Clear"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle get summaryStyle => const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
