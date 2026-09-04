import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportService {
  static Future<void> generateRehabReport({
    required String patientName,
    required String mode,
    required double fmaScore,
    required int duration,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Rehabilitation Report",
                style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Patient: $patientName"),
            pw.Text("Mode: $mode"),
            pw.Text("FMA Score: $fmaScore"),
            pw.Text("Session Duration: $duration minutes"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }
}
