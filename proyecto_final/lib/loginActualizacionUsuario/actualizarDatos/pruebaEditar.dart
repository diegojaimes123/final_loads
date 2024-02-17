// ignore_for_file: file_names, no_logic_in_create_state, avoid_print

// Importaciones necesarias
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_final/LoginUsuario/Login/desplegables.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:proyecto_final/loginActualizacionUsuario/actualizarContrasena/LoginContrasena.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// ignore: must_be_immutable
class PruebaEditar extends StatefulWidget {
  // Controladores para los campos de descripción, teléfono e idioma
  TextEditingController descripcion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController idioma = TextEditingController();
  PruebaEditar(
      {Key? key,
      required this.descripcion,
      required this.telefono,
      required this.idioma})
      : super(key: key);

  @override
  State<PruebaEditar> createState() => _PruebaEditarState(
      descripcion: descripcion, telefono: telefono, idioma: idioma);
}

class _PruebaEditarState extends State<PruebaEditar> {
  // Controladores para los campos de descripción, teléfono e idioma
  TextEditingController descripcion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController idioma = TextEditingController();
  _PruebaEditarState(
      {required this.descripcion,
      required this.telefono,
      required this.idioma});

  // Variable que indica si se desea agregar una descripción
  bool addDescription = false;

  // Formato del teléfono con la cantidad de dígitos permitidos
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Texto de bienvenida
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Actualizar Datos',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'DelaGothicOne',
                        color: Colors.white),
                  ),
                ),
                // Descripción adicional
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 30),
                  child: Text(
                    '¡Actualiza tus datos y no te pierdas la oportunidad de disfrutar las mejores vacaciones de tu vida! ¡Hazlo ahora y vive la experiencia al máximo!',
                    style: TextStyle(fontSize: 12, color: Colors.white
                        //fontFamily: 'DelaGothicOne'
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Campo de entrada para el teléfono
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
                      telefono.value = telefono.value.copyWith(text: val);
                    },
                    style: const TextStyle(color: Colors.black),
                    inputFormatters: [
                      inputtelefono
                    ], //LLamado de la variable que admite la cantidad de digitos que se pueden agregar a este textfield,
                    controller: telefono,
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Telefono',
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    //Este es el validador que me dice si el campo ya esta digitado o no
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de un numero de telefono';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Campo de entrada para el idioma
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
                      idioma.value = idioma.value.copyWith(text: val);
                    },
                    style: const TextStyle(color: Colors.black),
                    controller: idioma,
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
                      hintText: 'Idioma',
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Se requiere de este campo';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Interruptor para agregar una descripción
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
                    child: SwitchListTile(
                      title: const Text('¿Quieres agregar una descripcion?'),
                      value:
                          addDescription, //boolean para el accedo a una descripcion
                      onChanged: (bool? value) {
                        //cambio de estado de la boolean
                        setState(() {
                          if (value != null) {
                            addDescription = value;
                          }
                        });
                      },
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //Si la variable anterior es true aparece este campo para la descripcion
            if (addDescription)
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
                        descripcion.value =
                            descripcion.value.copyWith(text: val);
                      },
                      style: const TextStyle(color: Colors.black),
                      controller: descripcion,
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
                        hintText: 'Descripcion',
                        hintStyle: const TextStyle(color: Colors.black),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere de este campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30)
          ]),
    );
  }
}

//Primera vista

// ignore: must_be_immutable
class PruebaEditar2 extends StatefulWidget {
  // Controladores de texto para los campos del formulario
  TextEditingController nombreCompleto = TextEditingController();
  TextEditingController tipoDocumento = TextEditingController();
  TextEditingController numeroDocumento = TextEditingController();
  PruebaEditar2(
      {Key? key,
      required this.nombreCompleto,
      required this.tipoDocumento,
      required this.numeroDocumento})
      : super(key: key);

  @override
  State<PruebaEditar2> createState() => _PruebaEditar2State(
      // Pasando los controladores al estado
      nombreCompleto: nombreCompleto,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento);
}

