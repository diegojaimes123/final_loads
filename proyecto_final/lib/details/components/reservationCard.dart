// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final/LoginUsuario/Login/LoginAndRegister.dart';
import 'package:proyecto_final/details/components/countHuesped.dart';
import 'package:proyecto_final/identificacionReserva/Identificaci%C3%B3nWeb.dart';
import 'package:proyecto_final/identificacionReserva/reconocimiento_facial.dart';
import 'package:proyecto_final/models/ImagenModel.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_final/models/ComentarioModel.dart';
import 'package:universal_platform/universal_platform.dart';

class ReservationCard extends StatefulWidget {
  // parametros para almacenar el sitio y la lista de usuarios
  final SitioModel sitio;
  final ThemeManager themeManager;
  final List<UsuariosModel> usuario;

  const ReservationCard(
      {super.key,
      required this.sitio,
      required this.themeManager,
      required this.usuario});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  // Variables DateTime para poder generar la disponibilidad en el sitio a reservar
  DateTime fechaEntrada = DateTime.now();
  DateTime fechaSalida = DateTime.now();

  DateTime today1 = DateTime.now();

  DateTime today2 = DateTime.now();

  // Controladores de texto para poder realizar la reserva

  late TextEditingController fechaEntradaController = TextEditingController(
      text:
          "${fechaEntrada.year}-${fechaEntrada.month.toString().padLeft(2, '0')}-${fechaEntrada.day.toString().padLeft(2, '0')}");

  late TextEditingController fechaSalidaController = TextEditingController(
      text:
          "${fechaSalida.year}-${fechaSalida.month.toString().padLeft(2, '0')}-${fechaSalida.day.toString().padLeft(2, '0')}");

  TextEditingController numAdultosController = TextEditingController(text: "1");

  TextEditingController numNinosController = TextEditingController();

  TextEditingController numBebesController = TextEditingController();

  TextEditingController numMascotasController = TextEditingController();

  TextEditingController total = TextEditingController(text: "0");

  // Listas para almacenar reservas que hay en el servidor
  List<ReservaModel> reservaActivaE = [];

  List<ReservaModel> reservaActivaS = [];

  List<ReservaModel> reservaActivaR = [];

  // Función para seleccionar la fecha de entrada
  void _onDaySelectedEntrada(DateTime day1, DateTime focusedDay) {
    setState(() {
      today1 = day1;
      fechaEntradaController.text =
          "${day1.year}-${day1.month.toString().padLeft(2, '0')}-${day1.day.toString().padLeft(2, '0')}";
    });
  }

  // Función para seleccionar la fecha de la salida
  void _onDaySelectedSalida(DateTime day2, DateTime focusedDay) {
    setState(() {
      today2 = day2;
      fechaSalidaController.text =
          "${day2.year}-${day2.month.toString().padLeft(2, '0')}-${day2.day.toString().padLeft(2, '0')}";
    });
  }

  // Función para bloquear las fechas anteriores al dia de hoy calendario entrada
  bool _isDayDisabled1(DateTime day1) {
    return day1.isAfter(DateTime.now());
  }

  // Función para bloquear las fechas anteriores al dia de hoy calendario salida
  bool _isDayDisabled2(DateTime day2) {
    return day2.isAfter(DateTime.now());
  }

  // Calendario Entrada
  bool _isDayInRangeE(DateTime day) {
    // Verifica si el día está en el rango de reservas activas
    return reservaActivaE.any((reserva) =>
        day.isAfter(DateTime.parse(reserva.fechaEntrada)
            .subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.parse(reserva.fechaSalida)));
  }

  // Calendario Salida
  bool _isDayInRangeS(DateTime day) {
    // Verifica si el día está en el rango de reservas activas
    return reservaActivaS.any((reserva) =>
        day.isAfter(DateTime.parse(reserva.fechaEntrada)
            .subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.parse(reserva.fechaSalida)));
  }

