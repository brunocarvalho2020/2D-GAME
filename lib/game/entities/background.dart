import 'package:flame/components.dart';
import 'package:flame/game.dart';

class InfiniteBackground extends SpriteComponent with HasGameRef<FlameGame> {
  @override
  Future<void> onLoad() async {
    // Carrega o sprite do fundo
    sprite = await gameRef.loadSprite('background.png');

    // Define o tamanho e a posição do fundo
    // Define o tamanho exato da imagem (1024x1024)
    size = Vector2(1024, 1024);
    position = Vector2.zero(); // Define a posição inicial como (0, 0)
    anchor = Anchor.topLeft;
  }
}
