// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_final/models/CardsReservasModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

// Diseño de la card del conteo de las reservas las cuales estaran ubicadas en la parte superior de los dashboard

class FileInfoCard extends StatelessWidget {
  // Recibe como parametro el objeto reserva info model
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final ReservaInfoModel info;

  @override
  Widget build(BuildContext context) {
    // verifica el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Construción de la carta
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn),
                ),
              ),
              Icon(
                Icons.more_vert,
                color: isDark ? Colors.white54 : primaryColor,
              ),
            ],
          ),
          // Titulo
          Text(
            info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Línea de progreso
          ProgressLine(
            color: info.color,
            percentage: info.percentage,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: isDark ? Colors.white70 : primaryColor),
              ),
              // Total
              Text(
                info.totalReservas!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: isDark ? Colors.white70 : primaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Linea de progreso la cual recibe el color correspondiente a la reserva y
// la cantidad del procentaje de las reservas hechas por el usuario
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        // Promedio del total de las reservas
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
