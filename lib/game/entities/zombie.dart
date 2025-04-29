import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'player.dart';

class Zombie extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final Player player;
  final double speed;
  final Vector2 _mapSize;

  Zombie({
    required this.player,
    required Vector2 initialPosition,
    required Vector2 mapSize,
    this.speed = 100,
  }) : _mapSize = mapSize {
    position = initialPosition;
    size = Vector2(64, 64);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    sprite = await gameRef.loadSprite('zumbi1.png');
    
    add(RectangleHitbox(
      collisionType: CollisionType.active,
    )..debugMode = false);

    // Efeito de pulsação
    final pulseEffect = SequenceEffect([
      ScaleEffect.to(
        Vector2(1.1, 1.1),
        EffectController(duration: 0.5, repeatCount: 1),
      ),
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.5, repeatCount: 1),
      )
    ],
    infinite: true);
    
    add(pulseEffect);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    final direction = (player.position - position).normalized();
    position.add(direction * speed * dt);
    angle = direction.angleTo(Vector2(1, 0));
    
    if (position.x < 0 || position.y < 0 || 
        position.x > _mapSize.x || position.y > _mapSize.y) {
      removeFromParent();
    }
  }
}