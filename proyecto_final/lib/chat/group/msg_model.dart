// La clase MsgModel es un modelo simple utilizado para representar los mensajes en el chat
class MsgModel {
  String type; // Tipo de mensaje (ownMsg o otherMsg)
  String msg; // Contenido del mensaje
  String sender; // Remitente del mensaje
  MsgModel({required this.type, required this.msg, required this.sender});
}
