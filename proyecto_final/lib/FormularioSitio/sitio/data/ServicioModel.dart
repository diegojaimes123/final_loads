// ignore_for_file: file_names

// Clase para seleccionar los servicios desde la vista de usuario
class ServicioModel {
  String name; //Nombre del servicio
  String icono; // Icono del servicio
  bool isSelected; // si esta seleccionado
  String descripcion; // descripción del servicio

  ServicioModel(
      {required this.name,
      required this.icono,
      required this.isSelected,
      required this.descripcion});
}

//lista de los servicios
List<ServicioModel> servicio = [
  ServicioModel(
      name: 'Wifi',
      icono: 'assets/servicios/wifi.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Piscina',
      icono: 'assets/servicios/piscina.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Cocina',
      icono: 'assets/servicios/cocina.png',
      isSelected: false,
      descripcion: "Los huéspedes pueden cocinar en este espacio"),
  ServicioModel(
      name: 'Un Jacuzzi',
      icono: 'assets/servicios/jacuzzi.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Jabón Corporal',
      icono: 'assets/servicios/jabon.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Shampoo',
      icono: 'assets/servicios/shampoo.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Nevera Surtida',
      icono: 'assets/servicios/nevera.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Minibar Surtido',
      icono: 'assets/servicios/minibar.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Microondas',
      icono: 'assets/servicios/microondas.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Parrilla',
      icono: 'assets/servicios/parrilla.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Cafetera',
      icono: 'assets/servicios/cafetera.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Entrada Autónoma',
      icono: 'assets/servicios/llave.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Agua Caliente',
      icono: 'assets/servicios/ducha.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Aire Acondicionado',
      icono: 'assets/servicios/aireA.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Lavadora secadora',
      icono: 'assets/servicios/lavadora.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Televisión o cable',
      icono: 'assets/servicios/tv.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: 'Chimenea',
      icono: 'assets/servicios/chimenea.png',
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Estacionamiento",
      icono: "assets/servicios/estacionamiento.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Buena iluminacion",
      icono: "assets/servicios/iluminacion.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Area para trabajar",
      icono: "assets/servicios/trabajo.png",
      isSelected: false,
      descripcion: "En un espacio compartido"),
  ServicioModel(
      name: "Articulos de oficina",
      icono: "assets/servicios/articulos.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Cámaras de seguridad en la propiedad",
      icono: "assets/servicios/camaraseg.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Se permite dejar el equipaje",
      icono: "assets/servicios/maleta.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Toalla por huésped",
      icono: "assets/servicios/toalla.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Una almohada por huésped",
      icono: "assets/servicios/almohada.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Sabanas para cada camas",
      icono: "assets/servicios/sabana.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Productos de limpieza",
      icono: "assets/servicios/limpieza.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Ropa de cama",
      icono: "assets/servicios/ropa1.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Cocina equipada",
      icono: "assets/servicios/cocina1.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Secador de pelo",
      icono: "assets/servicios/secador.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Plancha con tabla",
      icono: "assets/servicios/plancha.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Detector de humo",
      icono: "assets/servicios/humo.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Detector de monóxido de carbono",
      icono: "assets/servicios/dioxido.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Extintor de incendios",
      icono: "assets/servicios/extintor.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Botiquin primeros auxilios",
      icono: "assets/servicios/botiquin.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Asiento para niños",
      icono: "assets/servicios/asiento.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Juegos de mesa",
      icono: "assets/servicios/juegos.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Bicicletas gratuitas",
      icono: "assets/servicios/bici.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Gimnasio",
      icono: "assets/servicios/gym.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Sauna",
      icono: "assets/servicios/sauna.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Patio o terraza",
      icono: "assets/servicios/patio.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicio de limpieza diario",
      icono: "assets/servicios/servi.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Vista al lago",
      icono: "assets/servicios/lago.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Vista al mar",
      icono: "assets/servicios/mar.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Caja de seguridad",
      icono: "assets/servicios/caja.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicio de consejeria",
      icono: "assets/servicios/consejeria.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Mascotas permitidas",
      icono: "assets/servicios/mascotas.png",
      isSelected: false,
      descripcion: "No hay restricciones respecto los animales de asistencia"),
  ServicioModel(
      name: "Alquiler de coches",
      icono: "assets/servicios/alquiler.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Guia turistica/local",
      icono: "assets/servicios/guia.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicio de niñera",
      icono: "assets/servicios/ninheras.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Instrumentos musicales",
      icono: "assets/servicios/musica.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Tours personalizados",
      icono: "assets/servicios/tours.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Jardin privado",
      icono: "assets/servicios/jardin.png",
      isSelected: false,
      descripcion:
          "Un espacio abierto en la propiedad generalmente cubierto de pasto"),
  ServicioModel(
      name: "Cuna",
      icono: "assets/servicios/cuna.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicios de catering",
      icono: "assets/servicios/catering.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Sistema de sonido",
      icono: "assets/servicios/sonido.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicio de streaming",
      icono: "assets/servicios/stri.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Kit de bienvenida",
      icono: "assets/servicios/kit.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Servicio de barco",
      icono: "assets/servicios/bar.png",
      isSelected: false,
      descripcion: ""),
  ServicioModel(
      name: "Descuetos en restaurantes",
      icono: "assets/servicios/restaurantes.png",
      isSelected: false,
      descripcion: ""),
];
