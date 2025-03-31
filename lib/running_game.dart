import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart'; 

class RunningGamePage extends StatelessWidget {
  const RunningGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mini.game.jump.app.bar".tr()),
        backgroundColor: const Color(0xFFF5E8D3),
        actions: [
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
                'mini.game.jump.topright.message'.tr(
                        namedArgs: {'score': game.score.toString()},
                      ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
          'Health': (context, RunningGame game) {
            int hearts = game.health;
            int firstRowCount = hearts >= 5 ? 5 : hearts;
            int secondRowCount = hearts > 5 ? hearts - 5 : 0;
            
            return Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(firstRowCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset("assets/images/heart.png", width: 20),
                      );
                    }),
                  ),
                  if (secondRowCount > 0)
                    Row(
                      children: List.generate(secondRowCount, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Image.asset("assets/images/heart.png", width: 20),
                        );
                      }),
                    ),
                ],
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
    FlameAudio.bgm.stop();    
    FlameAudio.bgm.play('bgm.m4a', volume: 0.5);
    FlameAudio.bgm.audioPlayer.setReleaseMode(ReleaseMode.loop);

    _background = await loadParallaxComponent(
      [ParallaxImageData('farm_background_4.png')],
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

  @override
  void onDetach() {
    FlameAudio.bgm.stop();
    super.onDetach();
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
              title: Text("mini.game.jump.popup.title".tr()),
              content: Text('mini.game.jump.popup.message'.tr(
                        namedArgs: {'score': score.toString()},
                      )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    restartGame();
                    resumeEngine();
                  },
                  child: Text('mini.game.jump.popup.playagain'.tr()),
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
    health = 10; // 設定新心數為 10

    // 移除所有障礙物（Obstacle）
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    // 重設玩家位置（根據你的邏輯調整）
    _player.position = Vector2(100, size.y - 100);
    
    // Reset score overlay by removing and adding again
    overlays.remove('Score');
    overlays.add('Score');
    
    // 重播背景音樂從頭開始：先停止再播放
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('bgm.m4a', volume: 0.5);
    FlameAudio.bgm.audioPlayer.setReleaseMode(ReleaseMode.loop);
    
    // 如果有其他遊戲狀態需要重置，請在這裡添加
  }
}

class Player extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {
  static const double jumpVelocity = -400;
  static const double gravity = 800;
  double speedY = 0;
  int jumpCount = 0;

  // Original image: 431 x 620, aspect ratio ~0.70. For a height of 50, width ≈ 35.
  Player() : super(size: Vector2(35, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_child_v1.png');
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
    if (jumpCount < 5) {
      speedY = jumpVelocity;
      jumpCount++;
      FlameAudio.play('jump.m4a');
    }
  }
}

class Obstacle extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {

  // Original image: 664 x 463, aspect ratio ~1.43. For a height of 50, width ≈ 72.
  Obstacle() : super(size: Vector2(72, 50));  

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('sheep_obstacle_v1.png');
    
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
