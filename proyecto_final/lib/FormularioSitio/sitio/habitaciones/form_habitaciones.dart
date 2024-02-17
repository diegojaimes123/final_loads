import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/FormularioSitio/forms_provider.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

// Widget para gestionar y mostrar una lista de habitaciones con títulos y descripciones
class Example extends StatefulWidget {
  final List<String> tituloHabitaciones;
  final List<String> descripcionHabitaciones;

  const Example(
      {Key? key,
      required this.tituloHabitaciones,
      required this.descripcionHabitaciones})
      : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    // Acceder a los controladores desde FormsProvider utilizando Provider
    List<TextEditingController> titleControllers =
        context.watch<FormsProvider>().controller;
    List<TextEditingController> descriptionControllers =
        context.watch<FormsProvider>().controller2;

    return Scaffold(
      body: ListView(
        children: [
          // Iterar a través de cada controlador de habitación para mostrar los campos de título y descripción
          for (int index = 0; index < titleControllers.length; index++)
            Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          //Campo titulo
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: TextFormField(
                                controller: titleControllers[index],
                                obscureText: false,
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(fontSize: 13),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Titulo',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                                // Validar campo
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Se requiere de este campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          //campo descripción
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: TextFormField(
                                maxLines: 5,
                                controller: descriptionControllers[index],
                                obscureText: false,
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(fontSize: 13),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Descripcion',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                                // Validar campo
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Se requiere de este campo';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Eliminar controladores al hacer clic en el botón de eliminar
                        context
                            .read<FormsProvider>()
                            .deleteControllers(index: index);
                        context
                            .read<FormsProvider>()
                            .deleteControllers2(index: index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Agregar nuevos controladores al hacer clic en el botón de agregar habitación
              context.read<FormsProvider>().createControllers();
              context.read<FormsProvider>().createControllers2();
            },
            child: const Text('Agregar Habitación'),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          ElevatedButton(
            onPressed: () {
              // Guardar los títulos y descripciones al hacer clic en el botón de guardar
              setState(() {
                widget.tituloHabitaciones.addAll(titleControllers
                    .map((controller) => controller.text)
                    .toList());
                widget.descripcionHabitaciones.addAll(descriptionControllers
                    .map((controller) => controller.text)
                    .toList());
              });
              Navigator.pop(context);
            },
            child: const Text("Guardar Habitaciones"),
          ),
        ],
      ),
    );
  }
}
