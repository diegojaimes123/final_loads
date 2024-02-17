// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, unnecessary_this

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/ComentarioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

import '../../models/ip/local.dart';

class ComentarioEdit extends StatefulWidget {
  // Parametro que recibe el comentario
  final ComentarioModel comentario;

  final ThemeManager themeManager;

  const ComentarioEdit(
      {super.key, required this.themeManager, required this.comentario});

  @override
  State<ComentarioEdit> createState() => _ComentarioEditState();
}

class _ComentarioEditState extends State<ComentarioEdit> {
  // Inicializar variables con calificaciones y descripciones de comentarios
  late double limpieza = widget.comentario.calLimpieza;
  late double comunicacion = widget.comentario.calComunicacion;
  late double llegada = widget.comentario.calLlegada;
  late double fiabilidad = widget.comentario.calFiabilidad;
  late double ubicacion = widget.comentario.calUbicacion;
  late double precio = widget.comentario.calPrecio;

  // Controladores de texto para las descripciones de cada aspecto del comentario
  late TextEditingController desLimpieza =
      TextEditingController(text: widget.comentario.desLimpieza);
  late TextEditingController desComunicacion =
      TextEditingController(text: widget.comentario.desComunicacion);
  late TextEditingController desLlegada =
      TextEditingController(text: widget.comentario.desLlegada);
  late TextEditingController desFiabilidad =
      TextEditingController(text: widget.comentario.desFiabilidad);
  late TextEditingController desUbicacion =
      TextEditingController(text: widget.comentario.desUbicacion);
  late TextEditingController desPrecio =
      TextEditingController(text: widget.comentario.desPrecio);
  late TextEditingController descripcion =
      TextEditingController(text: widget.comentario.descripcion);

  // Método para editar un comentario existente
  Future editComentario() async {
    // Construir la URL de la API según la plataforma
    String url = "";

    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Comentarios/";
    } else {
      url = "http://127.0.0.1:8000/api/Comentarios/";
    }

