import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.texto, 
    required this.uid, 
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    // Ajusta la luminosidad según tus preferencias
    HSLColor hslColor = HSLColor.fromColor(colors.primary);
    hslColor = hslColor.withLightness(0.5);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == '3' 
          ? _MyMessage(hslColor: hslColor, texto: texto)
          : _NotMyMessage(texto: texto),
        ),
      ),
    );

  }
}

class _NotMyMessage extends StatelessWidget {
  const _NotMyMessage({
    required this.texto,
  });

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 50, bottom: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300]
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black), ),
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  const _MyMessage({
    required this.hslColor,
    required this.texto,
  });

  final HSLColor hslColor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(left: 50, bottom: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: hslColor.toColor()
          ),
          child: Text(texto, style: const TextStyle(color: Colors.white), ),
        ),
     );
  }
}