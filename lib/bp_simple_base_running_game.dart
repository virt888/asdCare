import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class RunningGamePage extends StatelessWidget {
  const RunningGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: RunningGame(),
      ),
    );
  }
}

class RunningGame extends FlameGame with TapDetector, HasCollisionDetection {
  late ParallaxComponent _background;
  late Player _player;
  late TimerComponent _spawnObstacleTimer;
  late HealthBar _healthBar;
  int score = 0;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('bgm.mp3');

    _background = await loadParallaxComponent(
      [ParallaxImageData('farm_background_2.png')],
      baseVelocity: Vector2(50, 0),
      repeat: ImageRepeat.repeat,
    );
    add(_background);

    _player = Player();
    add(_player);

    _healthBar = HealthBar();
    add(_healthBar);

    _spawnObstacleTimer = TimerComponent(
      period: 2,
      repeat: true,
      onTick: () => add(Obstacle()),
    );
    add(_spawnObstacleTimer);
  }

  @override
  void onTap() {
    _player.jump();
  }

  void reduceHealth() {
    _healthBar.loseHeart();
  }
}

class Player extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {
  static const double jumpVelocity = -400;
  static const double gravity = 800;
  double speedY = 0;
  int jumpCount = 0;

  Player() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_child.png');
    position = Vector2(100, gameRef.size.y - 100);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    speedY += gravity * dt;
    position.y += speedY * dt;

    if (position.y >= gameRef.size.y - 100) {
      position.y = gameRef.size.y - 100;
      jumpCount = 0;
    }
  }

  void jump() {
    if (jumpCount < 3) {
      speedY = jumpVelocity;
      jumpCount++;
      FlameAudio.play('jump.mp3');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      gameRef.reduceHealth();
      other.removeFromParent();
    }
  }
}

class Obstacle extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {
  Obstacle() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('sheep_obstacle.png');
    position = Vector2(gameRef.size.x, gameRef.size.y - 100);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 100 * dt;

    if (position.x < -size.x) {
      removeFromParent();
      gameRef.score += 1;
    }
  }
}

class HealthBar extends PositionComponent with HasGameRef<RunningGame> {
  int lives = 3;
  final List<SpriteComponent> hearts = [];

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < lives; i++) {
      final heart = SpriteComponent(
        sprite: await gameRef.loadSprite('heart.png'),
        size: Vector2(30, 30),
        position: Vector2(20 + (i * 40), 20),
      );
      hearts.add(heart);
      add(heart);
    }
  }

  void loseHeart() {
    if (lives > 0) {
      lives--;
      hearts[lives].removeFromParent();
    }
  }
}