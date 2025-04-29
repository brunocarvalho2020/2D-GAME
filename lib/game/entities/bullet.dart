import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';

class Bullet extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final Vector2 direction;
  final double speed;
  final double damage;
  
  Bullet({
    required Vector2 position,
    required this.direction,
    this.speed = 500,
    this.damage = 1,
    Vector2? size,
  }) : super(
          position: position,
          size: size ?? Vector2(20, 10),
          priority: 100, // Garante que fique acima do background
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    sprite = await gameRef.loadSprite('bullet.png');
    anchor = Anchor.center;
    
    // Ajusta a posição inicial para sair da "boca" do personagem
    position.add(direction.normalized() * 5); // 5 pixels à frente do centro
    
    add(RectangleHitbox(
      collisionType: CollisionType.active,
    )..debugMode = false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction.normalized() * speed * dt);
    
    // Verificação de limites simplificada
    if (position.x < -100 || 
        position.y < -100 || 
        position.x > gameRef.size.x + 100 || 
        position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }
}