    // Encabezados y cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "usuario": widget.comentario.usuario,
      "fecha": widget.comentario.fecha,
      "calLimpieza": limpieza,
      "desLimpieza": desLimpieza.text.trim(),
      "calComunicacion": comunicacion,
      "desComunicacion": desComunicacion.text.trim(),
      "calLlegada": llegada,
      "desLlegada": desLlegada.text.trim(),
      "calFiabilidad": fiabilidad,
      "desFiabilidad": desFiabilidad.text.trim(),
      "calUbicacion": comunicacion,
      "desUbicacion": desUbicacion.text.trim(),
      "calPrecio": precio,
      "desPrecio": desPrecio.text.trim(),
      "descripcion": descripcion.text.trim(),
      "sitio": widget.comentario.sitio.id,
    };

    // Variable para almacenar el resultado de la operación
    int resultado = 0;

    try {
      // Realizar la solicitud HTTP PUT para editar el comentario
      final response = await http.put(
        Uri.parse("$url${widget.comentario.id}/"),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el resultado con el código de estado de la respuesta
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      // Manejar cualquier error
      print(e);
    }

    // Navegar a la pantalla principal después de editar el comentario
    if (resultado == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreenPage(
            themeManager: widget.themeManager,
          ),
        ),
      );
    }
  }

  // Liberar recursos cuando se destruye el widget
  @override
  void dispose() {
    desLimpieza.dispose();
    desComunicacion.dispose();
    desLlegada.dispose();
    desFiabilidad.dispose();
    desUbicacion.dispose();
    desPrecio.dispose();
    descripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo Limpieza
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Que tal estuvo la limpieza del lugar?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.limpieza = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                limpieza == 1
                    ? 'Muy mala'
                    : limpieza == 2
                        ? 'Mala'
                        : limpieza == 3
                            ? 'Basica'
                            : limpieza == 4
                                ? 'Buena'
                                : limpieza == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.limpieza == 1 || this.limpieza == 2 || this.limpieza == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Tuviste algún problema?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desLimpieza,
                      onChanged: (val) {
                        desLimpieza.value =
                            desLimpieza.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Comunicación
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Como estuvo tu comunicacion con el anfitrion del lugar?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.comunicacion = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                comunicacion == 1
                    ? 'Muy mala'
                    : comunicacion == 2
                        ? 'Mala'
                        : comunicacion == 3
                            ? 'Basica'
                            : comunicacion == 4
                                ? 'Buena'
                                : comunicacion == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.comunicacion == 1 ||
              this.comunicacion == 2 ||
              this.comunicacion == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Tuviste algún problema?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desComunicacion,
                      onChanged: (val) {
                        desComunicacion.value =
                            desComunicacion.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Llegada
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Califica tu llegada al lugar?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.llegada = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                llegada == 1
                    ? 'Muy mala'
                    : llegada == 2
                        ? 'Mala'
                        : llegada == 3
                            ? 'Basica'
                            : llegada == 4
                                ? 'Buena'
                                : llegada == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.llegada == 1 || this.llegada == 2 || this.llegada == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Que te sucedio? !Cuentanos!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desLlegada,
                      onChanged: (val) {
                        desLlegada.value = desLlegada.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Fiabilidad
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Cumplia con tus expectativas?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.fiabilidad = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                fiabilidad == 1
                    ? 'Muy mala'
                    : fiabilidad == 2
                        ? 'Mala'
                        : fiabilidad == 3
                            ? 'Basica'
                            : fiabilidad == 4
                                ? 'Buena'
                                : fiabilidad == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.fiabilidad == 1 ||
              this.fiabilidad == 2 ||
              this.fiabilidad == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Por que no cumplio con tus expectativas?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desFiabilidad,
                      onChanged: (val) {
                        desFiabilidad.value =
                            desFiabilidad.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Ubicación
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Cuentanos sobre la ubicacion del lugar?\n¿Te gusto?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.ubicacion = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                ubicacion == 1
                    ? 'Muy mala'
                    : ubicacion == 2
                        ? 'Mala'
                        : ubicacion == 3
                            ? 'Basica'
                            : ubicacion == 4
                                ? 'Buena'
                                : ubicacion == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.ubicacion == 1 || this.ubicacion == 2 || this.ubicacion == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Que te disgusto? !Cuentanos!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desUbicacion,
                      onChanged: (val) {
                        desUbicacion.value =
                            desUbicacion.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Precio
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              '¿Que tal el precio?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                updateOnDrag: true,
                minRating: 1,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xFFAD974F),
                ),
                onRatingUpdate: (rating) => setState(() {
                  this.precio = rating;
                }),
              ),
              const SizedBox(width: 10),
              Text(
                precio == 1
                    ? 'Muy malo'
                    : precio == 2
                        ? 'Malo'
                        : precio == 3
                            ? 'Normal'
                            : llegada == 4
                                ? 'Bueno'
                                : llegada == 5
                                    ? 'Excelente'
                                    : '',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'JosefinSans-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (this.precio == 1 || this.precio == 2 || this.precio == 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿No se adapta al lugar?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans-SemiBold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: desPrecio,
                      onChanged: (val) {
                        desPrecio.value = desPrecio.value.copyWith(text: val);
                      },
                      maxLines: 2,
                      // controller: titulo,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 13),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Cuentanos tu problema',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          const Divider(),

          // Campo Comentario
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Comenta sobre nuestro lugar, recuerda que tu opinion es muy valiosa para nosotros.',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: descripcion,
                onChanged: (val) {
                  descripcion.value = descripcion.value.copyWith(text: val);
                },
                maxLines: 10,
                // controller: titulo,
                obscureText: false,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Deja tu comentario',
                  hintStyle: const TextStyle(color: Colors.black),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Se requiere de este campo';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Botón para guardar el comentario
          Center(
            child: InkWell(
              onTap: () {
                // Función para guardar el comentario
                editComentario();
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: const Text(
                  "Editar Comentario",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
