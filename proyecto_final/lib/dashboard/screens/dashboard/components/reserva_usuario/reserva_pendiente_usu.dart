// ignore_for_file: use_full_hex_values_for_flutter_colors, non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/confirmacionPago2.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/pdf/pdf_screen.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

// Tabla de las reservas pendientes del usuario

class ReservaPendienteU extends StatefulWidget {
  // parametro que recibe una lista de reservas
  final ThemeManager themeManager;
  final List<ReservaModel> reservas;
  const ReservaPendienteU({
    Key? key,
    required this.themeManager,
    required this.reservas,
  }) : super(key: key);

  @override
  State<ReservaPendienteU> createState() => _ReservaPendienteUState();
}

class _ReservaPendienteUState extends State<ReservaPendienteU> {
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
      url = "http://10.0.2.2:8000/api/Reservas/";
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
            "Mis Reservas Pendientes",
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
                              // Verifica si el usuario tiene reservas pendientes
                              if (reserva.data![r].usuario ==
                                  usuario.data![u].id) {
                                if (reserva.data![r].estado == "Pendiente") {
                                  reservaPendiente.add(reserva.data![r]);
                                }
                              }
                            }
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
                                (index) => ReservaAuDataRow(
                                    reservaPendiente[index],
                                    context,
                                    widget.themeManager),
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

DataRow ReservaAuDataRow(ReservaModel reservaPInfo, BuildContext context,
    ThemeManager themeManager) {
  // Verifica el tema actual
  bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          // Navegación para poder volver a ver el qr para realizar el pago de la reserva
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmacionPago2(
                      reserva: reservaPInfo,
                      themeManager: themeManager,
                    )),
          );
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(primaryColor)),
        child: const Text("Pagar"),
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
                      "$pedido Usted tiene una reserva pendiente con la siguiente información: \n Nombre del Sitio: ${reservaPInfo.sitio.titulo}\n Ubicación: ${reservaPInfo.sitio.lugar} \n Fecha de Entrada: ${reservaPInfo.fechaEntrada} \n Fecha de Salida: ${reservaPInfo.fechaSalida} \n Total de Huespedes: ${reservaPInfo.numHuespedes} \n Total precio de la estadia: ${reservaPInfo.precioFinalFormatted}";

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
                // Botón "Eliminar"
                ElevatedButton(
                    onPressed: () async {
                      String url = "";

                      // Determina la URL según la plataforma (Android o no Android)
                      if (UniversalPlatform.isAndroid) {
                        url = "http://10.0.2.2:8000/api/Reservas/";
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
