// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/pdf/pdf_screen.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../../models/ip/local.dart';

// Tabla de las reservas pendientes

class ReservaPendienteT extends StatefulWidget {
  // parametro que recibe una lista de reservas
  final ThemeManager themeManager;
  final List<ReservaModel> reservas;

  const ReservaPendienteT({
    Key? key,
    required this.themeManager,
    required this.reservas,
  }) : super(key: key);

  @override
  State<ReservaPendienteT> createState() => _ReservaPendienteTState();
}

class _ReservaPendienteTState extends State<ReservaPendienteT> {
  @override
  void initState() {
    super.initState();
    for (var x = 0; x < widget.reservas.length; x++) {
      // Verifica si el estado de la reserva es "Pendiente"
      if (widget.reservas[x].estado == "Pendiente") {
        // Comprueba si han pasado al menos 2 días desde la fecha de la reserva
        if (DateTime.now()
                .difference(DateTime.parse(widget.reservas[x].fecha))
                .inDays >=
            2) {
          // Llama a la función para eliminar la reserva
          eliminarReserva(widget.reservas[x]);
        }
      }
    }
  }

  // Función para eliminar una reserva
  eliminarReserva(ReservaModel reserva) async {
    String url = "";

    // Determina la URL según la plataforma (Android o no Android)
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Reservas/";
    } else {
      url = "http://127.0.0.1:8000/api/Reservas/";
    }

