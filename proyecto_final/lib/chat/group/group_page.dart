// ignore_for_file: library_prefixes, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:proyecto_final/chat/group/msg_model.dart';
import 'package:proyecto_final/chat/msg_widget/other_msg_widget.dart';
import 'package:proyecto_final/chat/msg_widget/own_msg_widget.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/models/ip/local.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:universal_platform/universal_platform.dart';

class GroupPage extends StatefulWidget {
  final String name; // Nombre del usuario actual
  final String userId; // ID del usuario actual
  final UsuariosModel usuario; // Información del usuario del chat
  final UsuariosModel usuarioLogin; // Información del usuario que inició sesión
  const GroupPage(
      {super.key,
      required this.name,
      required this.userId,
      required this.usuario,
      required this.usuarioLogin});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  FocusNode focusNode = FocusNode();
  IO.Socket? socket; // Socket para la comunicación en tiempo real
  List<MsgModel> listMsg = []; // Lista de mensajes en el chat
  TextEditingController _msgController =
      TextEditingController(); // Controlador para el campo de entrada de mensajes

  @override
  void initState() {
    super.initState();
    connect(); // Establecer conexión con el servidor de sockets
    loadPreviousMessages(); // Cargar mensajes anteriores al iniciar la página
  }

  void loadPreviousMessages() {
    // Emitir evento al servidor para cargar mensajes anteriores
    socket!.emit("getMessages", {
      "username": widget.userId,
      "othername": widget.usuario.id,
    });
  }

  void connect() {
    String url = "";

    // Configurar la URL del servidor de sockets según la plataforma
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:3000";
    } else {
      url = "http://127.0.0.1:3000";
    }

    // Inicializar el socket y conectar
    socket = IO.io(url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    // Configurar manejo de eventos cuando el socket se conecta
    socket!.onConnect((_) {
      print("connected into frontend");
      // Manejar eventos de recepción de mensajes del servidor
      socket!.on("sendMsgServer", (msg) {
        print(msg);
        if (msg["userId"] != widget.userId) {
          setState(() {
            listMsg.add(
              MsgModel(
                type: msg["type"],
                msg: msg["msg"],
                sender: msg["senderName"],
              ),
            );
          });
        }
      });

      // Manejar evento de carga de mensajes anteriores
      socket!.on("loadMessages", (messages) {
        List<MsgModel> loadedMessages = [];

        for (var msg in messages) {
          if ((msg["userid"] == widget.userId &&
                  msg["otherid"] == widget.usuario.id.toString()) ||
              (msg["userid"] == widget.usuario.id.toString() &&
                  msg["otherid"] == widget.userId)) {
            if (msg["userid"] == widget.userId) {
              loadedMessages.add(
                MsgModel(
                  type: msg["type"],
                  msg: msg["content"],
                  sender: msg["username"],
                ),
              );
            } else {
              loadedMessages.add(
                MsgModel(
                  type: "otherMsg",
                  msg: msg["content"],
                  sender: msg["username"],
                ),
              );
            }
          }
        }

        // Añadir mensajes anteriores a la lista
        setState(() {
          listMsg.addAll(loadedMessages);
        });
      });
    });
  }

  void sendMsg(String msg, String senderName) {
    // Enviar mensaje propio al servidor y actualizar la interfaz de usuario
    MsgModel ownMsg = MsgModel(type: "ownMsg", msg: msg, sender: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "userId": widget.userId,
      "otherId": widget.usuario.id,
    });
  }

  void deleteConversation() {
    // Emitir un evento al servidor para borrar la conversación
    socket!.emit('deleteConversation', {
      "userid": widget.userId,
      "otherid": widget.usuario.id,
    });

    // Limpiar la lista
    setState(() {
      listMsg.clear();
    });
  }

  // Liberar recursos y destruir el widget
  @override
  void dispose() {
    _msgController.dispose();
    socket!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Verificar el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        // Configuración de la barra de aplicación
        leadingWidth: 70,
        titleSpacing: 0,
        foregroundColor: Colors.grey,
        backgroundColor: isDark ? secondaryColor : Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          // Se acomoda la información del usuario receptor
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: primaryColor,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: widget.usuario.foto == ""
                    ? const Image(
                        image: AssetImage("assets/images/foto.png"),
                        height: 36,
                        width: 36,
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        widget.usuario.foto,
                        width: 36,
                        height: 36,
                        fit: BoxFit.fill,
                      ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.usuario.nombreCompleto,
                  style: const TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Botón de borrar conversación en la barra de aplicación
          IconButton(
              onPressed: () {
                deleteConversation();
              },
              icon: const Icon(
                Icons.delete,
                color: primaryColor,
              )),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
                itemCount: listMsg.length,
                itemBuilder: (context, index) {
                  if (listMsg[index].type == "ownMsg") {
                    // Widget para mostrar mensajes propios
                    return OnwMsgWidget(
                        sender: listMsg[index].sender, msg: listMsg[index].msg);
                  } else {
                    // Widget para mostrar mensajes de otros
                    return OtherMsgWidget(
                        sender: listMsg[index].sender, msg: listMsg[index].msg);
                  }
                }),
          ),
          // Campo de entrada de mensajes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                        bottom: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        cursorColor: primaryColor,
                        controller: _msgController,
                        focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        style: const TextStyle(color: Colors.grey),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escribir Mensaje...",
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                // Botón de enviar mensaje
                IconButton(
                  onPressed: () {
                    String msg = _msgController.text;
                    if (msg.isNotEmpty) {
                      sendMsg(msg, widget.name);
                      _msgController.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
