import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:segundojogo/game/entities/zombie.dart';
import 'package:segundojogo/game/game.dart'; // Importe seu game.dart

class Bullet extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed;
  final int damage;
  final Rect worldBounds;

  Bullet({
    required this.worldBounds,
    required Vector2 position,
    required this.direction,
    this.speed = 600, // Velocidade ajustada para um valor mais razoável
    this.damage = 1,
    Vector2? size,
  }) : super(position: position, size: size ?? Vector2(10, 10), priority: 100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('bullet.png');
    anchor = Anchor.center;

    position.add(direction.normalized());

    add(
      RectangleHitbox(collisionType: CollisionType.passive)..debugMode = false,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction.normalized() * speed * dt);

    if (position.x < worldBounds.left - 100 ||
        position.y < worldBounds.top - 100 ||
        position.x > worldBounds.right + 100 ||
        position.y > worldBounds.bottom + 100) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Zombie) {
      other.takeDamage(damage);
      removeFromParent();
    }
  }
}
