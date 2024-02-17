// ignore_for_file: no_logic_in_create_state, unnecessary_overrides, file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/identificacionReserva/IdentificacionClases.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// ignore: must_be_immutable
class IdentificacionWebR extends StatefulWidget {
  // propiedades que traen la información para hacer la reserva
  final ThemeManager themeManager;
  final SitioModel sitio;
  final String fechaEntrada;
  final String fechaSalida;
  final String totalHuespedes;
  final int valorDias;
  final int valorTotal;
  final int totalNoches;
  final String numeroAdultos;
  final String numeroNinos;
  final String numeroBebes;
  final String numeroMascotas;
  final int usuario;

  const IdentificacionWebR({
    Key? key,
    required this.themeManager,
    required this.sitio,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.totalHuespedes,
    required this.valorDias,
    required this.valorTotal,
    required this.totalNoches,
    required this.numeroAdultos,
    required this.numeroNinos,
    required this.numeroBebes,
    required this.numeroMascotas,
    required this.usuario,
  }) : super(key: key);

  @override
  State<IdentificacionWebR> createState() =>
      _IdentificacionWebRState(themeManager);
}

class _IdentificacionWebRState extends State<IdentificacionWebR>
    with SingleTickerProviderStateMixin {
  final ThemeManager themeManager;

  late int index;

  late bool imagen = true;

  //funcion void del tab
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _IdentificacionWebRState(this.themeManager);

  @override
  Widget build(BuildContext context) {
    //Widget que almacena las diferentes vistas del responsive
    return LayoutBuilder(builder: (context, responsive) {
      //primera vista del responsive
      // valida si el ancho de la pantalla es igual a 375
      if (responsive.maxWidth == 375) {
        //Este condicional es para la imagen que dependiendo donde este ubicado en el tab asi mismo sera la imagen
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Color(0x73606060),
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen6.jpg' : '../images/imagen7.jpg',
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir a la validación por reconocimiento de voz
                  child: IdentificacionRClases(
                    themeManager: widget.themeManager,
                    sitio: widget.sitio,
                    fechaEntrada: widget.fechaEntrada,
                    fechaSalida: widget.fechaSalida,
                    totalHuespedes: widget.totalHuespedes,
                    valorDias: widget.valorDias,
                    valorTotal: widget.valorTotal,
                    totalNoches: widget.totalNoches,
                    numeroAdultos: widget.numeroAdultos,
                    numeroNinos: widget.numeroNinos,
                    numeroBebes: widget.numeroBebes,
                    numeroMascotas: widget.numeroMascotas,
                    usuario: widget.usuario,
                  ),
                )));
        // valida si el ancho de la pantalla es igual o menor a 300
      } else if (responsive.maxWidth <= 300) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir a la validación por reconocimiento de voz
                  child: IdentificacionRClases(
                    themeManager: widget.themeManager,
                    sitio: widget.sitio,
                    fechaEntrada: widget.fechaEntrada,
                    fechaSalida: widget.fechaSalida,
                    totalHuespedes: widget.totalHuespedes,
                    valorDias: widget.valorDias,
                    valorTotal: widget.valorTotal,
                    totalNoches: widget.totalNoches,
                    numeroAdultos: widget.numeroAdultos,
                    numeroNinos: widget.numeroNinos,
                    numeroBebes: widget.numeroBebes,
                    numeroMascotas: widget.numeroMascotas,
                    usuario: widget.usuario,
                  ),
                )));
        // valida si el ancho de la pantalla es igual o menor a 500
      } else if (responsive.maxWidth <= 500) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir a la validación por reconocimiento de voz
                  child: IdentificacionRClases(
                    themeManager: widget.themeManager,
                    sitio: widget.sitio,
                    fechaEntrada: widget.fechaEntrada,
                    fechaSalida: widget.fechaSalida,
                    totalHuespedes: widget.totalHuespedes,
                    valorDias: widget.valorDias,
                    valorTotal: widget.valorTotal,
                    totalNoches: widget.totalNoches,
                    numeroAdultos: widget.numeroAdultos,
                    numeroNinos: widget.numeroNinos,
                    numeroBebes: widget.numeroBebes,
                    numeroMascotas: widget.numeroMascotas,
                    usuario: widget.usuario,
                  ),
                )));
        // valida si el ancho de la pantalla es igual o mayor a 1000
      } else if (responsive.maxWidth >= 1000) {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen8.jpg' : '../images/imagen7.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir a la validación por reconocimiento de voz
                  child: IdentificacionRClases(
                    themeManager: widget.themeManager,
                    sitio: widget.sitio,
                    fechaEntrada: widget.fechaEntrada,
                    fechaSalida: widget.fechaSalida,
                    totalHuespedes: widget.totalHuespedes,
                    valorDias: widget.valorDias,
                    valorTotal: widget.valorTotal,
                    totalNoches: widget.totalNoches,
                    numeroAdultos: widget.numeroAdultos,
                    numeroNinos: widget.numeroNinos,
                    numeroBebes: widget.numeroBebes,
                    numeroMascotas: widget.numeroMascotas,
                    usuario: widget.usuario,
                  ),
                )));
        //Vista por defecto
      } else {
        return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                        'assets/images/imagen5.jpg'), fit: BoxFit.cover)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0x27000000)),
                  // ir a la validación por reconocimiento de voz
                  child: IdentificacionRClases(
                    themeManager: widget.themeManager,
                    sitio: widget.sitio,
                    fechaEntrada: widget.fechaEntrada,
                    fechaSalida: widget.fechaSalida,
                    totalHuespedes: widget.totalHuespedes,
                    valorDias: widget.valorDias,
                    valorTotal: widget.valorTotal,
                    totalNoches: widget.totalNoches,
                    numeroAdultos: widget.numeroAdultos,
                    numeroNinos: widget.numeroNinos,
                    numeroBebes: widget.numeroBebes,
                    numeroMascotas: widget.numeroMascotas,
                    usuario: widget.usuario,
                  ),
                )));
      }
    });
  }
}
