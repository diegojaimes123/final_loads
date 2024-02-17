// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chat/Pages/CustomCard.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';

class ChatPageU extends StatefulWidget {
  const ChatPageU({super.key});

  @override
  State<ChatPageU> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageU> {
  late UsuariosModel miusuario; // Usuario actual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getUsuario(), // Llama todos los usuarios
          builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario) {
            if (usuario.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtienen los datos del usuario
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Encuentra el usuario actual en la lista de usuarios
            for (var s = 0; s < usuario.data!.length; s++) {
              if (FirebaseAuth.instance.currentUser!.email ==
                  usuario.data![s].correoElectronico) {
                miusuario = usuario.data![s];
              }
            }

            // Construye una lista de tarjetas personalizadas para cada usuario
            return ListView.builder(
              itemCount: usuario.data!.length,
              itemBuilder: (context, index) => CustomCard(
                usuario: usuario.data![index],
                usuarioLogin: miusuario,
              ),
            );
          }),
    );
  }
}
