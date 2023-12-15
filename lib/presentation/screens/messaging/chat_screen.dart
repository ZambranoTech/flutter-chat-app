import 'dart:io';

import 'package:chat/Infrastructure/mappers/chat_message_mapper.dart';
import 'package:chat/Infrastructure/models/mensajes_response.dart';
import 'package:chat/presentation/providers/providers.dart';
import 'package:chat/presentation/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  List<ChatMessage> messages = [];

  late ChatProvider chatProvider;
  late SocketProvider socketProvider;
  late AuthProvider authProvider;


  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>(); 
    socketProvider = context.read<SocketProvider>(); 
    authProvider = context.read<AuthProvider>(); 

    _cargarHistorial(chatProvider.usuarioPara.uid);

    socketProvider.socket.on('mensaje-personal', (data)  {
      _escucharMensaje(data);
    });

  }

  _cargarHistorial( String usuarioID ) async {
    List<Mensaje> chat = await chatProvider.getChat(usuarioID);
    
    final history = chat.map((message) { 
      final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward();
      return ChatMessageMapper.messageToChatMessage(message, animationController);
      }
    ).toList();

    setState(() {
      messages.insertAll(0, history);
    });

  } 

  void _escucharMensaje ( dynamic payload ) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
    );

    setState(() {
      messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  void dispose() {
    // TODO: Off del socket

    for (ChatMessage message in messages) {
      message.animationController.dispose();
    }

    socketProvider.socket.off('mensaje-personal');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(chatProvider.usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            Text(chatProvider.usuarioPara.nombre, style: const TextStyle(fontSize: 12, color: Colors.black87))
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => messages[index],
              reverse: true,
            )
          ),
          const Divider(height: 1, thickness: 0.6,),
          _InputChat(addMessage: _addMessage, socketProvider: socketProvider, authProvider: authProvider, chatProvider: chatProvider,)

        ],
      ),
    );
  }

  _addMessage(message) {
    setState(() {
      final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
      messages.insert(0, ChatMessage(
        texto: message, 
        uid: authProvider.usuario.uid, 
        animationController: animationController
      ));
      animationController.forward();
    });
  }
}

class _InputChat extends StatefulWidget {

  final Function(String) addMessage;

  final ChatProvider chatProvider;
  final SocketProvider socketProvider;
  final AuthProvider authProvider;

  const _InputChat({
    required this.addMessage, required this.socketProvider, required this.authProvider, required this.chatProvider
  });


  @override
  State<_InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<_InputChat> {

  final _textController = TextEditingController(); 
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    // Ajusta la luminosidad según tus preferencias
    HSLColor hslColor = HSLColor.fromColor(colors.primary);
    hslColor = hslColor.withLightness(0.5);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _onSubmitted,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                    _estaEscribiendo = true;
                    return;
                  }
                  _estaEscribiendo = false;
                  });
                },
                focusNode: _focusNode,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje',
                ),
              )
            ),

            
            Container(
              child: Platform.isAndroid 
                ? IconTheme(
                  data: IconThemeData(color: hslColor.toColor()),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: _estaEscribiendo 
                      ? () => _onSubmitted(_textController.text)
                      : null, 
                    icon: const Icon(Icons.send_sharp)),
                  )
                  
                : CupertinoButton(
                  onPressed: _estaEscribiendo 
                      ? () => _onSubmitted(_textController.text)
                      : null,
                  child: const Text('Enviar'), 
                )

            )
          ],
        ),
      ),
    );
  }

  _onSubmitted(String text) {
    _focusNode.requestFocus();

    if (text.trim().isEmpty) return;

    _textController.clear();

    widget.addMessage(text);
    
    setState(() {
      _estaEscribiendo = false;
    });

    widget.socketProvider.emit('mensaje-personal', {
      'de': widget.authProvider.usuario.uid,
      'para': widget.chatProvider.usuarioPara.uid,
      'mensaje': text
    });
  }
}