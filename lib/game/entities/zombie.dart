import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'player.dart';

class Zombie extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final Player player;
  final double speed;
  final Vector2 _mapSize;
  bool _facingRight = true;
  int health = 2;
  final double _repulsionForce = 30; // Força de repulsão entre zumbis
  final List<Vector2> _collisionOffsets = [];

  Zombie({
    required this.player,
    required Vector2 initialPosition,
    required Vector2 mapSize,
    this.speed = 100,
  }) : _mapSize = mapSize {
    position = initialPosition;
    size = Vector2(50, 50);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('zumbi1.png');

    add(
      RectangleHitbox(collisionType: CollisionType.active, isSolid: true)
        ..debugMode = false,
    );

    // Efeito de pulsação
    final pulseEffect = SequenceEffect([
      ScaleEffect.to(
        Vector2(1.1, 1.1),
        EffectController(duration: 0.5, repeatCount: 1),
      ),
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.5, repeatCount: 1),
      ),
    ], infinite: true);

    add(pulseEffect);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final direction = (player.position - position).normalized();

    // Aplica repulsão de outros zumbis
    if (_collisionOffsets.isNotEmpty) {
      final repulsion = _calculateRepulsion();
      position.add(repulsion * _repulsionForce * dt);
    }

    position.add(direction * speed * dt);

    // Atualiza a direção que o zumbi está olhando
    if (direction.x.abs() > 0.1) {
      // Evita flicker quando o valor é muito pequeno
      _facingRight = direction.x > 0;
    }

    // Aplica a escala para "virar" o sprite sem rotacioná-lo
    scale = Vector2(_facingRight ? 1 : -1, 1);

    // Verifica se saiu dos limites do mapa
    if (position.x < 0 ||
        position.y < 0 ||
        position.x > _mapSize.x ||
        position.y > _mapSize.y) {
      removeFromParent();
    }
    _collisionOffsets.clear();
  }

  Vector2 _calculateRepulsion() {
    Vector2 totalOffset = Vector2.zero();
    for (final offset in _collisionOffsets) {
      totalOffset += offset;
    }
    return totalOffset.normalized();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Zombie) {
      // Calcula a direção de repulsão
      final collisionVector = (position - other.position).normalized();
      _collisionOffsets.add(collisionVector);
    }
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      _die();
    } else {
      // Efeito visual ao levar dano (opcional)
    }
  }

  void _die() {
    // Efeito de morte (opcional)
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.2),
        onComplete: () => removeFromParent(),
      ),
    );

    // - Som de morte
    // - Partículas de explosão
    // - Pontuação para o jogador
  }
}
