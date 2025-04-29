import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class JoystickShoot extends JoystickComponent {
  bool get isIdle => direction == JoystickDirection.idle;

  JoystickShoot()
      : super(
          knob: CircleComponent(
            radius: 25,
            paint: Paint()
              ..color = Colors.red.withOpacity(0.8)
              ..style = PaintingStyle.fill,
          ),
          background: CircleComponent(
            radius: 50,
            paint: Paint()
              ..color = Colors.red.withOpacity(0.3)
              ..style = PaintingStyle.fill,
          ),
          margin: const EdgeInsets.only(right: 40, bottom: 40),
        );

  // Adicione este getter para obter a direção como Vector2
  Vector2 get shootDirection {
    if (direction == JoystickDirection.idle) {
      return Vector2.zero();
    }
    return Vector2(
      delta.x,
      delta.y,
    ).normalized();
  }

  @override
  void render(Canvas canvas) {
    // Adiciona um ícone de mira no centro
    final center = background!.position + background!.size / 2;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center.toOffset(), 10, paint);
    canvas.drawLine(
      Offset(center.x - 15, center.y),
      Offset(center.x + 15, center.y),
      paint,
    );
    canvas.drawLine(
      Offset(center.x, center.y - 15),
      Offset(center.x, center.y + 15),
      paint,
    );
    
    super.render(canvas);
  }
}