  // Limpiar recursos
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carta para poder realizar la reserva
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "\$ ${widget.sitio.valorNocheFormatted} COP noche",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    // Campo Fecha Entrada
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          bottom: 10,
                          top: 10,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                            ),
                            border: Border(
                                top: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                bottom: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                right: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                left: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Llegada"),
                            Text(fechaEntradaController.text)
                          ],
                        ),
                      ),
                    ),
                    // Campo fecha salida
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          bottom: 10,
                          top: 10,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                            border: Border(
                                top: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                bottom: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                right: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey),
                                left: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Salida"),
                            Text(fechaSalidaController.text)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // Campo para contabilizar total de los huespedes
                CountHuesped(
                  numAdultosController: numAdultosController,
                  numNinosController: numNinosController,
                  numBebesController: numBebesController,
                  numMascotasController: numMascotasController,
                  total: total,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                FutureBuilder(
                    future: getReservas(), // Traer las reservas en el servidor
                    builder:
                        (context, AsyncSnapshot<List<ReservaModel>> reservaR) {
                      // Mientras trae la información
                      if (reservaR.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Mirar si hay reservas activas relacionadas al sitio en cuestión
                      for (var r = 0; r < reservaR.data!.length; r++) {
                        if (widget.sitio.id == reservaR.data![r].sitio.id) {
                          if (reservaR.data![r].estado == "Activo") {
                            reservaActivaR.add(reservaR.data![r]);
                          }
                        }
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Verifica si el usuario esta logueado
                                if (FirebaseAuth.instance.currentUser != null) {
                                  // Traer el id del usuario que va a hacer la reserva
                                  int usuario = 0;

                                  for (var u = 0;
                                      u < widget.usuario.length;
                                      u++) {
                                    if (FirebaseAuth
                                            .instance.currentUser!.email ==
                                        widget.usuario[u].correoElectronico) {
                                      usuario = widget.usuario[u].id;
                                    }
                                  }

                                  // Mirar si la fecha seleccionada es diferente al rango de fechas de las reservas activas que hay en el sitio inclusive si los dias seleccionados estan entre la fecha de entrada y salida o se sobrepone
                                  bool fechasDiferentes = true;

                                  for (int r = 0;
                                      r < reservaActivaR.length;
                                      r++) {
                                    if ((DateTime.parse(fechaEntradaController.text).isBeforeOrEqual(DateTime.parse(reservaActivaR[r].fechaEntrada)) && DateTime.parse(fechaSalidaController.text).isAfterOrEqual(DateTime.parse(reservaActivaR[r].fechaSalida))) ||
                                        (DateTime.parse(fechaEntradaController.text).isAfterOrEqual(DateTime.parse(reservaActivaR[r].fechaEntrada)) &&
                                            DateTime.parse(fechaSalidaController.text)
                                                .isBeforeOrEqual(DateTime.parse(
                                                    reservaActivaR[r]
                                                        .fechaSalida))) ||
                                        (DateTime.parse(fechaEntradaController.text).isBeforeOrEqual(DateTime.parse(reservaActivaR[r].fechaEntrada)) &&
                                            DateTime.parse(fechaSalidaController.text)
                                                .isAfterOrEqual(DateTime.parse(
                                                    reservaActivaR[r]
                                                        .fechaEntrada))) ||
                                        (DateTime.parse(fechaEntradaController.text).isBeforeOrEqual(DateTime.parse(reservaActivaR[r].fechaSalida)) &&
                                            DateTime.parse(fechaSalidaController.text)
                                                .isAfterOrEqual(DateTime.parse(reservaActivaR[r].fechaSalida)))) {
                                      // Al menos una de las fechas coincide, entonces fechasDiferentes se establece a false
                                      fechasDiferentes = false;
                                      break; // No es necesario seguir verificando, ya que al menos una fecha coincide
                                    }
                                  }

                                  // valida si fechas diferentes es verdadero
                                  if (fechasDiferentes) {
                                    // Verifica si el número de dias de reservación es mayor a 0
                                    if (restaDias(
                                            DateTime.parse(
                                                fechaEntradaController.text),
                                            DateTime.parse(
                                                fechaSalidaController.text)) !=
                                        0) {
                                      // verifica si el total de huespedes es mayor a 0
                                      if (total.text != "0") {
                                        // Modal para confirmar la reserva
                                        showConfirmarReserva(
                                            context,
                                            widget.sitio,
                                            fechaEntradaController.text,
                                            fechaSalidaController.text,
                                            total.text,
                                            calculoDias(
                                                widget.sitio.valorNoche,
                                                restaDias(
                                                    DateTime.parse(
                                                        fechaEntradaController
                                                            .text),
                                                    DateTime.parse(
                                                        fechaSalidaController
                                                            .text))),
                                            calculoTotal(
                                                calculoDias(
                                                    widget.sitio.valorNoche,
                                                    restaDias(
                                                        DateTime.parse(
                                                            fechaEntradaController
                                                                .text),
                                                        DateTime.parse(
                                                            fechaSalidaController
                                                                .text))),
                                                widget.sitio.valorLimpieza),
                                            restaDias(
                                                DateTime.parse(
                                                    fechaEntradaController
                                                        .text),
                                                DateTime.parse(
                                                    fechaSalidaController
                                                        .text)),
                                            widget.themeManager,
                                            numAdultosController.text,
                                            numNinosController.text,
                                            numBebesController.text,
                                            numMascotasController.text,
                                            usuario);
                                      }
                                    }
                                  }
                                } else {
                                  _modalIniciarSesion(
                                      context, widget.themeManager);
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: primaryColor),
                                child: Center(
                                    child: Text(
                                  "Reservar",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Información de la reserva que estoy realizando
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "\$ ${widget.sitio.valorNocheFormatted} COP x ${restaDias(DateTime.parse(fechaEntradaController.text), DateTime.parse(fechaSalidaController.text))} noches",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$ ${valorFormatted(calculoDias(widget.sitio.valorNoche, restaDias(DateTime.parse(fechaEntradaController.text), DateTime.parse(fechaSalidaController.text))))}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Tarifa de limpieza",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$ ${widget.sitio.valorLimpiezaFormatted} COP",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$ ${valorFormatted(calculoTotal(calculoDias(widget.sitio.valorNoche, restaDias(DateTime.parse(fechaEntradaController.text), DateTime.parse(fechaSalidaController.text))), widget.sitio.valorLimpieza))} COP",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        // Calendario Fecha Entrada
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Center(
                  child: Text(
                    "Fecha Llegada",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                FutureBuilder(
                    future: getReservas(), // Traer reservas del servidor
                    builder:
                        (context, AsyncSnapshot<List<ReservaModel>> reserva) {
                          // Mientras carga la información
                      if (reserva.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Mirar si las reservas estan relacionadas con el sitio y a su vez verificar si hay activas
                      for (var r = 0; r < reserva.data!.length; r++) {
                        if (widget.sitio.id == reserva.data![r].sitio.id) {
                          if (reserva.data![r].estado == "Activo") {
                            reservaActivaE.add(reserva.data![r]);
                          }
                        }
                      }

                      return TableCalendar(
                        locale: 'en_US',
                        rowHeight: 43,
                        calendarStyle: const CalendarStyle(
                          rangeHighlightColor: primaryColor,
                          todayDecoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                        ),
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        availableGestures: AvailableGestures.all,
                        // Selecionar fecha de entrada y rango para las reservas activas
                        selectedDayPredicate: (day) {
                          return isSameDay(day, today1) || _isDayInRangeE(day);
                        },
                        focusedDay: today1,
                        firstDay: DateTime.utc(1910, 01, 01),
                        lastDay: DateTime.utc(2100, 01, 01),
                        // Función para seleccionar fecha de entrada
                        onDaySelected: _onDaySelectedEntrada,
                        // bloquear fechas anteriores al dia actual
                        enabledDayPredicate: _isDayDisabled1,
                      );
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        // Calendario fecha salida
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Center(
                  child: Text(
                    "Fecha Salida",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                FutureBuilder(
                    future: getReservas(), // Traer todas las reservas del servidor
                    builder:
                        (context, AsyncSnapshot<List<ReservaModel>> reserva) {
                          // Mientras trae la información
                      if (reserva.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Verificar las reservas relacionadas al sitio y a su vez ver si estas estan activas
                      for (var r = 0; r < reserva.data!.length; r++) {
                        if (widget.sitio.id == reserva.data![r].sitio.id) {
                          if (reserva.data![r].estado == "Activo") {
                            reservaActivaS.add(reserva.data![r]);
                          }
                        }
                      }
                      return TableCalendar(
                        locale: 'en_US',
                        rowHeight: 43,
                        calendarStyle: const CalendarStyle(
                          rangeHighlightColor: primaryColor,
                          todayDecoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                        ),
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        availableGestures: AvailableGestures.all,
                        // Seleccionar fecha de salida y los dias que ya estan reservados
                        selectedDayPredicate: (day) {
                          return isSameDay(day, today2) || _isDayInRangeS(day);
                        },
                        focusedDay: today2,
                        firstDay: DateTime.utc(1910, 01, 01),
                        lastDay: DateTime.utc(2100, 01, 01),
                        // seleccionar fecha de salida
                        onDaySelected: _onDaySelectedSalida,
                        // bloquear los dias anteriores a la fecha actual
                        enabledDayPredicate: _isDayDisabled2,
                      );
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Contar el número de dias
  int restaDias(DateTime fechaEntrada, DateTime fechaSalida) {
    int diferenciaDias = fechaSalida.difference(fechaEntrada).inDays;

    // Validar si el numero de días en menor a 0
    if (diferenciaDias <= 0) {
      return 0;
    } else {
      return diferenciaDias;
    }
  }

  // calcular el valor noche de la reserva por la cantidad de días que se seleccionaron
  int calculoDias(int valor, int dias) {
    int resultadoEstadia = (valor * dias);

    return resultadoEstadia;
  }

  // calculo del valor total de la reserva
  int calculoTotal(int valor, int valorLimpieza) {
    double totalidad = (valor + valorLimpieza).toDouble();

    totalidad *= 1.19;

    return totalidad.toInt();
  }

  // Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String valorFormatted(int valor) {
    return NumberFormat.currency(
      symbol: '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale: 'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits: 0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valor); // Aplicar el formato a la variable valor
  }

  // Modal para confirmar la reserva
  showConfirmarReserva(
    context,
    SitioModel sitio,
    String fechaEntrada,
    String fechaSalida,
    String totalHuespedes,
    int valorDias,
    int valorTotal,
    int totalNoches,
    ThemeManager themeManager,
    String numeroAdultos,
    String numeroNinos,
    String numeroBebes,
    String numeroMascotas,
    int usuario,
  ) {
    List<String> listaImagen = [];

    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: const EdgeInsets.all(15),
                height: 610,
                width: 400,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Colors.black,
                            )),
                        const Text(
                          'Confirma y paga',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            FutureBuilder(
                                future: getImagen(), // traer todas las imagenes del servidor
                                builder: (context,
                                    AsyncSnapshot<List<ImagenModel>> imagen) {
                                      // Mientras trae la información
                                  if (imagen.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // Mirar si hay imagenes relacionadas al sitio
                                  for (var h = 0;
                                      h < imagen.data!.length;
                                      h++) {
                                    if (sitio.id == imagen.data![h].sitio) {
                                      listaImagen
                                          .add(imagen.data![h].direccion);
                                    }
                                  }

                                  return Container(
                                    width: 150,
                                    height: 100,
                                    // color: Colors.black,
                                    // Imagen
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              listaImagen[0],
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  );
                                }),
                                // Información del sitio
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        // Titulo
                                        Expanded(
                                          child: Text(
                                            sitio.titulo,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        // Lugar
                                        Expanded(
                                          child: Text(
                                            sitio.lugar,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Calificación del sitio
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Color(0xFFAD974F),
                                            size: 15,
                                          ),
                                          FutureBuilder(
                                              future: getComentarios(), // traer todos los comentario
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<ComentarioModel>>
                                                      comentario) {
                                                if (comentario
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                // Variables para calcular la calificación
                                                int totalComentarios = 0;
                                                double totalLimpieza = 0.0;
                                                double totalComunicacion = 0.0;
                                                double totalLlegada = 0.0;
                                                double totalFiabilidad = 0.0;
                                                double totalUbicacion = 0.0;
                                                double totalPrecio = 0.0;

                                                // Mirar los comentarios relacionados al sitio y asignar a las variables anteriores las calificaciones respectivas
                                                for (var z = 0;
                                                    z < comentario.data!.length;
                                                    z++) {
                                                  if (widget.sitio.id ==
                                                      comentario
                                                          .data![z].sitio.id) {
                                                    totalComentarios++;
                                                    totalLimpieza += comentario
                                                        .data![z].calLimpieza;
                                                    totalComunicacion +=
                                                        comentario.data![z]
                                                            .calComunicacion;
                                                    totalLlegada += comentario
                                                        .data![z].calLlegada;
                                                    totalFiabilidad +=
                                                        comentario.data![z]
                                                            .calFiabilidad;
                                                    totalUbicacion += comentario
                                                        .data![z].calUbicacion;
                                                    totalPrecio += comentario
                                                        .data![z].calPrecio;
                                                  }
                                                }

                                                // Calculo de los promedios de cada calificación
                                                double avgLimpieza =
                                                    totalLimpieza /
                                                        totalComentarios;
                                                double avgComunicacion =
                                                    totalComunicacion /
                                                        totalComentarios;
                                                double avgLlegada =
                                                    totalLlegada /
                                                        totalComentarios;
                                                double avgFiabilidad =
                                                    totalFiabilidad /
                                                        totalComentarios;
                                                double avgUbicacion =
                                                    totalUbicacion /
                                                        totalComentarios;
                                                double avgPrecio = totalPrecio /
                                                    totalComentarios;

                                                // Calculo de la calificación total
                                                double avgTotal = (avgLimpieza +
                                                        avgComunicacion +
                                                        avgLlegada +
                                                        avgFiabilidad +
                                                        avgUbicacion +
                                                        avgPrecio) /
                                                    6;
                                                return Text(
                                                  "${avgTotal.isNaN ? 0.0 : avgTotal.toStringAsFixed(1)}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        '°',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 5),
                                      // Categoría
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.house,
                                            size: 15,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            sitio.categoria.nombre,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Información de la reserva que estoy realizando
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Informacion de tu viaje',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha Entrada',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        fechaEntrada,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha Salida',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        fechaSalida,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Huespedes',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '$totalHuespedes huespedes',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tu total',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$totalNoches noches',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'COP ${valorFormatted(valorDias)}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total (COP)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'COP ${valorFormatted(valorTotal)}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        // Funcionalidad del botón el cual al dar click llevara al usuario a una autenticación por IA dependiendo el entorno donde se este usando el aplicativo
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UniversalPlatform.isAndroid
                                ? ReconocimientoFacialR(
                                    sitio: sitio,
                                    fechaEntrada: fechaEntrada,
                                    fechaSalida: fechaSalida,
                                    totalHuespedes: totalHuespedes,
                                    totalNoches: totalNoches,
                                    valorDias: valorDias,
                                    valorTotal: valorTotal,
                                    themeManager: themeManager,
                                    numeroAdultos: numeroAdultos,
                                    numeroNinos: numeroNinos,
                                    numeroBebes: numeroBebes,
                                    numeroMascotas: numeroMascotas,
                                    usuario: usuario,
                                  )
                                : IdentificacionWebR(
                                    sitio: sitio,
                                    fechaEntrada: fechaEntrada,
                                    fechaSalida: fechaSalida,
                                    totalHuespedes: totalHuespedes,
                                    totalNoches: totalNoches,
                                    valorDias: valorDias,
                                    valorTotal: valorTotal,
                                    themeManager: themeManager,
                                    numeroAdultos: numeroAdultos,
                                    numeroNinos: numeroNinos,
                                    numeroBebes: numeroBebes,
                                    numeroMascotas: numeroMascotas,
                                    usuario: usuario,
                                  )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: const Color(0xFFAD974F),
                        child: const Center(
                          child: Text(
                            'Confirmar Pago',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
          ),
        );
      },
    );
  }

  // Modal para iniciar sesión
  void _modalIniciarSesion(BuildContext context, ThemeManager themeManager) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "¿Quiere realizar esta acción?",
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
                        "Para llevar a cabo esta acción, es necesario iniciar sesión primero.",
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
                    // botón para iniciar sesión
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginPage(themeManager: themeManager),
                          ),
                        );
                      },
                      child: const Text("Iniciar Sesión")),
                ],
              ),
            ],
          );
        });
  }
}

// Extensión para validar si no hay interferencia o sobreposición de las fechas seleccionadas al rango de fechas que estan reservadas
extension DateTimeComparisonExtension on DateTime {
  // Valida si la fecha esta antes o igual a otra
  bool isBeforeOrEqual(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  // Valida si la fecha esta despues o igual a otra
  bool isAfterOrEqual(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }
}
