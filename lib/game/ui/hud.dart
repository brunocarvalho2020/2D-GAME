import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Hud extends PositionComponent {
  Hud() : super(priority: 100); // Deixa o HUD sempre na frente

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // 'await' é o ideal no onLoad!

    position = Vector2(10, 10); // Posição no canto superior esquerdo

    final textComponent = TextComponent(
      text: 'HP: 100',
      textRenderer: TextPaint(
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    )..anchor = Anchor.topLeft; // âncora para alinhar melhor no topo/esquerda

    add(textComponent);
  }
}
