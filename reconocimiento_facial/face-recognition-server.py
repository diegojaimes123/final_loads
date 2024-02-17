import asyncio
import websockets
import json
import io
import face_recognition


async def websocket_handler(websocket, path):
    try:
        async for message in websocket:
            # Llamada a la función recognize_face para procesar el mensaje recibido y enviar la respuesta
            response = recognize_face(message)
            await websocket.send(json.dumps(response))
    except Exception as e:
        print(f"WebSocket Error: {str(e)}")


def recognize_face(message):
    try:
        # Cargar y codificar el rostro de referencia en tiempo real
        my_picture = face_recognition.load_image_file(io.BytesIO(message))
        my_face_encodings = face_recognition.face_encodings(my_picture)

        if len(my_face_encodings) == 0:
            return {"status": True, "message": "No Face Detected in Reference Image", "data": 0}

        # Cargar y codificar la imagen desconocida
        unknown_picture = face_recognition.load_image_file(io.BytesIO(message))
        unknown_face_encodings = face_recognition.face_encodings(
            unknown_picture)

        if len(unknown_face_encodings) == 0:
            return {"status": True, "message": "No Face Detected in Unknown Image", "data": 0}

        # Comparar con todas las caras detectadas en la imagen desconocida
        for unknown_face_encoding in unknown_face_encodings:
            results = face_recognition.compare_faces(
                my_face_encodings, unknown_face_encoding)
            if results and results[0] == True:
                return {"status": True, "message": "Face Detected, Access Granted", "data": 2}

        # Si no se encuentra coincidencia con ninguna cara en la imagen desconocida, denegar el acceso
        return {"status": True, "message": "No Match Found, Access Denied", "data": 1}

    except Exception as e:
        # Manejo de errores y devolución de un mensaje de error
        return {"status": False, "message": str(e)}


if __name__ == '__main__':
    # Configuración y ejecución del servidor de WebSockets
    loop = asyncio.get_event_loop()
    loop.run_until_complete(
        websockets.serve(websocket_handler, "0.0.0.0", 8765)
    )
    loop.run_forever()
