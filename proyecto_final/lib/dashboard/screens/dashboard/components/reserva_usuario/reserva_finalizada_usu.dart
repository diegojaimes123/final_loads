// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/pdf/pdf_screen.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

// Tabla de las reservas finalizadas del usuario

class ReservaFinalizadaU extends StatefulWidget {
  // parametro que recibe una lista de reservas
  final List<ReservaModel> reservas;
  const ReservaFinalizadaU({
    Key? key,
    required this.reservas,
  }) : super(key: key);

  @override
  State<ReservaFinalizadaU> createState() => _ReservaFinalizadaUState();
}

class _ReservaFinalizadaUState extends State<ReservaFinalizadaU> {
  @override
  void initState() {
    super.initState();
    for (var x = 0; x < widget.reservas.length; x++) {
      // Verifica si el estado de la reserva es "Activo"
      if (widget.reservas[x].estado == "Activo") {
        // Comprueba si la fecha de salida es el día actual
        if (DateTime.now()
                .difference(DateTime.parse(widget.reservas[x].fechaSalida))
                .inDays ==
            0) {
          // Llama a la función para actualizar la reserva a "Finalizado"
          updateReserva(widget.reservas[x]);
        }
      }
    }
  }

  // Función para actualizar una reserva a "Finalizado"
  updateReserva(ReservaModel reserva) async {
    String url = "";

    // Determina la URL según la plataforma (Android o no Android)
    if (UniversalPlatform.isAndroid) {
      url = "http://10.0.2.2:8000/api/Reservas/";
    } else {
      url = "http://127.0.0.1:8000/api/Reservas/";
    }

    // Encabezados para la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Cuerpo de la solicitud HTTP con los datos actualizados
    final Map<String, dynamic> dataBody = {
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
      "estado": "Finalizado",
      "comision": reserva.comision,
      "gananciaAnfitrion": reserva.gananciaAnfitrion,
      "sitio": reserva.sitio.id,
    };

    // Realiza una solicitud HTTP PUT para actualizar la reserva
    await http.put(
      Uri.parse("$url${reserva.id}/"),
      headers: dataHeader,
      body: json.encode(dataBody),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verifica tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Lista para almacenar las reservas finalizadas
    List<ReservaModel> reservaFinalizada = [];

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
            "Mis Reservas Finalizadas",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FutureBuilder(
              future: getUsuario(), // llama a todos los usuarios
              builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario) {
                // Mientras carga la información
                if (usuario.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Si la información es nula
                if (usuario.data != null) {
                  return FutureBuilder(
                      future: getReservas(), // llama todas las reservas
                      builder:
                          (context, AsyncSnapshot<List<ReservaModel>> reserva) {
                        // Mientras carga la información
                        if (reserva.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        for (var u = 0; u < usuario.data!.length; u++) {
                          // Verifica el usuario logueado
                          if (FirebaseAuth.instance.currentUser!.email ==
                              usuario.data![u].correoElectronico) {
                            for (var r = 0; r < reserva.data!.length; r++) {
                              // Verifica si el usuario tiene reservas finalizadas
                              if (reserva.data![r].usuario ==
                                  usuario.data![u].id) {
                                if (reserva.data![r].estado == "Finalizado") {
                                  reservaFinalizada.add(reserva.data![r]);
                                }
                              }
                            }
                          }
                        }

                        // Tabla
                        return SizedBox(
                          width: double.infinity,
                          height: 300,
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
                              ],
                              // Contenido de la tabla
                              rows: List.generate(
                                reservaFinalizada.length,
                                (index) => ReservaFuDataRow(
                                    reservaFinalizada[index], context),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

DataRow ReservaFuDataRow(ReservaModel reservaFInfo, BuildContext context) {
  // Verifica el tema actual
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/finalizado.svg",
              height: 30,
              width: 30,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(reservaFInfo.sitio.titulo),
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
              if (reservaFInfo.usuario == usuario1.data![v].id) {
                nombreUsuario = usuario1.data![v].nombreCompleto;
              }
            }

            return Text(nombreUsuario);
          })),
      DataCell(Text(reservaFInfo.fecha)),
      DataCell(ElevatedButton(
        onPressed: () {
          // Ver detalles de la reserva
          _modalReserva(context, reservaFInfo);
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor)),
        child: const Text("Ver"),
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
              if (reservaFInfo.usuario == usuario1.data![v].id) {
                nombreCompleto = usuario1.data![v].nombreCompleto;
                telefono = usuario1.data![v].telefono;
                tipodocumento = usuario1.data![v].tipoDocumento;
                numeroDocumento = usuario1.data![v].numeroDocumento;
                estado = reservaFInfo.estado;
                lugar = reservaFInfo.sitio.titulo;
              }
            }
            return IconButton(
                onPressed: () {
                  // Mensaje para el qr del pdf
                  String pedido = "";
                  pedido =
                      "$pedido Usted tiene una reserva finalizada con la siguiente información: \n Nombre del Sitio: ${reservaFInfo.sitio.titulo}\n Ubicación: ${reservaFInfo.sitio.lugar} \n Fecha de Entrada: ${reservaFInfo.fechaEntrada} \n Fecha de Salida: ${reservaFInfo.fechaSalida} \n Total de Huespedes: ${reservaFInfo.numHuespedes} \n Total precio de la estadia: ${reservaFInfo.precioFinalFormatted}";

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
