// Importaciones necesarias para Flutter.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:proyecto_final/pdf/url_text.dart'; // Asegúrate de tener esta importación correcta.
import 'package:proyecto_final/theme/theme_constants.dart';
import 'menu.dart';

// Clase PdfPageScreen que extiende StatefulWidget para la generación de PDF.
// ignore: must_be_immutable
class PdfPageScreen extends StatefulWidget {
  // Parámetros requeridos para la construcción del widget.
  String reserva;
  String nombreCompleto;
  String telefono;
  String tipodocumento;
  String numeroDocumento;
  String estado;
  String lugar;

  // Constructor que recibe los parámetros necesarios.
  PdfPageScreen(
      {Key? key,
      required this.reserva,
      required this.nombreCompleto,
      required this.telefono,
      required this.tipodocumento,
      required this.numeroDocumento,
      required this.estado,
      required this.lugar})
      : super(key: key);

  // Método que crea el estado para el widget.
  @override
  // ignore: no_logic_in_create_state
  State<PdfPageScreen> createState() => _PdfPageScreenState(
      // Pasamos los parámetros al estado.
      reserva: reserva,
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      tipodocumento: tipodocumento,
      numeroDocumento: numeroDocumento,
      estado: estado,
      lugar: lugar);
}

// Estado privado para PdfPageScreen.
class _PdfPageScreenState extends State<PdfPageScreen> {
  // Variables para almacenar los datos de la reserva.
  String reserva;
  String nombreCompleto;
  String telefono;
  String tipodocumento;
  String numeroDocumento;
  String estado;
  String lugar;
  // Constructor para inicializar las variables con los datos de la reserva.
  _PdfPageScreenState(
      {required this.reserva,
      required this.nombreCompleto,
      required this.telefono,
      required this.tipodocumento,
      required this.numeroDocumento,
      required this.estado,
      required this.lugar});

  PrintingInfo? printingInfo;

  // Método para inicializar el estado.
  @override
  void initState() {
    super.initState();
    _init();
  }

  // Método para obtener información de impresión.
  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  // Método para construir y mostrar la pantalla PDF.
  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(
          icon: Icon(
            Icons.save,
            color: primaryColor,
          ),
          onPressed: saveAsFile,
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factura StayAway'),
        backgroundColor: primaryColor,
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }

  // Método para generar el contenido del PDF.
  Future<Uint8List> generatePdf(final PdfPageFormat format) async {
    final doc = pw.Document(
      title: 'StayAway',
    );

    // Carga de la imagen del logo desde los recursos.
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());
    // Agrega una página al documento PDF.
    doc.addPage(
      pw.MultiPage(
        // Configuración del encabezado de la página.
        header: (final context) => pw.Image(
          alignment: pw.Alignment.topLeft,
          logoImage,
          fit: pw.BoxFit.contain,
          width: 70,
        ),
        // Construcción del contenido de la página.
        build: (final context) => [
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Padding(padding: const pw.EdgeInsets.only(top: 60)),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Nombre del sitio:  $lugar',
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text('Nombre del cliente: $nombreCompleto',
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text('Telefono: $telefono',
                              style: const pw.TextStyle(fontSize: 13)),
                          pw.Text('Documento: $tipodocumento $numeroDocumento',
                              style: const pw.TextStyle(fontSize: 13)),
                          // pw.Text('Estado de la reserva: ${estado}',
                          //     style: pw.TextStyle(fontSize: 13)),
                        ]),
                    pw.SizedBox(width: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Informacion de STAYAWAY',
                            style: const pw.TextStyle(fontSize: 13)),
                        UrlText('STAYAWAY', 'telefono: 888-888-444',
                            style: const TextStyle(
                                fontSize: 13, color: primaryColor)),
                        UrlText('stayaway8455@gmail.com', 'STAYAWAY',
                            style: const TextStyle(
                                fontSize: 13, color: primaryColor)),
                      ],
                    ),
                    pw.SizedBox(width: 40),
                    pw.Padding(padding: pw.EdgeInsets.zero),
                  ],
                ),
              ],
            ),
          ),
          pw.Center(
            child: pw.Text(
              'Informacion de tu reserva',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 40, left: 140),
            child: pw.BarcodeWidget(
              data: reserva,
              width: 210,
              height: 210,
              barcode: pw.Barcode.qrCode(),
              drawText: false,
            ),
          ),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 165, top: 60),
                  child: pw.Text(
                    '¡STAYAWAY!',
                    style: pw.TextStyle(
                        fontSize: 25, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ]),
        ],
      ),
    );
    // Guarda el documento y retorna los datos del PDF.
    return doc.save();
  }
}
