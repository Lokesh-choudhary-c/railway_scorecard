import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:railway_report/models/parameter_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';


class PDFGenerator {
  static Future<File> generatePDF({
    required String station,
    required String supervisor,
    required String date,
    required List<ParameterModel> parameters,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();

    final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    page.graphics.drawString('Station Inspection Scorecard',
        titleFont, bounds: const Rect.fromLTWH(0, 0, 500, 40));

    page.graphics.drawString('📍 Station: $station', contentFont,
        bounds: const Rect.fromLTWH(0, 40, 500, 20));
    page.graphics.drawString('👨‍💼 Supervisor: $supervisor', contentFont,
        bounds: const Rect.fromLTWH(0, 60, 500, 20));
    page.graphics.drawString('📅 Date: $date', contentFont,
        bounds: const Rect.fromLTWH(0, 80, 500, 20));

    double top = 110;
    for (int i = 0; i < parameters.length; i++) {
      final p = parameters[i];
      page.graphics.drawString(
          '${i + 1}. ${p.title}\n   Score: ${p.score}\n   Remarks: ${p.remarks ?? "-"}',
          contentFont,
          bounds: Rect.fromLTWH(0, top, 500, 60));
      top += 65;
    }

    final bytes = await document.save();
    document.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Scorecard_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}
