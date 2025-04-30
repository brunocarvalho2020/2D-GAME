import 'dart:ui';

import 'package:flame/components.dart';
import '../ui/joystick.dart';
import '../ui/joystick_shoot.dart';
import 'bullet.dart';
import '../game.dart';
import 'package:flame/collisions.dart';
import 'zombie.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final JoystickPlayer joystickMove;
  final JoystickShoot joystickShoot;
  Vector2 _shootDirection = Vector2(1, 0);
  double _shootTimer = 0;
  final double _shootInterval = 0.2;
  late Vector2 mapSize;
  bool _facingRight = true;

  Player(this.joystickMove, this.joystickShoot);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(50, 50);
    anchor = Anchor.center;

    // Corrigindo o tamanho do mapa para usar o tamanho do background (1024x1024)
    mapSize = Vector2(1024, 1024);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Movimentação (joystick esquerdo)
    Vector2 moveDelta = joystickMove.relativeDelta * 200 * dt;
    Vector2 newPosition = position + moveDelta;

    newPosition.x = newPosition.x.clamp(0, mapSize.x - size.x);
    newPosition.y = newPosition.y.clamp(0, mapSize.y - size.y);
    position = newPosition;

    // Controle de tiro (joystick direito)
    if (!joystickShoot.isIdle) {
      _shootDirection = joystickShoot.shootDirection; // Usando o novo getter

      // Atualiza a direção que o personagem está olhando
      if (_shootDirection.x.abs() > 0.1) {
        // Evita flicker quando o valor é muito pequeno
        _facingRight = _shootDirection.x > 0;
      }

      _shootTimer += dt;
      if (_shootTimer >= _shootInterval) {
        _shootTimer = 0;
        _shoot();
      }
    }

    scale = Vector2(_facingRight ? 1 : -1, 1);
  }

  void _shoot() {
    final shootPosition = position + (_shootDirection * 35);

    final bullet =
        Bullet(
            worldBounds: Rect.fromLTWH(0, 0, 1024, 1024),
            position: shootPosition,
            direction: _shootDirection,
            speed: 600,
          )
          ..anchor = Anchor.center
          ..priority = 10;

    (gameRef as MyGame).bulletLayer.add(bullet);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Zombie) {
      // Lógica de dano ao jogador
    }
  }
}
