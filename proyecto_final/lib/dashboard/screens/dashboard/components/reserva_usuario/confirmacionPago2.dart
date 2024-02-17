// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class ConfirmacionPago2 extends StatefulWidget {
  // Parametros para recibir los datos de la reserva
  final ReservaModel reserva;
  final ThemeManager themeManager;
  const ConfirmacionPago2(
      {super.key, required this.themeManager, required this.reserva});

  @override
  State<ConfirmacionPago2> createState() => _ConfirmacionPago2State();
}

class _ConfirmacionPago2State extends State<ConfirmacionPago2> {
  @override
  Widget build(BuildContext context) {
    // Verificar el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDark ? bgColor : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Informacion de la reservación',
          style: TextStyle(color: isDark ? primaryColor : Colors.black),
        ),
      ),
      body: LayoutBuilder(builder: (context, responsive) {
        // Valida si el ancho de la pantalla es menor o igual a 900
        if (responsive.maxWidth <= 900) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              // Información de la reserva
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'A continuación, observará la información del sitio al cual usted está ordenando antes de hacer el pago.',
                      style: TextStyle(
                          fontSize: 25,
                          color: isDark ? primaryColor : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nombre del sitio',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? primaryColor : Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.reserva.sitio.titulo,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ubicación',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? primaryColor : Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.reserva.sitio.lugar,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de llegada',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? primaryColor : Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.reserva.fechaEntrada,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de salida',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? primaryColor : Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.reserva.fechaSalida,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Número de huespedes',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? primaryColor : Colors.black),
                  ),
                  Text(
                    "${widget.reserva.numHuespedes} Huesped",
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  const SizedBox(height: 30),
                  const Divider(
                    color: Color(0xFFAD974F),
                  ),
                  Text(
                    'Costo total',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? primaryColor : Colors.black),
                  ),
                  Text(
                    'COP ${valorFormatted(widget.reserva.precioFinal)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  const SizedBox(height: 50),
                  // Codigo qr el cual se puede prestar para integrar un qr completo Bancolombia o Davivienda
                  Center(
                    child: QrImageView(
                      data: 'Codigo qr',
                      version: QrVersions.auto,
                      size: 350.0,
                      foregroundColor: isDark ? primaryColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "En este momento, su reserva se encuentra en estado pendiente. Si desea que se active, por favor, realice el pago a través del código QR anterior en un lapso de 48 horas. Después de esto, cuando su reserva se active, aparecerá el contacto del anfitrión en nuestro chat en línea para ultimar detalles y asegurarse de que pueda disfrutar su estadía.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          );
          // Vista por defecto
        } else {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    // Información de la reserva
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            'A continuación, observará la información del sitio al cual usted está ordenando antes de hacer el pago.',
                            style: TextStyle(
                                fontSize: 25,
                                color: isDark ? primaryColor : Colors.black),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nombre del sitio',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? primaryColor
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.reserva.sitio.titulo,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ubicación',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? primaryColor
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.reserva.sitio.lugar,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de llegada',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? primaryColor
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.reserva.fechaEntrada,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de salida',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? primaryColor
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.reserva.fechaSalida,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Número de huespedes',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? primaryColor : Colors.black),
                        ),
                        Text(
                          "${widget.reserva.numHuespedes} Huesped",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        const SizedBox(height: 30),
                        const Divider(
                          color: Color(0xFFAD974F),
                        ),
                        Text(
                          'Costo total',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? primaryColor : Colors.black),
                        ),
                        Text(
                          'COP ${valorFormatted(widget.reserva.precioFinal)}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Codigo qr el cual se puede prestar para integrar un qr completo Bancolombia o Davivienda
                    Center(
                      child: QrImageView(
                        data: 'Codigo qr',
                        version: QrVersions.auto,
                        size: 350.0,
                        foregroundColor: isDark ? primaryColor : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "En este momento, su reserva se encuentra en estado pendiente. Si desea que se active, por favor, realice el pago a través del código QR anterior en un lapso de 48 horas. Después de esto, cuando su reserva se active, aparecerá el contacto del anfitrión en nuestro chat en línea para ultimar detalles y asegurarse de que pueda disfrutar su estadía.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              )
            ],
          );
        }
      }),
      // Botón para navegar a la pantalla principal
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HomeScreenPage(themeManager: widget.themeManager),
            ),
          );
        },
        child: const Icon(
          Icons.check,
          color: Color(0xFFAD974F),
        ), // Icono del botón flotante
      ),
    );
  }
}

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
String valorFormatted(int valor) {
  return NumberFormat.currency(
    symbol:
        '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
    locale:
        'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
    decimalDigits:
        0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
  ).format(valor); // Aplicar el formato a la variable valor
}