    // Realiza una solicitud HTTP DELETE para eliminar la reserva
    await http.delete(Uri.parse("$url${reserva.id}/"));
  }

  @override
  Widget build(BuildContext context) {
    // Verifica tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Lista para almacenar las reservas pendientes
    List<ReservaModel> reservaPendiente = [];

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Todas las reservas pendientes",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FutureBuilder(
              future: getReservas(), // llama todas las reservas
              builder: (context, AsyncSnapshot<List<ReservaModel>> reserva) {
                // Mientras carga la información
                if (reserva.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Si la información es nula
                if (reserva.data != null) {
                  // Verifica las reservas pendientes
                  for (var r = 0; r < reserva.data!.length; r++) {
                    if (reserva.data![r].estado == "Pendiente") {
                      reservaPendiente.add(reserva.data![r]);
                    }
                  }

                  // Tabla
                  return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: InteractiveViewer(
                      scaleEnabled: false,
                      constrained: false,
                      child: DataTable(
                        columnSpacing: defaultPadding,
                        // minWidth: 600,
                        columns: const [
                          DataColumn(
                            label: Text("Sitio"),
                          ),
                          DataColumn(
                            label: Text("Usuario"),
                          ),
                          DataColumn(
                            label: Text("Fecha"),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                        ],
                        // Contenido de la tabla
                        rows: List.generate(
                          reservaPendiente.length,
                          (index) => ReservaAuDataRow(reservaPendiente[index],
                              context, widget.themeManager),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

DataRow ReservaAuDataRow(ReservaModel reservaPInfo, BuildContext context,
    ThemeManager themeManager) {
  // Verifica el tema actual
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  // Método para activar una reserva
  activarReserva(ReservaModel reserva, ThemeManager themeManager) async {
    // URLs para las diferentes peticiones HTTP
    String url = "";

    String url2 = "";

    String url3 = "";

    // Construir las URLs según la plataforma
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Pagos/";
    } else {
      url = "http://127.0.0.1:8000/api/Pagos/";
    }

    if (UniversalPlatform.isAndroid) {
      url2 = "http://$ip_ideapat:8000/api/PagoAnfitrion/";
    } else {
      url2 = "http://127.0.0.1:8000/api/PagoAnfitrion/";
    }

    if (UniversalPlatform.isAndroid) {
      url3 = "http://$ip_ideapat:8000/api/Reservas/";
    } else {
      url3 = "http://127.0.0.1:8000/api/Reservas/";
    }

    // Encabezados comunes para las solicitudes HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Datos del cuerpo para la primera solicitud de pago
    final Map<String, dynamic> dataBody = {
      "fechaPago":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "medioPago": "Transferencia",
      "estado": "Cancelado",
      "reserva": reserva.id,
    };

    // Encabezados comunes para las solicitudes HTTP
    final Map<String, String> dataHeader2 = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Datos del cuerpo para la segunda solicitud de pago al anfitrión
    final Map<String, dynamic> dataBody2 = {
      "fechaRadicado":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "fechaPago": null,
      "medioPago": "Transferencia",
      "estado": "Pendiente",
      "reserva": reserva.id,
    };

    // Encabezados comunes para las solicitudes HTTP
    final Map<String, String> dataHeader3 = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Datos del cuerpo para actualizar la reserva
    final Map<String, dynamic> dataBody3 = {
      "usuario": reserva.usuario,
      "fecha": reserva.fecha,
      "fechaEntrada": reserva.fechaEntrada,
      "fechaSalida": reserva.fechaSalida,
      "numHuespedes": reserva.numHuespedes,
      "numAdultos": reserva.numAdultos,
      "numNinos": reserva.numNinos,
      "numBebes": reserva.numBebes,
      "numMascotas": reserva.numMascotas,
      "precioFinal": reserva.precioFinal,
      "estado": "Activo",
      "comision": reserva.comision,
      "gananciaAnfitrion": reserva.gananciaAnfitrion,
      "sitio": reserva.sitio.id,
    };

    // Realizar la primera solicitud de pago
    var respuesta = await http.post(
      Uri.parse(url),
      headers: dataHeader,
      body: json.encode(dataBody),
    );

    // Realizar la segunda solicitud de pago al anfitrión
    var respuesta2 = await http.post(
      Uri.parse(url2),
      headers: dataHeader2,
      body: json.encode(dataBody2),
    );

    // Actualizar la reserva
    var respuesta3 = await http.put(
      Uri.parse("$url3${reserva.id}/"),
      headers: dataHeader3,
      body: json.encode(dataBody3),
    );

    // Verificar si todas las solicitudes fueron exitosas
    if (respuesta.statusCode == 201 &&
        respuesta2.statusCode == 201 &&
        respuesta3.statusCode == 200) {
      // Navegar a la pantalla principal después de activar la reserva
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreenPage(
            themeManager: themeManager,
          ),
        ),
      );
    }
  }

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/pendiente.svg",
              height: 30,
              width: 30,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(reservaPInfo.sitio.titulo),
            ),
          ],
        ),
      ),
      DataCell(FutureBuilder(
          future: getUsuario(), // llama a todos los usuarios
          builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario1) {
            // Mientras carga la información
            if (usuario1.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Variable para almacenar el nombre del usuario
            String nombreUsuario = "";

            // trae la información del usuario si el id este coincide con el que esta registrado en la reserva
            for (var v = 0; v < usuario1.data!.length; v++) {
              if (reservaPInfo.usuario == usuario1.data![v].id) {
                nombreUsuario = usuario1.data![v].nombreCompleto;
              }
            }

            return Text(nombreUsuario);
          })),
      DataCell(Text(reservaPInfo.fecha)),
      DataCell(ElevatedButton(
        onPressed: () {
          // Ver detalles de la reserva
          _modalReserva(context, reservaPInfo);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor)),
        child: const Text("Ver"),
      )),
      DataCell(ElevatedButton(
        onPressed: () {
          // Función para activar la reserva
          activarReserva(reservaPInfo, themeManager);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor)),
        child: const Text("Activar"),
      )),
      DataCell(ElevatedButton(
        onPressed: () {
          // modal para borrar manualmente la reserva
          _modalBorrarReserva(context, reservaPInfo, themeManager);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor)),
        child: const Text("Eliminar"),
      )),
      DataCell(FutureBuilder(
          future: getUsuario(), // llama a todos los usuarios
          builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario1) {
            // Mientras carga la información
            if (usuario1.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Variables para almacenar la información del usuario
            String nombreCompleto = "";
            String telefono = "";
            String tipodocumento = "";
            String numeroDocumento = "";
            String estado = "";
            String lugar = "";

            // Traer la información del usuario, cuando el id que esta registrado en la reserva coincide con el id de alguno de los usuarios registrados
            for (var v = 0; v < usuario1.data!.length; v++) {
              if (reservaPInfo.usuario == usuario1.data![v].id) {
                nombreCompleto = usuario1.data![v].nombreCompleto;
                telefono = usuario1.data![v].telefono;
                tipodocumento = usuario1.data![v].tipoDocumento;
                numeroDocumento = usuario1.data![v].numeroDocumento;
                estado = reservaPInfo.estado;
                lugar = reservaPInfo.sitio.titulo;
              }
            }
            return IconButton(
                onPressed: () {
                  // Mensaje para el qr del pdf
                  String pedido = "";
                  pedido =
                      "$pedido Usted tiene una reserva finalizada con la siguiente información: \n Nombre del Sitio: ${reservaPInfo.sitio.titulo}\n Ubicación: ${reservaPInfo.sitio.lugar} \n Fecha de Entrada: ${reservaPInfo.fechaEntrada} \n Fecha de Salida: ${reservaPInfo.fechaSalida} \n Total de Huespedes: ${reservaPInfo.numHuespedes} \n Total precio de la estadia: ${reservaPInfo.precioFinalFormatted}";

                  // Navegación que dirige al archivo pdf
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfPageScreen(
                            reserva: pedido,
                            nombreCompleto: nombreCompleto,
                            telefono: telefono,
                            tipodocumento: tipodocumento,
                            numeroDocumento: numeroDocumento,
                            estado: estado,
                            lugar: lugar,
                          )));
                },
                icon: SvgPicture.asset(
                  "assets/icons/pdf.svg",
                  color: isDark ? Colors.white : primaryColor,
                  width: 20,
                  height: 20,
                ));
          })),
    ],
  );
}

