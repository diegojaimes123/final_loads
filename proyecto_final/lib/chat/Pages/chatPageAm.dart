// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chat/Pages/CustomCard.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';

class ChatPageAm extends StatefulWidget {
  const ChatPageAm({
    super.key,
  });

  @override
  State<ChatPageAm> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageAm> {
  List<UsuariosModel> administradores = []; // Lista de administradores

  late UsuariosModel miusuario; // Usuario actual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          // FutureBuilder para obtener datos de usuarios
          future: getUsuario(),
          builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario) {
            if (usuario.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtienen los datos de usuarios
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            for (var s = 0; s < usuario.data!.length; s++) {
              if (FirebaseAuth.instance.currentUser!.email ==
                  usuario.data![s].correoElectronico) {
                // Encuentra el usuario actual
                miusuario = usuario.data![s];
              }
            }

            for (var u = 0; u < usuario.data!.length; u++) {
              if (usuario.data![u].rolAdmin != false &&
                  usuario.data![u].id != miusuario.id) {
                // Agrega los administradores a la lista (evita el usuario actual)
                administradores.add(usuario.data![u]);
              }
            }

            // Construye una lista de tarjetas personalizadas para cada administrador
            return ListView.builder(
              itemCount: administradores.length,
              itemBuilder: (context, index) => CustomCard(
                usuario: administradores[index],
                usuarioLogin: miusuario,
              ),
            );
          }),
    );
  }
}
