// ignore_for_file: file_names

import 'package:flutter/material.dart';

// Modelo para la información de la reserva
class ReservaInfoModel {
  final String? svgSrc, title, totalReservas;
  final int? percentage;
  final Color? color;

  // Constructor de la clase ReservaInfoModel
  ReservaInfoModel({
    this.svgSrc, // Ruta del archivo SVG (opcional)
    this.title, // Título de la información de la reserva (opcional)
    this.totalReservas, // Total de reservas (opcional)
    this.percentage, // Porcentaje (opcional)
    this.color, // Color (opcional)
  });
}
