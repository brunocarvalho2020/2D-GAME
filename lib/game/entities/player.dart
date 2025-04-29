import 'package:flame/components.dart';
import '../ui/joystick.dart';
import '../ui/joystick_shoot.dart';
import 'bullet.dart';
import '../game.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'zombie.dart';
import 'package:vector_math/vector_math.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final JoystickPlayer joystickMove;
  final JoystickShoot joystickShoot;
  Vector2 _shootDirection = Vector2(1, 0);
  double _shootTimer = 0;
  final double _shootInterval = 0.2;
  late Vector2 mapSize;

  Player(this.joystickMove, this.joystickShoot);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(64, 64);
    anchor = Anchor.center;
    mapSize = gameRef.size * 1.5;
    
    add(RectangleHitbox()
      ..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Movimentação (joystick esquerdo)
    Vector2 moveDelta = joystickMove.relativeDelta * 200 * dt;
    Vector2 newPosition = position + moveDelta;

    newPosition.x = newPosition.x.clamp(size.x/2, mapSize.x - size.x/2);
    newPosition.y = newPosition.y.clamp(size.y/2, mapSize.y - size.y/2);
    position = newPosition;

    // Controle de tiro (joystick direito)
    if (!joystickShoot.isIdle) {
      _shootDirection = joystickShoot.shootDirection; // Usando o novo getter
      
      _shootTimer += dt;
      if (_shootTimer >= _shootInterval) {
        _shootTimer = 0;
        _shoot();
      }
    }

    angle = _shootDirection.angleTo(Vector2(1, 0));
  }

  void _shoot() {
    final shootPosition = position + (_shootDirection * 35);
    
    final bullet = Bullet(
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