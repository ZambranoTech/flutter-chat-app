import 'package:chat/Infrastructure/models/mensajes_response.dart';
import 'package:chat/presentation/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';

class ChatMessageMapper {

  static ChatMessage messageToChatMessage(Mensaje message, AnimationController animationController) => ChatMessage(
    texto: message.mensaje, 
    uid: message.de, 
    animationController: animationController
  );

}