class _PruebaEditar2State extends State<PruebaEditar2> {
  // Controladores de texto en el estado
  TextEditingController nombreCompleto = TextEditingController();
  TextEditingController tipoDocumento = TextEditingController();
  TextEditingController numeroDocumento = TextEditingController();
  _PruebaEditar2State(
      {required this.nombreCompleto,
      required this.tipoDocumento,
      required this.numeroDocumento});

  String? cedula; // Variable para el valor seleccionado en el DropdownButton

  bool addDescription = false;

  // Formateador de texto para el campo del número de documento
  var documento = MaskTextInputFormatter(
      mask: "# ### ### ###", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de bienvenida
          const SizedBox(height: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Títulos y descripciones
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Actualizar Datos',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'DelaGothicOne',
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  '¡Actualiza tus datos y no te pierdas la oportunidad de disfrutar las mejores vacaciones de tu vida! ¡Hazlo ahora y vive la experiencia al máximo!',
                  style: TextStyle(fontSize: 12, color: Colors.white
                      //fontFamily: 'DelaGothicOne'
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Campo de Nombre Completo
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
                    nombreCompleto.value =
                        nombreCompleto.value.copyWith(text: val);
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: nombreCompleto,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Nombre Completo',
                    hintStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  validator: (String? value) {
                    // Validación del campo
                    if (value == null || value.isEmpty) {
                      return 'Se requiere de este campo';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // DropdownButton para Tipo de Documento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                // Configuración del DropdownButton
                isExpanded: true,
                hint: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tipo de Documento',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: options
                    .map((item) => DropdownMenuItem<String>(
                          value: item.valor,
                          child: Text(
                            item.titulo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: tipoDocumento.text,
                onChanged: (String? value) {
                  setState(() {
                    cedula = value;
                    tipoDocumento.text = cedula!;
                  });
                  if (cedula == null || cedula!.isEmpty) {
                    return;
                  }
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Campo de Número de Documento
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
                    numeroDocumento.value =
                        numeroDocumento.value.copyWith(text: val);
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: numeroDocumento,
                  inputFormatters: [documento],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: InputBorder.none,
                    hintText: 'Numero de Documento',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                  ),
                  validator: (String? value) {
                    // Validación del campo
                    if (value == null || value.isEmpty) {
                      return 'Se requiere de este campo';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

//Tercera vista
// ignore: must_be_immutable
class PruebaEditar3 extends StatefulWidget {
  // Controladores de texto para los campos del formulario
  TextEditingController tipoBanco = TextEditingController();
  TextEditingController cuentaBancaria = TextEditingController();
  TextEditingController numeroDaviplata = TextEditingController();
  PruebaEditar3(
      {Key? key,
      required this.tipoBanco,
      required this.cuentaBancaria,
      required this.numeroDaviplata})
      : super(key: key);

  @override
  State<PruebaEditar3> createState() => _PruebaEditar3State(
      // Pasando los controladores al estado
      tipoBanco: tipoBanco,
      cuentaBancaria: cuentaBancaria,
      numeroDaviplata: numeroDaviplata);
}

class _PruebaEditar3State extends State<PruebaEditar3> {
  // Constructor que recibe los controladores como parámetros
  _PruebaEditar3State(
      {required this.tipoBanco,
      required this.cuentaBancaria,
      required this.numeroDaviplata});

  String?
      selectedValue; // Variable para el valor seleccionado en el DropdownButton

  // Controladores de texto en el estado
  TextEditingController tipoBanco = TextEditingController();
  TextEditingController cuentaBancaria = TextEditingController();
  TextEditingController numeroDaviplata = TextEditingController();

  // Mascara para el número de telefono
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sección de bienvenida y descripción
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Actualizar Datos',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'DelaGothicOne',
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  '¡Actualiza tus datos y no te pierdas la oportunidad de disfrutar las mejores vacaciones de tu vida! ¡Hazlo ahora y vive la experiencia al máximo!',
                  style: TextStyle(fontSize: 12, color: Colors.white
                      //fontFamily: 'DelaGothicOne'
                      ),
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  'Usted se registrará como usuario y anfitrión. Solicitamos sus datos bancarios para realizar los respectivos pagos en caso de que ofrezca un sitio para alquilar. También, en caso de que cancele una reserva, estos datos nos ayudarán a hacer la respectiva devolución de su dinero.',
                  style: TextStyle(fontSize: 12, color: Colors.white
                      //fontFamily: 'DelaGothicOne'
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // DropdownButton para seleccionar el banco
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Banco',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item.valor,
                          child: Text(
                            item.titulo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: tipoBanco.text,
                onChanged: (String? value) {
                  // Actualización del valor seleccionado
                  setState(() {
                    selectedValue = value;
                    tipoBanco.text = selectedValue!;
                  });

                  if (selectedValue == null || selectedValue!.isEmpty) {
                    return;
                  }
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Campo de Cuenta Bancaria
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
                    cuentaBancaria.value =
                        cuentaBancaria.value.copyWith(text: val);
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: cuentaBancaria,
                  keyboardType: TextInputType.number,
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
                    hintText: '0000 0000 0000 0000',
                    hintStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Campo de Número de Daviplata
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
                    numeroDaviplata.value =
                        numeroDaviplata.value.copyWith(text: val);
                  },
                  style: const TextStyle(color: Colors.black),
                  inputFormatters: [inputtelefono],
                  keyboardType: TextInputType.number,
                  controller: numeroDaviplata,
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
                    hintText: 'Numero de Daviplata',
                    hintStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

//Cuarta vista

// ignore: must_be_immutable
class PruebaEditar4 extends StatefulWidget {
  // Controladores de texto para los campos del formulario
  final ThemeManager themeManager;
  TextEditingController contrasenha = TextEditingController();
  TextEditingController confirmacionContasenha = TextEditingController();
  PruebaEditar4(
      {Key? key,
      required this.contrasenha,
      required this.confirmacionContasenha,
      required this.themeManager})
      : super(key: key);

  @override
  State<PruebaEditar4> createState() => _PruebaEditar4State(
      // Pasando los controladores al estado
      contrasenha: contrasenha,
      confirmacionContasenha: confirmacionContasenha);
}

class _PruebaEditar4State extends State<PruebaEditar4> {
  // Controladores de texto en el estado
  TextEditingController contrasenha = TextEditingController();
  TextEditingController confirmacionContasenha = TextEditingController();

  _PruebaEditar4State(
      {required this.contrasenha, required this.confirmacionContasenha});

  // inicialización de las variables para dar fomato password a los campos de la contraseña
  late bool _obscure = true;
  late bool _obscure2 = true;

  // Verificar si la nueva contraseña y la confirmación de esta son iguales
  bool passwordConfirmed() {
    if (contrasenha.text.trim() == confirmacionContasenha.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sección de bienvenida y descripción
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Actualizar Datos',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'DelaGothicOne',
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  '¡Actualiza tus datos y no te pierdas la oportunidad de disfrutar las mejores vacaciones de tu vida! ¡Hazlo ahora y vive la experiencia al máximo!',
                  style: TextStyle(fontSize: 12, color: Colors.white
                      //fontFamily: 'DelaGothicOne'
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Campo de Contraseña
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
                  // Configuración del campo de texto con opción para ocultar/mostrar contraseña
                  style: const TextStyle(color: Colors.black),
                  controller: contrasenha,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Contraseña',
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                      //prefixIcon: Icon(Icons.visibility_off),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Campo de Confirmación de Contraseña
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
                  // Configuración del campo de texto con opción para ocultar/mostrar contraseña
                  style: const TextStyle(color: Colors.black),
                  controller: confirmacionContasenha,
                  obscureText: _obscure2,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirmacion de Contraseña',
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.grey[200],
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(_obscure2
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscure2 = !_obscure2;
                          });
                        },
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                // verificación para que se cumpla la función de igualdad de contraseñas y si alguno de los campos de nueva contraseña y verificar contraseña estan vacios.
                if (passwordConfirmed() &&
                    contrasenha.text.trim() != "" &&
                    confirmacionContasenha.text.trim() != "") {
                  // Ir a cambio de contraseña
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginContrasenaPage(
                              themeManager: widget.themeManager,
                              contrasena: contrasenha.text.trim(),
                            )),
                  );
                }
              },
              child: Container(
                width: 300,
                height: 60,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Cambiar Contraseña',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Quinta vista
// ignore: must_be_immutable
class PruebaEditar5 extends StatefulWidget {
  // Controladores de texto para los campos del formulario
  TextEditingController celularController = TextEditingController();
  TextEditingController imagenController = TextEditingController();

  PruebaEditar5(
      {Key? key,
      required this.celularController,
      required this.imagenController})
      : super(key: key);

  @override
  State<PruebaEditar5> createState() =>
      _PruebaEditar5State(celularController: celularController);
}

class _PruebaEditar5State extends State<PruebaEditar5> {
  // Controlador de texto para el campo de teléfono celular
  TextEditingController celularController = TextEditingController();

  _PruebaEditar5State({required this.celularController});

  // Formateador de entrada para el número de teléfono
  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  String selectFile = '';
  Uint8List? selectedImagenInBytes;
  int imagenCounts = 0;
  List<Uint8List> pickedImagesBytes = [];
  String foto = '';
  String imageUrl = '';
  String botonImagen = 'Seleccionar foto de perfil';

  // Método para seleccionar una imagen
  _selectFile(bool imagenFrom) async {
    // verifica si el controlador de la imagen esta vacio
    if (widget.imagenController.text != "") {
      // borra foto anterior de firestorage
      firabase_storage.Reference storageReferenceFoto = firabase_storage
          .FirebaseStorage.instance
          .refFromURL(widget.imagenController.text);

      await storageReferenceFoto.delete();
    }

    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        selectedImagenInBytes = fileResult.files.first.bytes;
      });
    }
    // Subir la imagen y obtener la URL
    final url = await _uploadFile();
    print(url);
    print(selectFile);
    setState(() {
      botonImagen = "Listo";
    });
  }

  // Método para subir la imagen a Firebase Storage y obtener la URL
  Future<String> _uploadFile() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('user')
          .child('/$selectFile');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putData(selectedImagenInBytes!, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
      // Actualizar el controlador de texto con la URL de la imagen
      setState(() {
        widget.imagenController.text = imageUrl;
      });
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // mensaje de bienvenida y descripciones
          const SizedBox(height: 50),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Actualizar Datos',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'DelaGothicOne',
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  '¡Actualiza tus datos y no te pierdas la oportunidad de disfrutar las mejores vacaciones de tu vida! ¡Hazlo ahora y vive la experiencia al máximo!',
                  style: TextStyle(fontSize: 12, color: Colors.white
                      //fontFamily: 'DelaGothicOne'
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Campo de Teléfono Celular
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
                  // Configuración del campo de texto con formato de teléfono
                  onChanged: (val) {
                    celularController.value =
                        celularController.value.copyWith(text: val);
                  },
                  style: const TextStyle(color: Colors.black),
                  inputFormatters: [inputtelefono],
                  keyboardType: TextInputType.number,
                  controller: celularController,
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
                    hintText: 'Télefono Celular',
                    hintStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  validator: (String? value) {
                    // validar campo
                    if (value == null || value.isEmpty) {
                      return 'Se requiere de este campo';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Vista previa de la imagen seleccionada
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: selectFile.isEmpty
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        "assets/images/logo3.jpg",
                      ),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(selectedImagenInBytes!),
                    )),
          const SizedBox(height: 20),
          // Botón para seleccionar una imagen
          GestureDetector(
            onTap: () async {
              setState(() {
                botonImagen = "Cargando";
              });
              _selectFile(true);
            },
            child: Container(
              width: 300,
              height: 60,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  botonImagen,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          // Mensaje informativo sobre la carga de la foto de perfil
          const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 25, right: 30),
              child: Text(
                'Cuando seleccione su foto de perfil, por favor, espere un momento mientras se carga en nuestro servidor. Asegúrese de desplazarse hasta el final de este formulario y guardar los cambios para que la nueva foto de perfil se aplique correctamente. Si no completa este paso, la imagen seleccionada no será guardada como su nueva foto de perfil.',
                style: TextStyle(fontSize: 12, color: Colors.white
                    //fontFamily: 'DelaGothicOne'
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
