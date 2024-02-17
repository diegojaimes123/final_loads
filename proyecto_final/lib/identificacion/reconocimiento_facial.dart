// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as img;

// Enumerador para representar el estado del reconocimiento facial
enum DetectionStatus { noFace, fail, success }

class ReconocimientoFacial extends StatefulWidget {
  //Propiedades para almacenar los datos para iniciar sesión
  final ThemeManager themeManager;

  final String email;

  final String contrasena;

  const ReconocimientoFacial(
      {super.key,
      required this.themeManager,
      required this.email,
      required this.contrasena});

  @override
  State<ReconocimientoFacial> createState() => _ReconocimientoFacialState();
}

class _ReconocimientoFacialState extends State<ReconocimientoFacial> {
  // Controlador de la cámara
  CameraController? controller;
  // Canal de WebSocket para la comunicación en tiempo real
  late WebSocketChannel channel;
  // Estado de detección facial actual
  DetectionStatus? status;

  // Getter para obtener la representación gráfica del estado actual
  String get currentStatus {
    if (status == null) {
      return "assets/icons/pendiente.svg";
    }
    switch (status!) {
      case DetectionStatus.noFace:
        return "assets/icons/persona.svg";
      case DetectionStatus.fail:
        return "assets/icons/cancel.svg";
      case DetectionStatus.success:
        return "assets/icons/check.svg";
    }
  }

  // Getter para obtener el color asociado al estado actual
  Color get currentStatusColor {
    if (status == null) {
      return Colors.grey;
    }
    switch (status!) {
      case DetectionStatus.noFace:
        return Colors.grey;
      case DetectionStatus.fail:
        return Colors.red;
      case DetectionStatus.success:
        return Colors.greenAccent;
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializar la cámara y el WebSocket al cargar la pantalla
    initializeCamera();
    initializeWebSocket();
  }

  // Método para realizar la autenticación y navegar a la pantalla principal
  Future logInV2() async {
    try {
      // Intentar iniciar sesión utilizando Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.contrasena,
      );

      // Verificar si la autenticación fue exitosa
      if (userCredential.user != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreenPage(
                  themeManager: widget.themeManager,
                )));
      }
    } catch (e) {
      // Capturar y mostrar el error en caso de falla de autenticación
      print(e);
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('StayAway'),
              content: const Text('Error al verificar credenciales.'),
              actions: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Cerrar'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreenPage(
                                  themeManager: widget.themeManager,
                                )));
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    }
  }

  // Inicializar la cámara
  Future<void> initializeCamera() async {
    // Obtener la lista de cámaras disponibles
    final cameras = await availableCameras();
    // Seleccionar la primera cámara (cámara trasera)
    final firstCamera = cameras[0]; // back 0th index & front 1st index

    // Inicializar el controlador de la cámara
    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // Inicializar la cámara y actualizar la interfaz
    await controller!.initialize();
    setState(() {});

    // Configurar un temporizador para tomar una foto cada 3 segundos y enviarla al servidor
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        // Tomar una foto y comprimirla antes de enviarla al servidor
        final image = await controller!.takePicture();
        final compressedImageBytes = compressImage(image.path);
        channel.sink.add(compressedImageBytes);
      } catch (_) {}
    });
  }

  // Inicializar el canal de WebSocket para la comunicación en tiempo real
  void initializeWebSocket() {
    // Conectar al servidor WebSocket
    // 0.0.0.0 -> 10.0.2.2 (emulator)
    channel = IOWebSocketChannel.connect('ws://10.0.2.2:8765');
    // Escuchar eventos del servidor WebSocket
    channel.stream.listen((dynamic data) {
      debugPrint(data);
      // Decodificar los datos y actualizar el estado de detección facial
      data = jsonDecode(data);
      if (data['data'] == null) {
        debugPrint('Server error occurred in recognizing face');
        return;
      }
      switch (data['data']) {
        case 0:
          status = DetectionStatus.noFace;
          break;
        case 1:
          status = DetectionStatus.fail;
          break;
        case 2:
          status = DetectionStatus.success;
          break;
        default:
          status = DetectionStatus.noFace;
          break;
      }
      // Actualizar la interfaz gráfica
      setState(() {});
    }, onError: (dynamic error) {
      debugPrint('Error: $error');
    }, onDone: () {
      debugPrint('WebSocket connection closed');
    });
  }

  // Comprimir una imagen utilizando la biblioteca image
  Uint8List compressImage(String imagePath, {int quality = 85}) {
    final image =
        img.decodeImage(Uint8List.fromList(File(imagePath).readAsBytesSync()))!;
    final compressedImage =
        img.encodeJpg(image, quality: quality); // lossless compression
    return compressedImage;
  }

  // Liberar recursos al salir de la pantalla
  @override
  void dispose() {
    controller?.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si la cámara está inicializada
    if (!(controller?.value.isInitialized ?? false)) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(controller!),
          ),
        ),
        Align(
          alignment: const Alignment(0, .85),
          child: GestureDetector(
            onTap: () {
              // Si el reconocimiento facial es exitoso, realizar la autenticación
              if (status == DetectionStatus.success) {
                logInV2();
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              // Mostrar el icono según el estado actual
              child: SvgPicture.asset(
                currentStatus,
                color: currentStatusColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
