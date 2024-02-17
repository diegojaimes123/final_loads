// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_final/buscador/countHuesped2.dart';
import 'package:proyecto_final/card.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class StepWidget extends StatefulWidget {
  final ThemeManager themeManager;

  const StepWidget({super.key, required this.themeManager});

  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  // Controladores de texto y variables los cuales son vitales para que el buscador tenga los argumentos de
  // continente, fecha de entrada, fecha de salida y número de huespedes a la hora de filtrar los sitios
  final complete = TextEditingController();
  bool expanded = false;
  int selectedContainerIndex = -0;
  String selectedCountry = "AMÉRICA DEL SUR";
  int currentStep = 0;
  bool isCompleted = false;
  DateTime fechaEntrada = DateTime.now();
  DateTime fechaSalida = DateTime.now();
  DateTime today1 = DateTime.now();
  DateTime today2 = DateTime.now();
  TextEditingController numAdultosController = TextEditingController();

  TextEditingController numNinosController = TextEditingController();

  TextEditingController numBebesController = TextEditingController();

  TextEditingController numMascotasController = TextEditingController();

  TextEditingController totalController = TextEditingController(text: "0");

  late TextEditingController fechaEntradaController = TextEditingController(
      text:
          "${fechaEntrada.year}-${fechaEntrada.month.toString().padLeft(2, '0')}-${fechaEntrada.day.toString().padLeft(2, '0')}");

  late TextEditingController fechaSalidaController = TextEditingController(
      text:
          "${fechaSalida.year}-${fechaSalida.month.toString().padLeft(2, '0')}-${fechaSalida.day.toString().padLeft(2, '0')}");

  // Función para seleccionar fecha de entrada
  void _onDaySelectedEntrada(DateTime day1, DateTime focusedDay) {
    setState(() {
      today1 = day1;
      fechaEntradaController.text =
          "${day1.year}-${day1.month.toString().padLeft(2, '0')}-${day1.day.toString().padLeft(2, '0')}";
    });
  }

  // Función para seleccionar fecha de salida
  void _onDaySelectedSalida(DateTime day2, DateTime focusedDay) {
    setState(() {
      today2 = day2;
      fechaSalidaController.text =
          "${day2.year}-${day2.month.toString().padLeft(2, '0')}-${day2.day.toString().padLeft(2, '0')}";
    });
  }

  // Función para bloquear los dias anteriores al día actual
  bool _isDayDisabled(DateTime day) {
    return day.isAfter(DateTime.now());
  }

  // Lista con todas las secciones del buscador
  List<Step> getSteps() => [
        //Continentes
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  width: 70,
                  child: const Text(
                    "Busqueda por region",
                    style: TextStyle(fontSize: 12),
                  ))),
          // Verifica si el ancho de la pantalla es movil
          content: Responsive.isMobile(context)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 650,
                  // Distribución de los continentes
                  child: InteractiveViewer(
                    scaleEnabled: false,
                    constrained: false,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildContainer(
                                  0,
                                  'AMÉRICA DEL SUR',
                                  'assets/images/sura.png',
                                  selectedContainerIndex == 0),
                              _buildContainer(
                                  1,
                                  'AMÉRICA DEL NORTE',
                                  'assets/images/nora.png',
                                  selectedContainerIndex == 1),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildContainer(
                                  2,
                                  'CENTRO AMÉRICA',
                                  'assets/images/centroa.png',
                                  selectedContainerIndex == 2),
                              _buildContainer(
                                  6,
                                  'EUROPA',
                                  'assets/images/europa.png',
                                  selectedContainerIndex == 6),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildContainer(
                                  3,
                                  'ASIA',
                                  'assets/images/asia.png',
                                  selectedContainerIndex == 3),
                              _buildContainer(
                                  4,
                                  'ÁFRICA',
                                  'assets/images/africa.png',
                                  selectedContainerIndex == 4),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildContainer(
                                  5,
                                  'OCEANÍA',
                                  'assets/images/oceania.png',
                                  selectedContainerIndex == 5),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              // Verificación si el ancho de la pantalla es tablet
              : Responsive.isTablet(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Distribución de los continentes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContainer(
                                0,
                                'AMÉRICA DEL SUR',
                                'assets/images/sura.png',
                                selectedContainerIndex == 0),
                            _buildContainer(
                                1,
                                'AMÉRICA DEL NORTE',
                                'assets/images/nora.png',
                                selectedContainerIndex == 1),
                            _buildContainer(
                                2,
                                'CENTRO AMÉRICA',
                                'assets/images/centroa.png',
                                selectedContainerIndex == 2),
                            _buildContainer(
                                6,
                                'EUROPA',
                                'assets/images/europa.png',
                                selectedContainerIndex == 6),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContainer(3, 'ASIA', 'assets/images/asia.png',
                                selectedContainerIndex == 3),
                            _buildContainer(
                                4,
                                'ÁFRICA',
                                'assets/images/africa.png',
                                selectedContainerIndex == 4),
                            _buildContainer(
                                5,
                                'OCEANÍA',
                                'assets/images/oceania.png',
                                selectedContainerIndex == 5),
                            const SizedBox(
                              width: 100,
                            )
                          ],
                        ),
                      ],
                    )
                  // Vista por defecto
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Distribución de los continentess
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContainer(
                                0,
                                'AMÉRICA DEL SUR',
                                'assets/images/sura.png',
                                selectedContainerIndex == 0),
                            _buildContainer(
                                1,
                                'AMÉRICA DEL NORTE',
                                'assets/images/nora.png',
                                selectedContainerIndex == 1),
                            _buildContainer(
                                2,
                                'CENTRO AMÉRICA',
                                'assets/images/centroa.png',
                                selectedContainerIndex == 2),
                            _buildContainer(
                                6,
                                'EUROPA',
                                'assets/images/europa.png',
                                selectedContainerIndex == 6),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContainer(3, 'ASIA', 'assets/images/asia.png',
                                selectedContainerIndex == 3),
                            _buildContainer(
                                4,
                                'ÁFRICA',
                                'assets/images/africa.png',
                                selectedContainerIndex == 4),
                            _buildContainer(
                                5,
                                'OCEANÍA',
                                'assets/images/oceania.png',
                                selectedContainerIndex == 5),
                            const SizedBox(
                              width: 100,
                            )
                          ],
                        ),
                      ],
                    ),
        ),
        // Disponibilidad
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(
            "Fechas",
            style: TextStyle(fontSize: 14),
          ),
          // Verifica si el ancho de la pantalla es movil
          content: Responsive.isMobile(context)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: InteractiveViewer(
                      scaleEnabled: false,
                      constrained: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    // Calendario fecha de entrada
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: SizedBox(
                                        child: Text(
                                          "Fecha Llegada",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: TableCalendar(
                                        locale: 'en_US',
                                        rowHeight: 30,
                                        calendarStyle: const CalendarStyle(
                                          rangeHighlightColor: primaryColor,
                                          todayDecoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle),
                                          selectedDecoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle),
                                        ),
                                        headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleCentered: true),
                                        availableGestures:
                                            AvailableGestures.all,
                                        selectedDayPredicate: (day) => isSameDay(
                                            day,
                                            today1), // Resaltar el día seleccionado
                                        focusedDay: today1,
                                        firstDay: DateTime.utc(1910, 01, 01),
                                        lastDay: DateTime.utc(2100, 01, 01),
                                        onDaySelected:
                                            _onDaySelectedEntrada, // Seleccionar el día
                                        enabledDayPredicate:
                                            _isDayDisabled, // Bloquear los días anteriores al actual
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    // Calendario fecha de salida
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: SizedBox(
                                        child: Text(
                                          "Fecha Salida",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: TableCalendar(
                                        locale: 'en_US',
                                        rowHeight: 43,
                                        calendarStyle: const CalendarStyle(
                                          rangeHighlightColor: primaryColor,
                                          todayDecoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle),
                                          selectedDecoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle),
                                        ),
                                        headerStyle: const HeaderStyle(
                                            formatButtonVisible: false,
                                            titleCentered: true),
                                        availableGestures:
                                            AvailableGestures.all,
                                        selectedDayPredicate: (day) => isSameDay(
                                            day,
                                            today2), // Resaltar el día seleccionado
                                        focusedDay: today1,
                                        firstDay: DateTime.utc(1910, 01, 01),
                                        lastDay: DateTime.utc(2100, 01, 01),
                                        onDaySelected:
                                            _onDaySelectedSalida, // Seleccionar el día
                                        enabledDayPredicate:
                                            _isDayDisabled, // Bloquear los días anteriores al actual
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              // Vista por defecto
              : Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        //Fecha de entrada
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: SizedBox(
                            child: Text(
                              "Fecha Llegada",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TableCalendar(
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
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (day) => isSameDay(
                                day, today1), // Resaltar el día seleccionado
                            focusedDay: today1,
                            firstDay: DateTime.utc(1910, 01, 01),
                            lastDay: DateTime.utc(2100, 01, 01),
                            onDaySelected:
                                _onDaySelectedEntrada, // Seleccionar el día
                            enabledDayPredicate:
                                _isDayDisabled, // Bloquear los días anteriores al actual
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        // Fecha de salida
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: SizedBox(
                            child: Text(
                              "Fecha Salida",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TableCalendar(
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
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (day) => isSameDay(
                                day, today2), // Resaltar el día seleccionado
                            focusedDay: today1,
                            firstDay: DateTime.utc(1910, 01, 01),
                            lastDay: DateTime.utc(2100, 01, 01),
                            onDaySelected:
                                _onDaySelectedSalida, // Seleccionar el día
                            enabledDayPredicate:
                                _isDayDisabled, // Bloquear los días anteriores al actual
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
        // Número de huespedes
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(
            "Número de\n huespedes",
            style: TextStyle(fontSize: 12),
          ),
          content: Column(
            children: [
              // Verifica si el ancho de la pantalla es tablet o escritorio
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                CountHuesped2(
                  numAdultosController: numAdultosController,
                  numNinosController: numNinosController,
                  numBebesController: numBebesController,
                  numMascotasController: numMascotasController,
                  total: totalController,
                )
              // Vista por defecto
              else
                // Campo para digitar el número de huespedes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextFormField(
                        onChanged: (val) {
                          totalController.value =
                              totalController.value.copyWith(text: val);
                        },
                        style: const TextStyle(color: Colors.black),
                        controller: totalController,
                        obscureText: false,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Ingrese el número de huespedes',
                          hintStyle: const TextStyle(color: Colors.black),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Si el proceso se completo ir a ver los sitios filtrados
      body: isCompleted
          ? buildCompleted(
              context,
              widget.themeManager,
              selectedCountry,
              DateTime.parse(fechaEntradaController.text),
              DateTime.parse(fechaSalidaController.text),
              int.parse(totalController.text))
          // Si no ver la siguiente sección
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: SizedBox(
                  width: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width - 100,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stepper(
                        //physics: NeverScrollableScrollPhysics(),
                        type: Responsive.isMobile(context)
                            ? StepperType.horizontal
                            : StepperType.horizontal,
                        steps: getSteps(),
                        currentStep: currentStep,
                        onStepContinue: () {
                          final isLastStep =
                              currentStep == getSteps().length - 1;

                          if (isLastStep) {
                            // Si es el último paso, marca el proceso como completado
                            setState(() => isCompleted = true);
                          } else {
                            // Si no es el último paso, avanza al siguiente paso
                            setState(() => currentStep += 1);
                          }
                        },
                        onStepTapped: (step) =>
                            setState(() => currentStep = step),
                        onStepCancel: currentStep == 0
                            ? null
                            : () => setState(() => currentStep -= 1),
                        controlsBuilder: (BuildContext context,
                            ControlsDetails controlsDetails) {
                          final isLastStep =
                              currentStep == getSteps().length - 1;

                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            margin: const EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                // Botón de "Siguiente" o "Buscar" dependiendo del paso actual
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor),
                                      onPressed: controlsDetails.onStepContinue,
                                      child: Text(
                                        isLastStep ? 'Buscar' : 'Siguiente',
                                        style: GoogleFonts.roboto(),
                                      )),
                                )),
                                // Botón "Atras" solo si no es el primer paso
                                if (currentStep != 0)
                                  Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor),
                                          onPressed:
                                              controlsDetails.onStepCancel,
                                          child: const Text("Atras"))),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  // CONTENEDOR SELECCIONABLE
  // Widget que se creo para ser invocado para la creación cada continente
  // Este Widget personaliza el contenedor con su imagen, titulo y estado boleano para que pueda ser seleccionado el continente

  Widget _buildContainer(
      int index, String text, String imageUrl, bool isSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Asignar valor booleano
            setState(() {
              isSelected = !isSelected;
              selectedCountry = text;
              selectedContainerIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected ? primaryColor : Colors.transparent,
                        width: 5.0),
                  ),
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(text,
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Metodo que buscara el sitio segun los filtros especificados
  // Es personalizable
  // Tiene su boton "reset" Que resetea los filtros
  buildCompleted(BuildContext context, ThemeManager themeManager, String lugar,
      DateTime fechaEntrada, DateTime fechaSalida, int total) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              // Traida de los datos
              future: Future.wait([getReservas(), getUsuario(), getSitios()]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Muestra un indicador de carga mientras se espera la respuesta
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Asignación de cada snapshot
                List<ReservaModel> reservas = snapshot.data![0];
                List<UsuariosModel> usuarios = snapshot.data![1];
                List<SitioModel> sitios = snapshot.data![2];

                // Filtrar sitios disponibles basándose en los criterios especificados
                List<SitioModel> sitiosDisponibles = buscarSitiosDisponibles(
                  sitios: sitios,
                  reservas: reservas,
                  totalHuespedes: total,
                  fechaEntrada: fechaEntrada,
                  fechaSalida: fechaSalida,
                  lugar: lugar,
                );

                if (snapshot.data![0] != null &&
                    snapshot.data![1] != null &&
                    snapshot.data![2] != null) {
                  // Mostrar los sitios disponibles en una cuadrícula
                  return GridView.builder(
                    itemCount: sitiosDisponibles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                      childAspectRatio: 0.83,
                    ),
                    itemBuilder: (context, index) {
                      return CardSite(
                        sitio: sitiosDisponibles[index],
                        usuario: usuarios,
                        themeManager: themeManager,
                      );
                    },
                  );
                } else {
                  // Mostrar un indicador de carga si no hay datos disponibles
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          // Botón "Reset" para reiniciar los filtros y volver al paso inicial
          ElevatedButton(
            child: const Text("Reset"),
            onPressed: () => setState(() {
              isCompleted = false;
              currentStep = 0;
              complete.clear();
            }),
          )
        ],
      ),
    );
  }

  // Función para buscar sitios disponibles según los criterios especificados
  List<SitioModel> buscarSitiosDisponibles({
    required List<SitioModel> sitios,
    required List<ReservaModel> reservas,
    required int totalHuespedes,
    required DateTime fechaEntrada,
    required DateTime fechaSalida,
    required String lugar,
  }) {
    List<SitioModel> sitiosDisponibles = [];

    for (int s = 0; s < sitios.length; s++) {
      SitioModel sitio = sitios[s];
      ReservaModel? reserva = encontrarReservaActiva(reservas, sitio);

      if (reserva == null || reserva.estado != "Activo") {
        // No hay reserva activa asociada al sitio
        if (cumpleRequisitos(
            sitio, null, lugar, fechaEntrada, fechaSalida, totalHuespedes)) {
          sitiosDisponibles.add(sitio);
        }
      } else {
        // Hay reserva activa asociada al sitio
        if (cumpleRequisitos(
            sitio, reserva, lugar, fechaEntrada, fechaSalida, totalHuespedes)) {
          sitiosDisponibles.add(sitio);
        }
      }
    }

    return sitiosDisponibles;
  }

  // Función para encontrar una reserva activa asociada a un sitio
  ReservaModel? encontrarReservaActiva(
      List<ReservaModel> reservas, SitioModel sitio) {
    for (int r = 0; r < reservas.length; r++) {
      ReservaModel reserva = reservas[r];

      if (sitio.id == reserva.sitio.id) {
        return reserva;
      }
    }
    return null;
  }

  // Función para verificar si un sitio cumple con los requisitos según los filtros
  bool cumpleRequisitos(SitioModel sitio, ReservaModel? reserva, String lugar,
      DateTime fechaEntrada, DateTime fechaSalida, int totalHuespedes) {
    if (sitio.continente == lugar && sitio.numHuespedes >= totalHuespedes) {
      if (reserva != null) {
        if (reserva.estado == "Activo" &&
            fechaEnRango(fechaEntrada, fechaSalida, reserva.fechaEntrada,
                reserva.fechaSalida)) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  // Función para verificar si una fecha está en un rango específico
  bool fechaEnRango(
    DateTime fechaEntrada,
    DateTime fechaSalida,
    String fechaEntradaReserva,
    String fechaSalidaReserva,
  ) {
    DateTime fechaEntradaReservaDT = DateTime.parse(fechaEntradaReserva);
    DateTime fechaSalidaReservaDT = DateTime.parse(fechaSalidaReserva);

    return (fechaEntrada.isBeforeOrEqual(fechaEntradaReservaDT) &&
            fechaSalida.isAfterOrEqual(fechaSalidaReservaDT)) ||
        (fechaEntrada.isAfterOrEqual(fechaEntradaReservaDT) &&
            fechaSalida.isBeforeOrEqual(fechaSalidaReservaDT)) ||
        (fechaEntrada.isBeforeOrEqual(fechaEntradaReservaDT) &&
            fechaSalida.isAfterOrEqual(fechaEntradaReservaDT)) ||
        (fechaEntrada.isBeforeOrEqual(fechaSalidaReservaDT) &&
            fechaSalida.isAfterOrEqual(fechaSalidaReservaDT));
  }
}

// Extensión para comparaciones de fecha en DateTime
extension DateTimeComparisonExtension on DateTime {
  bool isBeforeOrEqual(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool isAfterOrEqual(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }
}
