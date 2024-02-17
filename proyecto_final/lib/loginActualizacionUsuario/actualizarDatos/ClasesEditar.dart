// ignore_for_file: prefer_final_fields, file_names, unnecessary_overrides, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/loginActualizacionUsuario/actualizarDatos/pruebaEditar.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import '../../models/ip/local.dart';

// ignore: must_be_immutable
class LoginEditar extends StatefulWidget {
  //Para poder editar el usuario se recibe un objeto en especifico tipo usuario model
  final UsuariosModel usuario;
  final ThemeManager themeManager;
  const LoginEditar(
      {Key? key, required this.themeManager, required this.usuario})
      : super(key: key);

  @override
  State<LoginEditar> createState() => _LoginEditarState();
}

class _LoginEditarState extends State<LoginEditar>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      //Aqui al igual ya es responsive atravez de los condicionales
      // Valida si el ancho de la pantalla es igual a 375
      if (responsive.maxWidth == 375) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // comunicación al formulario para editar usuario
                    Expanded(
                      flex: 5,
                      child: RegisterEditar(
                        themeManager: widget.themeManager,
                        usuario: widget.usuario,
                      ),
                    ),
                  ],
                )));
      } else if (responsive.maxWidth <= 300) {
        // Valida si el ancho de la pantalla es igual o menor a 300
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            child: Container(
                decoration: BoxDecoration(
                  color: //Colors.black,
                      const Color(0x20D2D2D2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // comunicación al formulario para editar usuario
                    Expanded(
                      child: RegisterEditar(
                        themeManager: widget.themeManager,
                        usuario: widget.usuario,
                      ),
                    ),
                  ],
                )));
      } else if (responsive.maxWidth <= 500) {
        // Valida si el ancho de la pantalla es igual o menor a 500
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // comunicación al formulario para editar usuario
                    Expanded(
                        flex: 5,
                        child: RegisterEditar(
                          themeManager: widget.themeManager,
                          usuario: widget.usuario,
                        )),
                  ],
                )));
      } else if (responsive.maxWidth >= 1000) {
        // Valida si el ancho de la pantalla es igual o mayor a 1000
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 30.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'StayAway',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontFamily: 'CroissantOne'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Text(
                            "Descubre destinos inexplorados, "
                            "vive experiencias únicas y crea recuerdos que "
                            "durarán toda la vida. ¡Únete a la comunidad viajera "
                            "y haz realidad tus sueños de viaje!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'CroissantOne'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0x20D2D2D2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // comunicación al formulario para editar usuario
                            Expanded(
                                flex: 6,
                                child: RegisterEditar(
                                  themeManager: widget.themeManager,
                                  usuario: widget.usuario,
                                )),
                          ],
                        )))
              ],
            ));
        // Vista por defecto
      } else {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    // comunicación al formulario para editar usuario
                    Expanded(
                        flex: 5,
                        child: RegisterEditar(
                          themeManager: widget.themeManager,
                          usuario: widget.usuario,
                        )),
                  ],
                )));
      }
    });
  }
}

//Clase del para el formulario de editar usuario
class RegisterEditar extends StatefulWidget {
  final UsuariosModel usuario;
  final ThemeManager themeManager;
  const RegisterEditar(
      {Key? key, required this.themeManager, required this.usuario})
      : super(key: key);

  @override
  State<RegisterEditar> createState() => _RegisterEditarState();
}

class _RegisterEditarState extends State<RegisterEditar> {
  PageController? controller; // controlador

  int currentIndex = 0; //inicializacion de la lista

  double porcentaje = 0.20; //porcentaje del circulo de progreso de las vistas

  List<Vistas> listaVistas = <Vistas>[];

  late bool validacionColor =
      true; //variable del color del circulo de progreso de las vistas

