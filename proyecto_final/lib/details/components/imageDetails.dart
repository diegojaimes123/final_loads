// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:proyecto_final/details/components/imageGallery.dart';
import 'package:proyecto_final/models/ImagenModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class ImageButton extends StatelessWidget {
  // parametros para almacenar el sitio
  final SitioModel sitio;

  const ImageButton({
    super.key,
    required this.sitio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(),
      // Botón para ver la galeria completa
      TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageGallery(
                        sitio: sitio,
                      )),
            );
          },
          icon: const Icon(
            Icons.image,
            color: primaryColor,
          ),
          label: const Text(
            "Ver todas las fotos",
            style: TextStyle(color: primaryColor),
          )),
      Container(),
    ]);
  }
}

class ImagesDetails extends StatelessWidget {
  // parametros para poder realizar y llamar funciones en la vista de detalles
  final SitioModel sitio;

  const ImagesDetails({
    super.key,
    required this.sitio,
  });

  @override
  Widget build(BuildContext context) {
    // Lista para almacenar las imagenes
    List<String> listaImagen = [];

    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: FutureBuilder(
              future: getImagen(), // traer las imagenes del servidor
              builder: (context, AsyncSnapshot<List<ImagenModel>> imagen) {
                // mientras trae la información
                if (imagen.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // mira si hay imagenes relacionadas al sitio
                for (var h = 0; h < imagen.data!.length; h++) {
                  if (sitio.id == imagen.data![h].sitio) {
                    listaImagen.add(imagen.data![h].direccion);
                  }
                }

                // Collage el cual ubicara las imagenes encontradas
                return MasonryGridView.count(
                    // columnas del collage dependiendo el ancho del dispositivo
                    crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // Expandir la imagen en cuestión
                        child: InstaImageViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              listaImagen[index],
                              fit: BoxFit.fill,
                              height: (index % 5 + 1) * 100,
                            ),
                          ),
                        ),
                      );
                    });
              })),
    ));
  }
}
