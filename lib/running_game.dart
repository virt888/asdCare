import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'dart:math';

class RunningGamePage extends StatelessWidget {
  const RunningGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Running Game"),
        backgroundColor: const Color(0xFFF5E8D3),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              FlameAudio.bgm.resume();
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              FlameAudio.bgm.stop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.volume_off),
            onPressed: () {
              FlameAudio.bgm.audioPlayer.setVolume(0.0); // ✅ 修正音量控制
            },
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              FlameAudio.bgm.audioPlayer.setVolume(1.0); // ✅ 修正音量控制
            },
          ),
        ],
      ),
      body: GameWidget(
        game: RunningGame(),
        overlayBuilderMap: {
          'Score': (context, RunningGame game) {
            return Positioned(
              top: 20,
              right: 20,
              child: Text(
                "跳過: ${game.score} 隻羊",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
          'Health': (context, RunningGame game) {
            return Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: List.generate(
                  game.health,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Image.asset("assets/images/heart.png", width: 20),
                  ),
                ),
              ),
            );
          },
        },
      ),
    );
  }
}

class RunningGame extends FlameGame with HasCollisionDetection, TapDetector {
  late ParallaxComponent _background;
  late Player _player;
  late TimerComponent _spawnObstacleTimer;
  int score = 0;
  int health = 10;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.play('bgm.m4a', volume: 0.5);

    _background = await loadParallaxComponent(
      [ParallaxImageData('farm_background_3.png')],
      baseVelocity: Vector2(50, 0),
      repeat: ImageRepeat.repeat,
    );
    add(_background);

    _player = Player();
    add(_player);

    _spawnObstacleTimer = TimerComponent(
      period: 2,
      repeat: true,
      onTick: () => add(Obstacle()),
    );
    add(_spawnObstacleTimer);

    overlays.add('Score');
    overlays.add('Health');
  }

  @override
  void onTapDown(info) {
    _player.jump();
  }

  void increaseScore() {
    score++;
    overlays.remove('Score');
    overlays.add('Score');
  }

  void reduceHealth() {
    health--;
    debugPrint("reduceHealth called, health is now $health");
    // 更新 Health overlay
    overlays.remove('Health');
    overlays.add('Health');

    if (health <= 0) {
      pauseEngine();
      Future.delayed(Duration.zero, () {
        showDialog(
          context: buildContext!, // 確保 buildContext 不為 null
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Game Over"),
              content: const Text("你已失去所有心心！"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    restartGame();
                    resumeEngine();
                  },
                  child: const Text("重新挑戰"),
                ),
              ],
            );
          },
        );
      });
    }
  }

  void restartGame() {
    // 重置遊戲狀態
    score = 0;
    health = 10; // 或設定你預設的心數

    // 移除所有障礙物（Obstacle）
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    // 重設玩家位置，根據你的遊戲邏輯調整這裡
    _player.position = Vector2(100, size.y - 100);

    // 如果有其他遊戲狀態需要重置，請在這裡添加
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
      FlameAudio.play('jump.m4a');
    }
  }
}

class Obstacle extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {
  Obstacle() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('sheep_obstacle.png');
    
    // Old version, same distance
    // position = Vector2(gameRef.size.x, gameRef.size.y - 100);
    
    // Set a minimum offset and a maximum additional random offset
    final double minOffset = 100; // minimum extra distance (adjust as needed)
    final double maxAdditionalOffset = 200; // additional random distance range
    final double offsetX = gameRef.size.x + minOffset + Random().nextDouble() * maxAdditionalOffset;
    position = Vector2(offsetX, gameRef.size.y - 100);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 100 * dt;

    if (position.x < -size.x) {
      removeFromParent();
      gameRef.increaseScore();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      debugPrint("Obstacle collided with Player. Reducing health.");
      gameRef.reduceHealth();
      // 移除障礙物後可讓玩家不重複碰撞
      removeFromParent();
    }
  }
}
