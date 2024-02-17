// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_final/details/components/confirmacionPago.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

import '../models/ip/local.dart';

// Enumerador para representar el estado del reconocimiento facial
enum DetectionStatus { noFace, fail, success }

// Clase principal que representa la pantalla de reconocimiento facial
class ReconocimientoFacialR extends StatefulWidget {
  // Propiedades que reciben la información para hacer la reserva
  final ThemeManager themeManager;
  final SitioModel sitio;
  final String fechaEntrada;
  final String fechaSalida;
  final String totalHuespedes;
  final int valorDias;
  final int valorTotal;
  final int totalNoches;
  final String numeroAdultos;
  final String numeroNinos;
  final String numeroBebes;
  final String numeroMascotas;
  final int usuario;

  const ReconocimientoFacialR({
    super.key,
    required this.themeManager,
    required this.sitio,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.totalHuespedes,
    required this.valorDias,
    required this.valorTotal,
    required this.totalNoches,
    required this.numeroAdultos,
    required this.numeroNinos,
    required this.numeroBebes,
    required this.numeroMascotas,
    required this.usuario,
  });

  @override
  State<ReconocimientoFacialR> createState() => _ReconocimientoFacialRState();
}

class _ReconocimientoFacialRState extends State<ReconocimientoFacialR> {
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

  // Método para realizar la autenticación y registrar la reserva
  Future logInR2() async {
    // URL del servidor para el registro de reservas
    String url = "";

    // Configurar la URL según la plataforma (Android o no Android)
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Reservas/";
    } else {
      url = "http://127.0.0.1:8000/api/Reservas/";
    }

    // Cabeceras y cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "usuario": widget.usuario,
      "fecha":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "fechaEntrada": widget.fechaEntrada,
      "fechaSalida": widget.fechaSalida,
      "numHuespedes": widget.totalHuespedes,
      "numAdultos": widget.numeroAdultos,
      "numNinos": widget.numeroNinos == "" ? null : widget.numeroNinos,
      "numBebes": widget.numeroBebes == "" ? null : widget.numeroBebes,
      "numMascotas": widget.numeroMascotas == "" ? null : widget.numeroMascotas,
      "precioFinal": widget.valorTotal,
      "estado": "Pendiente",
      "comision": widget.sitio.comision,
      "gananciaAnfitrion": (widget.valorTotal -
          widget.sitio.comision -
          (widget.valorTotal * 0.19).toInt()),
      "sitio": widget.sitio.id,
    };

    int resultado = 0;

    try {
      // Realizar la solicitud HTTP para el registro de la reserva
      final response = await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el resultado según la respuesta del servidor
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      print(e);
    }

    // Si el registro es exitoso, navegar a la pantalla de confirmación de pago
    if (resultado == 201) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConfirmacionPago(
            themeManager: widget.themeManager,
            sitioModel: widget.sitio,
            fechaEntrada: widget.fechaEntrada,
            fechaSalida: widget.fechaSalida,
            totalHuespedes: widget.totalHuespedes,
            totalNoches: widget.totalNoches,
            valorDias: widget.valorDias,
            valorTotal: widget.valorTotal,
          ),
        ),
      );
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

  // Método para comprimir la imagen antes de enviarla al servidor
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

    // Construir la interfaz de la pantalla de reconocimiento facial
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
              // Si el reconocimiento facial es exitoso, realizar la autenticación y registro de la reserva
              if (status == DetectionStatus.success) {
                logInR2();
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
