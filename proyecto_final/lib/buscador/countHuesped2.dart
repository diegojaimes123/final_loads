// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/buscador/showHuesped2.dart';

// ignore: must_be_immutable
class CountHuesped2 extends StatefulWidget {
  // parametros para recibir el numero de huespedes
  TextEditingController numAdultosController;

  TextEditingController numNinosController;

  TextEditingController numBebesController;

  TextEditingController numMascotasController;

  TextEditingController total;

  CountHuesped2({
    super.key,
    required this.numAdultosController,
    required this.numNinosController,
    required this.numBebesController,
    required this.numMascotasController,
    required this.total,
  });

  @override
  State<CountHuesped2> createState() => _CountHuesped2State();
}

class _CountHuesped2State extends State<CountHuesped2> {
  // variables para la funcionalidad del desplegable del conteo de huespedes
  final layerLink = LayerLink();

  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
  }

  // limpiar recursos
  @override
  void dispose() {
    super.dispose();
  }

  // Mostrar desplegable del conteo de huespedes
  void showOverlay() {
    // variables para la funcionalidad del desplegable del conteo de huespedes
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: ShowHuesped2(
                  entry: entry,
                  numAdultosController: widget.numAdultosController,
                  numNinosController: widget.numNinosController,
                  numBebesController: widget.numBebesController,
                  numMascotasController: widget.numMascotasController,
                  total: widget.total,
                  updateTotalCallback: () {
                    // Llama a setState aquí para que se actualice el UI
                    setState(() {});
                  },
                ))));

    overlay.insert(entry!);
  }

  // cerrar desplegable del conteo de huespedes
  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: layerLink,
        // botón para abrir y cerrar el desplegable del conteo de los huespedes
        child: InkWell(
          onTap: () {
            showOverlay();
          },
          onDoubleTap: () {
            hideOverlay();
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 10,
              top: 10,
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                border: Border(
                    top: BorderSide(
                        style: BorderStyle.solid, color: Colors.grey),
                    bottom: BorderSide(
                        style: BorderStyle.solid, color: Colors.grey),
                    right: BorderSide(
                        style: BorderStyle.solid, color: Colors.grey),
                    left: BorderSide(
                        style: BorderStyle.solid, color: Colors.grey))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ver el total de los huespedes
                    const Text("Huéspedes"),
                    Text("${widget.total.text} huésped")
                  ],
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );
}
