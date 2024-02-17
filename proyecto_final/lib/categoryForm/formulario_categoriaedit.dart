// ignore_for_file: avoid_print, use_build_context_synchronously,, prefer_final_fields

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:http/http.dart' as http;
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/CategoriaModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';

import '../models/ip/local.dart';

class CategoriaFormEdit extends StatefulWidget {
  final ThemeManager themeManager;
  // parametro que recibe la categoría
  final CategoriaModel categorias;
  const CategoriaFormEdit({
    super.key,
    required this.categorias,
    required this.themeManager,
  });

  @override
  State<CategoriaFormEdit> createState() => _CategoriaFormEditState();
}

class _CategoriaFormEditState extends State<CategoriaFormEdit> {
  //Validacion de formularios
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Cargar los controladores de texto con la información de la categoría
  late TextEditingController _categoriaController =
      TextEditingController(text: widget.categorias.nombre);
  late TextEditingController _imagenController =
      TextEditingController(text: widget.categorias.imagen);
  late TextEditingController _iconController =
      TextEditingController(text: widget.categorias.icono);

  // Variables para el seguimiento de la selección de archivos de imagen e icono
  String selectCFile = '';
  String selectCIcon = '';
  Uint8List? selectedImagenInBytes;
  int imagenCounts = 0;
  List<Uint8List> pickedImagesBytes = [];
  String foto = '';
  Uint8List? iconBytes;
  String botonIcono = 'Seleccionar Icono';
  String botonImagen = 'Seleccionar Imagen';

