import 'package:flame/components.dart';
import 'package:flame/game.dart';

class InfiniteBackground extends SpriteComponent with HasGameRef<FlameGame> {
  @override
  Future<void> onLoad() async {
    // Carrega o sprite do fundo
    sprite = await gameRef.loadSprite('background.png');

    // Define o tamanho e a posição do fundo
    size = gameRef.size * 1.5; // Ajusta o tamanho do fundo
    position = Vector2.zero(); // Define a posição inicial como (0, 0)
  }
}