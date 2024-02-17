// Clase para representar opciones de tipo de documento
class TipoDocumento {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  TipoDocumento(this.titulo, this.valor);
}

// Lista de opciones para el tipo de documento
final List options = [
  TipoDocumento("Cedula de Ciudadanía", "CC"),
  TipoDocumento("Cedula de Extranjería", "CE"),
  TipoDocumento("Pasaporte", "PAS"),
  TipoDocumento("Número de identificación tributaria", "NIT"),
];

// Clase para representar opciones de tipo de banco
class TipoBanco {
  final String? titulo, valor;

  // Constructor que inicializa el título y el valor de la opción
  TipoBanco(this.titulo, this.valor);
}

// Lista de opciones para el tipo de banco
final List items = [
  TipoBanco("BANCOLOMBIA", "BANCOLOMBIA"),
  TipoBanco("Banco de Bogotá", "Banco de Bogotá"),
  TipoBanco("Banco caja social", "Banco caja social"),
  TipoBanco("Av Villas", "Av Villas"),
  TipoBanco("Banco de occidente", "Banco de occidente"),
  TipoBanco("Banco Popular", "Banco Popular"),
  TipoBanco("Banco Agrario", "Banco Agrario"),
  TipoBanco("Davivienda", "Davivienda"),
  TipoBanco("Colpatria", "Colpatria"),
];