  // Método para seleccionar un archivo de imagen
  _selectFileC(bool imagenFrom) async {
    // Elimina la referencia de almacenamiento de la imagen actual en Firebase Storage
    firabase_storage.Reference storageReferenceImagen = firabase_storage
        .FirebaseStorage.instance
        .refFromURL(_imagenController.text);

    await storageReferenceImagen.delete();

    // Utiliza FilePicker para permitir al usuario seleccionar un archivo de imagen
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectCFile = fileResult.files.first.name;
        selectedImagenInBytes = fileResult.files.first.bytes;
      });
    }
    final url =
        await _uploadFileC(); // Sube la imagen seleccionada a Firebase Storage
    print(url);
    print(selectCFile);
    setState(() {
      botonImagen = "Listo";
    });
  }

  // Método para seleccionar un archivo de icono
  _selectIconC(bool iconFrom) async {
    // Elimina la referencia de almacenamiento del icono actual en Firebase Storage
    firabase_storage.Reference storageReferenceIcono = firabase_storage
        .FirebaseStorage.instance
        .refFromURL(_iconController.text);

    await storageReferenceIcono.delete();

    // Utiliza FilePicker para permitir al usuario seleccionar un archivo de icono
    FilePickerResult? iconResult = await FilePicker.platform.pickFiles();

    if (iconResult != null) {
      setState(() {
        selectCIcon = iconResult.files.first.name;
        iconBytes = iconResult.files.first.bytes;
      });
    }
    final url =
        await _uploadIconC(); // Sube el icono seleccionado a Firebase Storage
    print(url);
    print(selectCIcon);
    setState(() {
      botonIcono = "Listo";
    });
  }

  // Método para subir el archivo de imagen a Firebase Storage y obtener la URL
  Future<String> _uploadFileC() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      // Establece la referencia de almacenamiento en Firebase Storage para la imagen
      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('category')
          .child('/$selectCFile');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      // Inicia la carga del archivo de imagen a Firebase Storage
      uploadTask = ref.putData(selectedImagenInBytes!, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
      // Actualiza el valor del controlador con la URL de la imagen
      setState(() {
        _imagenController.text = imageUrl;
      });
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  // Método para subir el archivo de icono a Firebase Storage y obtener la URL
  Future<String> _uploadIconC() async {
    String iconUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      // Establece la referencia de almacenamiento en Firebase Storage para el icono
      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('category')
          .child('/$selectCIcon');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/png');

      // Inicia la carga del archivo de icono a Firebase Storage
      uploadTask = ref.putData(iconBytes!, metadata);

      await uploadTask.whenComplete(() => null);
      iconUrl = await ref.getDownloadURL();
      // Actualiza el valor del controlador con la URL del icono
      setState(() {
        _iconController.text = iconUrl;
      });
    } catch (e) {
      print(e);
    }
    return iconUrl;
  }

  // Método para enviar una solicitud PUT y actualizar la categoría en la base de datos
  Future editCategory() async {
    String url = "";

    // Construye la URL según la plataforma (Android o no Android)
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Categorias/";
    } else {
      url = "http://127.0.0.1:8000/api/Categorias/";
    }

    // Encabezados de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Cuerpo de la solicitud HTTP con los datos actualizados de la categoría
    final Map<String, dynamic> dataBody = {
      "nombre": _categoriaController.text.trim(),
      "icono": _iconController.text.trim(),
      "imagen": _imagenController.text.trim(),
    };

    // Variable para almacenar el código de estado de la respuesta HTTP
    int resultado = 0;

    try {
      // Realiza una solicitud PUT para actualizar la categoría en la base de datos
      final response = await http.put(
        Uri.parse("$url${widget.categorias.id}/"),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualiza el código de estado con la respuesta recibida
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      // Maneja cualquier error durante la solicitud HTTP
      print(e);
    }

    // Verifica si la actualización fue exitosa (estado 200) y navega de regreso a la pantalla principal
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

  // Se libera los controladores cuando el widget se elimina
  @override
  void dispose() {
    // Libera los recursos asociados a los controladores de texto
    _categoriaController.dispose();
    _imagenController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Verifica el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, responsive) {
          // Verifica si el ancho de la pantalla es menor o igual 730
          if (responsive.maxWidth <= 730) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 6,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Categoria',
                                  style: TextStyle(
                                      fontFamily: 'CedarvilleCursive',
                                      fontSize: 40,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 30),
                                // Formulario de edición de categoría
                                Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        // Campo de texto para el nombre de la categoría
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              child: TextFormField(
                                                onChanged: (val) {
                                                  _categoriaController.value =
                                                      _categoriaController.value
                                                          .copyWith(text: val);
                                                },
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                controller:
                                                    _categoriaController,
                                                obscureText: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  labelStyle: const TextStyle(
                                                      fontSize: 13),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  hintText: 'Categoria',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black),
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                ),
                                                // Validación del campo
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Se requiere de este campo";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Selección de archivo de imagen
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              botonImagen = "Cargando";
                                            });
                                            _selectFileC(true);
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 50,
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                botonImagen,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Vista previa de la imagen seleccionada
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5))),
                                          child: selectCFile.isEmpty
                                              ? Image.asset(
                                                  'assets/images/categoria.jpg',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.memory(
                                                  selectedImagenInBytes!,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Selección de archivo de icono
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              botonIcono = "Cargando";
                                            });
                                            _selectIconC(true);
                                          },
                                          child: Container(
                                            width: 180,
                                            height: 50,
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                botonIcono,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Vista previa del icono seleccionado
                                        if (iconBytes != null)
                                          Image.memory(
                                            iconBytes!,
                                            width: 50,
                                            height: 50,
                                          )
                                        else
                                          const Text(
                                            'No se ha seleccionado ningun icono',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontFamily: 'CedarvilleCursive',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        const SizedBox(
                                          height: defaultPadding,
                                        ),
                                        // Información sobre el proceso de carga de imágenes
                                        const Text(
                                          'Cuando seleccione una imagen, por favor, espere un momento mientras se carga en nuestro servidor. Después de la carga exitosa, haga clic en el botón Guardar ubicado al final del formulario para efectuar los cambios.',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'CedarvilleCursive',
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
            // Verifica si el ancho de la pantalla es menor o igual a 950 o es igual a 1024
          } else if (responsive.maxWidth <= 950 ||
              responsive.maxWidth == 1024) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  height: responsive.maxWidth > 1024 ? 600 : 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: Row(
                    children: [
                      // Vista previa de la imagen seleccionada
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5))),
                          child: selectCFile.isEmpty
                              ? Image.asset(
                                  'assets/images/categoria.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  selectedImagenInBytes!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Categoria',
                                  style: TextStyle(
                                      fontFamily: 'CedarvilleCursive',
                                      fontSize: 40,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 30),
                                // Formulario de edición de categoría
                                Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        // Campo de texto para el nombre de la categoría
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2.0),
                                              child: TextFormField(
                                                onChanged: (val) {
                                                  _categoriaController.value =
                                                      _categoriaController.value
                                                          .copyWith(text: val);
                                                },
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                controller:
                                                    _categoriaController,
                                                obscureText: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  labelStyle: const TextStyle(
                                                      fontSize: 13),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  hintText: 'Categoria',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black),
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                ),
                                                // Validación del campo
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Se requiere de este campo";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Selección de archivo de imagen
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              botonImagen = "Cargando";
                                            });
                                            _selectFileC(true);
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 50,
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFA810),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                botonImagen,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Selección de archivo de icono
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              botonIcono = "Cargando";
                                            });
                                            _selectIconC(true);
                                          },
                                          child: Container(
                                            width: 180,
                                            height: 50,
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                botonIcono,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Vista previa del icono seleccionado
                                        if (iconBytes != null)
                                          Image.memory(
                                            iconBytes!,
                                            width: 100,
                                            height: 100,
                                          )
                                        else
                                          const Text(
                                            'No se ha seleccionado ningun icono',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontFamily: 'CedarvilleCursive',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        const SizedBox(
                                          height: defaultPadding,
                                        ),
                                        // Información sobre el proceso de carga de imágenes
                                        const Text(
                                          'Cuando seleccione una imagen, por favor, espere un momento mientras se carga en nuestro servidor. Después de la carga exitosa, haga clic en el botón Guardar ubicado al final del formulario para efectuar los cambios.',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'CedarvilleCursive',
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          }
          // Vista por defecto
          return Center(
            child: Container(
              width: 950,
              height: 550,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: Row(
                children: [
                  // Vista previa de la imagen seleccionada
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(5))),
                      child: selectCFile.isEmpty
                          ? Image.asset(
                              'assets/images/categoria.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.memory(
                              selectedImagenInBytes!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Categoria',
                              style: TextStyle(
                                  fontFamily: 'CedarvilleCursive',
                                  fontSize: 40,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 30),
                            // Formulario de edición de categoría
                            Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    // Campo de texto para el nombre de la categoría
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2.0, right: 2.0),
                                          child: TextFormField(
                                            onChanged: (val) {
                                              _categoriaController.value =
                                                  _categoriaController.value
                                                      .copyWith(text: val);
                                            },
                                            style: const TextStyle(
                                                color: Colors.black),
                                            controller: _categoriaController,
                                            obscureText: false,
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              labelStyle:
                                                  const TextStyle(fontSize: 13),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              hintText: 'Categoria',
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              fillColor: Colors.grey[200],
                                              filled: true,
                                            ),
                                            // Validación del campo
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Se requiere de este campo";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Selección de archivo de imagen
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          botonImagen = "Cargando";
                                        });
                                        _selectFileC(true);
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFA810),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            botonImagen,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Selección de archivo de icono
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          botonIcono = "Cargando";
                                        });
                                        _selectIconC(true);
                                      },
                                      child: Container(
                                        width: 180,
                                        height: 50,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            botonIcono,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Vista previa del icono seleccionado
                                    if (iconBytes != null)
                                      Image.memory(
                                        iconBytes!,
                                        width: 100,
                                        height: 100,
                                      )
                                    else
                                      const Text(
                                        'No se ha seleccionado ningun icono',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'CedarvilleCursive',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    // Información sobre el proceso de carga de imágenes
                                    const Text(
                                      'Cuando seleccione una imagen, por favor, espere un momento mientras se carga en nuestro servidor. Después de la carga exitosa, haga clic en el botón Guardar ubicado al final del formulario para efectuar los cambios.',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'CedarvilleCursive',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
      // Botón para editar la categoría
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Función para editar la categoría
            editCategory();
          }
        },
        label: Text(
          'Guardar',
          style: TextStyle(
              color: isDark ? primaryColor : Colors.black,
              fontSize: 17,
              fontFamily: 'CedarvilleCursive'),
        ),
        icon: Icon(
          Icons.save,
          color: isDark ? primaryColor : Colors.black,
        ),
      ),
    );
  }
}
