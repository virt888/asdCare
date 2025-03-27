import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';

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
  int health = 20;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.play('bgm.mp3', volume: 0.5);

    _background = await loadParallaxComponent(
      [ParallaxImageData('farm_background_2.png')],
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
    // 假設 health 是一個 int 屬性表示剩餘心數
    health--;
    if (health <= 0) {
      // 遊戲結束，暫停遊戲引擎（如果你有這個方法）
      pauseEngine();
      // 顯示 Game Over 對話框（參考 memory_game.dart 的 _gameCompleted() 方法）
      Future.delayed(Duration.zero, () {
        showDialog(
          context:
              buildContext, // 請確保你有正確的 BuildContext（例如通過 gameRef.context 或其他方式取得）
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Game Over"),
              content: const Text("你已失去所有心心！"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 重新開始遊戲，這裡假設有一個 restartGame() 方法
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
      gameRef.reduceHealth();
      // Optionally, you can remove the obstacle after collision
      removeFromParent();
    }
  }
}
