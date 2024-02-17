// ignore_for_file: file_names, no_logic_in_create_state, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:proyecto_final/loginActualizacionUsuario/actualizarDatos/ClasesEditar.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class LoginEditarPage extends StatefulWidget {

  final UsuariosModel usuario;

  final ThemeManager themeManager;

  const LoginEditarPage({Key? key, required this.themeManager, required this.usuario}) : super(key: key);

  @override
  State<LoginEditarPage> createState() => _LoginEditarPageState(themeManager);
}

class _LoginEditarPageState extends State<LoginEditarPage> with SingleTickerProviderStateMixin {

  final ThemeManager themeManager;

  late int index;

  late bool imagen = true;

  @override
  void dispose() {
    super.dispose();
  }

  _LoginEditarPageState(this.themeManager);

  @override
  Widget build(BuildContext context) {
    //Widget que almacena las diferentes vistas del responsive
    return LayoutBuilder(
        builder: (context, responsive){
          // Verificar si el ancho de la pantalla es igual a 375
          if(responsive.maxWidth == 375){
            //Este condicional es para la imagen que dependiendo donde este ubicado en el tab asi mismo sera la imagen
            return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Color(0x73606060),
                      image: DecorationImage(
                          image: AssetImage(
                              //imagen ? '../images/imagen6.jpg' : '../images/imagen7.jpg',
                              'assets/images/imagen5.jpg'
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        color: Color(0x27000000)
                    ),
                    // ir al formulario para editar los datos del usuario
                    child: LoginEditar(themeManager: widget.themeManager, usuario: widget.usuario,),
                  )
                )
            );
            // Verificar si el ancho de la pantalla es igual o menor a 300
          }else if (responsive.maxWidth <= 300){
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                            'assets/images/imagen5.jpg'
                        ),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Color(0x27000000)
                  ),
                  // ir al formulario para editar los datos del usuario
                  child: LoginEditar(themeManager: widget.themeManager, usuario: widget.usuario,),
                )
              )
            );
            // Verificar si el ancho de la pantalla es igual o menor a 500
          }else if(responsive.maxWidth <= 500){
            return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                              'assets/images/imagen5.jpg'
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Color(0x27000000)
                    ),
                    // ir al formulario para editar los datos del usuario
                    child: LoginEditar(themeManager: widget.themeManager, usuario: widget.usuario,),
                  )
                )
            );
            // Verificar si el ancho de la pantalla es igual o mayor a 1000
          }else if(responsive.maxWidth >=1000){
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      //imagen ? '../images/imagen8.jpg' : '../images/imagen7.jpg'
                        'assets/images/imagen5.jpg'
                    ),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Color(0x27000000)
                  ),
                  // ir al formulario para editar los datos del usuario
                  child: LoginEditar(themeManager: widget.themeManager, usuario: widget.usuario,),
                )
              )
            );
            // Vista por defecto
          } else{
            return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              //imagen ? '../images/imagen4.jpg' : '../images/imagen5.jpg'
                              'assets/images/imagen5.jpg'
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        color: Color(0x27000000)
                    ),
                    // ir al formulario para editar los datos del usuario
                    child: LoginEditar(themeManager: widget.themeManager, usuario: widget.usuario,),
                  )
                )
            );
          }
        }
    );
  }
}

