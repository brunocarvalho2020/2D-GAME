// ignore_for_file: avoid_single_cascade_in_expression_statements
import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'dart:math'; // Para Random
import 'entities/zombie.dart'; // Para a classe Zombie
import 'entities/background.dart';
import 'entities/player.dart';
import 'ui/hud.dart';
import 'ui/joystick.dart';
import 'ui/joystick_shoot.dart';
import 'utils/constants.dart';

class MyGame extends FlameGame with HasCollisionDetection {
  late final CameraComponent cameraComponent;
  late final Player player;
  late final JoystickPlayer joystick;
  late final JoystickShoot joystick_shoot;

  //  Novo: camadas separadas
  late final World world;
  late final PositionComponent bulletLayer;

  late final Vector2 _mapSize;
  double _spawnTimer = 0;
  final double _spawnInterval = 3.0; // Spawn a cada 3 segundos

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    kGameWidth = size.x;
    kGameHeight = size.y;
    _mapSize = Vector2(kGameWidth, kGameHeight);

    joystick = JoystickPlayer()..priority = 100;

    joystick_shoot = JoystickShoot()..priority = 100;

    print('Configurando mundo...');
    world = World();
    add(world);

    //  Cria a camada de tiros
    bulletLayer =
        PositionComponent()
          ..priority =
              10; // Prioridade dos tiros: acima do fundo, mas abaixo do HUD
    world.add(bulletLayer);

    print('Adicionando fundo...');
    final background =
        InfiniteBackground()..priority = -100; // Fundo com prioridade menor
    world.add(background);

    print('Adicionando jogador...');
    player = Player(joystick, joystick_shoot)..priority = 0; // Jogador
    player.position = Vector2(kGameWidth / 2, kGameHeight / 2);
    world.add(player);

    print('Configurando câmera...');
    cameraComponent = CameraComponent.withFixedResolution(
      width: kGameWidth,
      height: kGameHeight,
    )..viewfinder.anchor = Anchor.center;
    cameraComponent.world = world;
    cameraComponent.follow(player);
    add(cameraComponent);

    print('Carregando Joystick...');
    cameraComponent.viewport.addAll([joystick, joystick_shoot]);

    print('Adicionando HUD...');
    add(Hud());
    _spawnZombie();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Lógica de spawn periódico
    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnZombie();
    }
  }

  void _spawnZombie() {
    // Escolhe um lado aleatório para spawnar (0 = top, 1 = right, 2 = bottom, 3 = left)
    final side = Random().nextInt(4);
    Vector2 spawnPosition;

    // Calcula posição inicial baseada no lado escolhido
    switch (side) {
      case 0: // Topo
        spawnPosition = Vector2(Random().nextDouble() * _mapSize.x, 0);
        break;
      case 1: // Direita
        spawnPosition = Vector2(_mapSize.x, Random().nextDouble() * _mapSize.y);
        break;
      case 2: // Fundo
        spawnPosition = Vector2(Random().nextDouble() * _mapSize.x, _mapSize.y);
        break;
      case 3: // Esquerda
      default:
        spawnPosition = Vector2(0, Random().nextDouble() * _mapSize.y);
    }

    // Adiciona o zumbi ao mundo
    world.add(
      Zombie(
        player: player,
        initialPosition: spawnPosition,
        mapSize: _mapSize,
        speed: 80 + Random().nextDouble() * 40, // Velocidade entre 80-120
      ),
    );
  }
}
