import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/game.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Jogo ocupa toda a tela
            Positioned.fill(
              child: GameWidget(
                game: MyGame(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}