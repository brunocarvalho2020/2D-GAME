import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class JoystickPlayer extends JoystickComponent {
  JoystickPlayer()
      : super(
          knob: CircleComponent(
            radius: 25,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.8)
              ..style = PaintingStyle.fill,
          ),
          background: CircleComponent(
            radius: 50,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.3)
              ..style = PaintingStyle.fill,
          ),
          margin: const EdgeInsets.only(left: 40, bottom: 40),
          knobRadius: 25,
        );

  bool get isActive => direction != JoystickDirection.idle;
}