// modal para ver los detalles de la reserva
void _modalReserva(BuildContext context, ReservaModel reserva) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 600,
            width: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Image.network(
                  "assets/images/logo.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // detalles de la reserva
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: SizedBox(
                      height: 495,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        // Dependiendo el ancho de la pantalla se definen el número de columnas
                        crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sitio",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.sitio.titulo,
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Nombre Completo",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                FutureBuilder(
                                    future:
                                        getUsuario(), // llama a todos los usuario
                                    builder: (context,
                                        AsyncSnapshot<List<UsuariosModel>>
                                            usuario) {
                                      // Mientras carga la información
                                      if (usuario.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      // Variable para almacenar el nombre del usuario
                                      String nombreUsuario = "";

                                      // trae la información del usuario si el id este coincide con el que esta registrado en la reserva
                                      for (var v = 0;
                                          v < usuario.data!.length;
                                          v++) {
                                        if (reserva.usuario ==
                                            usuario.data![v].id) {
                                          nombreUsuario =
                                              usuario.data![v].nombreCompleto;
                                        }
                                      }
                                      return Text(
                                        nombreUsuario,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      );
                                    }),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fecha de la reserva",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.fecha,
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fecha Llegada",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.fechaEntrada,
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fecha Salida",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.fechaSalida,
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Número de Huespedes",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.numHuespedes.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Número de Adultos",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.numAdultos.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Número de Niños",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.numNinos.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Número de Bebes",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.numBebes.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Número de Mascotas",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  reserva.numMascotas.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Valor Reserva",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  "\$ ${reserva.precioFinalFormatted} COP",
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // acciones del modal
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar"))
              ],
            )
          ],
        );
      });
}

// Modal para borrar la reserva
void _modalBorrarReserva(
    BuildContext context, ReservaModel reserva, ThemeManager themeManager) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "¿Quiere eliminar esta reserva?",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 250,
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Center(
                    child: Text(
                      "Si elimina esta reserva no hay marcha atras. ¿Esta seguro de hacer esta operación?",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                  )
                ],
              ),
            ),
          ),
          actions: [
            // acciones del modal
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                ElevatedButton(
                    onPressed: () async {
                      String url = "";

                      // Determina la URL según la plataforma (Android o no Android)
                      if (UniversalPlatform.isAndroid) {
                        url = "http://$ip_ideapat:8000/api/Reservas/";
                      } else {
                        url = "http://127.0.0.1:8000/api/Reservas/";
                      }

                      // Realiza una solicitud HTTP DELETE para eliminar la reserva
                      final response =
                          await http.delete(Uri.parse("$url${reserva.id}/"));

                      // Verifica si la eliminación fue exitosa (código de estado 204)
                      if (response.statusCode == 204) {
                        // Navega a la pantalla de inicio después de eliminar la reserva
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HomeScreenPage(
                              themeManager: themeManager,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Eliminar")),
              ],
            ),
          ],
        );
      });
}