  //funcion void de las vistas que estan en la lista
  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
    _vistasregister(widget.themeManager);
  }

  // Controladores ya cargados con la información del usuario
  late TextEditingController _nombreCompletoController =
      TextEditingController(text: widget.usuario.nombreCompleto);
  late TextEditingController _tipoDocumentoController =
      TextEditingController(text: widget.usuario.tipoDocumento);
  late TextEditingController _numeroDocumentoController =
      TextEditingController(text: widget.usuario.numeroDocumento);
  late TextEditingController _telefonoController =
      TextEditingController(text: widget.usuario.telefono);
  late TextEditingController _idiomaController =
      TextEditingController(text: widget.usuario.idioma);
  late TextEditingController _descripcionController =
      TextEditingController(text: widget.usuario.descripcion);
  late TextEditingController _tipoBancoController =
      TextEditingController(text: widget.usuario.banco);
  late TextEditingController _cuentaBancariaController =
      TextEditingController(text: widget.usuario.numeroCuenta);
  late TextEditingController _numeroDaviplataController =
      TextEditingController(text: widget.usuario.daviplata);
  late TextEditingController _celularController =
      TextEditingController(text: widget.usuario.telefonoCelular);
  late TextEditingController _imagenController =
      TextEditingController(text: widget.usuario.foto);
  late TextEditingController _emailController =
      TextEditingController(text: widget.usuario.correoElectronico);
  late TextEditingController _fechaController =
      TextEditingController(text: widget.usuario.fechaRegistro);
  TextEditingController _contrasenhaController = TextEditingController();
  TextEditingController _confirmacionContasenhaController =
      TextEditingController();

  //Esta variable es para la validacion de los formularios
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // mascara para el número de documento y para el telefono fijo
  var documento = MaskTextInputFormatter(
      mask: "# ### ### ###", filter: {"#": RegExp(r'[0-9]')});

  var inputtelefono = MaskTextInputFormatter(
      mask: "### ### ####", filter: {"#": RegExp(r'[0-9]')});

  // Función asincrónica para actualizar los detalles del usuario.
  Future updateUser() async {
    try {
      // Llamada a la función para agregar o editar detalles del usuario.
      final respuesta = await addUserEditDetails(
        _nombreCompletoController.text.trim(),
        _tipoDocumentoController.text.trim(),
        _numeroDocumentoController.text.trim(),
        _emailController.text.trim(),
        _telefonoController.text.trim(),
        _celularController.text.trim(),
        _idiomaController.text.trim(),
        _imagenController.text.trim(),
        _descripcionController.text.trim(),
        _tipoBancoController.text.trim(),
        _cuentaBancariaController.text.trim(),
        _numeroDaviplataController.text.trim(),
        _fechaController.text.trim(),
      );

      // Verifica si la respuesta es exitosa (código 200) y navega a la pantalla de inicio.
      if (respuesta == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreenPage(
                  themeManager: widget.themeManager,
                )));
      }
    } catch (e) {
      // Manejo de excepciones: imprime la excepción en la consola.
      print(e);
    }
  }

  // Función para agregar o editar detalles del usuario en el servidor.
  Future<int> addUserEditDetails(
    String nombreCompleto,
    String tipoDocumento,
    String numeroDocumento,
    String email,
    String telefono,
    String celular,
    String idioma,
    String imagen,
    String descripcion,
    String banco,
    String numCuenta,
    String daviplata,
    String fecha,
  ) async {
    String url = "";

    // URL del servidor según la plataforma (Android o no Android).
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Usuarios/";
    } else {
      url = "http://127.0.0.1:8000/api/Usuarios/";
    }

    // Encabezados y cuerpo de la solicitud HTTP.
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    // Datos del usuario a enviar al servidor.
    final Map<String, dynamic> dataBody = {
      "nombreCompleto": nombreCompleto,
      "tipoDocumento": tipoDocumento,
      "numeroDocumento": numeroDocumento,
      "correoElectronico": email,
      "telefono": telefono,
      "telefonoCelular": celular,
      "idioma": idioma,
      "foto": imagen,
      "rolAdmin": widget.usuario.rolAdmin,
      "descripcion": descripcion,
      "banco": banco,
      "numeroCuenta": numCuenta,
      "daviplata": daviplata,
      "fechaRegistro": fecha,
    };

    // Inicializa el resultado a 0.
    int resultado = 0;

    try {
      // Realiza una solicitud PUT al servidor con los detalles del usuario.
      final response = await http.put(
        Uri.parse("$url${widget.usuario.id}/"),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualiza el resultado con el código de estado de la respuesta.
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      // Manejo de excepciones: imprime la excepción en la consola.
      print(e);
    }

    // Devuelve el código de resultado de la operación.
    return resultado;
  }

  // Liberar recursos y limpiar controladores cuando se destruye el widget.
  @override
  void dispose() {
    _nombreCompletoController.dispose();
    _tipoDocumentoController.dispose();
    _numeroDocumentoController.dispose();
    _telefonoController.dispose();
    _celularController.dispose();
    _idiomaController.dispose();
    _imagenController.dispose();
    _descripcionController.dispose();
    _tipoBancoController.dispose();
    _cuentaBancariaController.dispose();
    _numeroDaviplataController.dispose();
    _contrasenhaController.dispose();
    _confirmacionContasenhaController.dispose();
    _fechaController.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 6, //tamaño de la vista
        child: PageView.builder(
            controller: controller,
            itemCount: listaVistas.length, //recorre la longitud de la lista
            onPageChanged: (int index) {
              //condicional para el aumento del porcentaje del progreso en el circulo
              if (index >= currentIndex) {
                setState(() {
                  currentIndex = index;
                  porcentaje += 0.20;
                });
              } else {
                setState(() {
                  currentIndex = index;
                  porcentaje -= 0.20;
                });
              }
            },
            itemBuilder: (context, index) {
              return Container(
                child: listaVistas[index].vista1, //Llmado de las vistas
              );
            }),
      ),
      //Aqui va el boton
      Expanded(
          flex: 1,
          child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: CircularProgressIndicator(
                      value: porcentaje,
                      backgroundColor: Colors.grey,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(porcentaje <= 0.20
                              ? Colors.yellow
                              : porcentaje <= 0.60
                                  ? Colors.lightGreen
                                  : porcentaje > 0.60
                                      ? Colors.green
                                      : Colors.white),
                      //Aqui evalua el color del boton dependiendo el porcentaje
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor:
                        validacionColor ? Colors.white : Colors.green,
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  //condicional que evalua los textfield si esta correcto puede avanzar a la siguiente pagina
                  if (currentIndex == listaVistas.length - 1) {
                    //condiiconal de las vistas
                    validacionColor; //color
                    if (porcentaje == 1) {
                      //condicional que cuando llegue a 1 podra actualizar el usuario
                      updateUser();
                    }
                  }
                  //animacion al pasar la pagina
                  controller!.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              }))
    ]);
  }

  //Lista dentro de la funcion void
  void _vistasregister(ThemeManager thememanager) {
    var lista = <Vistas>[
      //Primera vista
      Vistas(
        vista1: Form(
            key: formKey, //Variable para la validacion del formulario
            //Lo hice en una clase diferente
            child: Row(
              children: [
                Expanded(
                  child: PruebaEditar2(
                      //Paso de parametros
                      nombreCompleto: _nombreCompletoController,
                      tipoDocumento: _tipoDocumentoController,
                      numeroDocumento: _numeroDocumentoController),
                ),
              ],
            )),
      ),
      //segunda vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: PruebaEditar(
                descripcion: _descripcionController,
                telefono: _telefonoController,
                idioma: _idiomaController,
              ),
            )
          ],
        ),
      )),
      //Tercera vista
      Vistas(
        vista1: Form(
            key: formKey,
            child: Expanded(
              child: PruebaEditar3(
                  tipoBanco: _tipoBancoController,
                  cuentaBancaria: _cuentaBancariaController,
                  numeroDaviplata: _numeroDaviplataController),
            )),
      ),
      //Cuarta vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Expanded(
          child: PruebaEditar5(
              celularController: _celularController,
              imagenController: _imagenController),
        ),
      )),
      //Quinta Vista
      Vistas(
          vista1: Form(
        key: formKey,
        child: Expanded(
            child: PruebaEditar4(
                themeManager: thememanager,
                contrasenha: _contrasenhaController,
                confirmacionContasenha: _confirmacionContasenhaController)),
      )),
    ];
    setState(() {
      listaVistas = lista;
    });
  }
}

// Clase para representar las vistas en el formulario de actualización
class Vistas {
  Widget vista1;

  Vistas({required this.vista1});
}
