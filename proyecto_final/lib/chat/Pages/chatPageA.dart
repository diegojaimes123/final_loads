// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chat/Pages/CustomCard.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';

class ChatPageA extends StatefulWidget {
  const ChatPageA({super.key});

  @override
  State<ChatPageA> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageA> {
  List<UsuariosModel> misAnfitriones = []; // Lista de anfitriones relacionados

  late UsuariosModel miusuario; // Usuario actual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // FutureBuilder para obtener datos de reservas
        future: getReservas(),
        builder: (context, AsyncSnapshot<List<ReservaModel>> reserva) {
          if (reserva.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos de reservas
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder(
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

              // Usar un conjunto temporal para evitar duplicados
              Set<UsuariosModel> anfitrionesSet = {};

              // Itera sobre las reservas y usuarios para encontrar los anfitriones relacionados
              for (var u = 0; u < usuario.data!.length; u++) {
                for (var r = 0; r < reserva.data!.length; r++) {
                  if (reserva.data![r].estado == "Activo") {
                    if (reserva.data![r].sitio.usuario == usuario.data![u].id &&
                        reserva.data![r].usuario == miusuario.id) {
                      anfitrionesSet.add(usuario.data![u]);
                    }
                  }
                }
              }

              // Convertir el conjunto a lista al final
              misAnfitriones = anfitrionesSet.toList();

              // Construye una lista de tarjetas personalizadas para cada anfitrión
              return ListView.builder(
                itemCount: misAnfitriones.length,
                itemBuilder: (context, index) => CustomCard(
                  usuario: misAnfitriones[index],
                  usuarioLogin: miusuario,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
