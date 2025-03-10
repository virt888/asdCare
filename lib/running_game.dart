import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// ✅ 遊戲頁面
class RunningGamePage extends StatelessWidget {
  const RunningGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: RunningGame(),
        overlayBuilderMap: {
          'GameOver': (context, RunningGame game) {
            return Center(
              child: Container(
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "遊戲結束",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        game.restart();
                      },
                      child: const Text("重新開始"),
                    ),
                  ],
                ),
              ),
            );
          },
        },
      ),
    );
  }
}

// ✅ 遊戲主類
class RunningGame extends FlameGame with TapDetector, HasCollisionDetection {
  late ParallaxComponent _background;
  late Player _player;
  late TimerComponent _spawnObstacleTimer;
  late HealthBar _healthBar; // ✅ 血條
  late TextComponent _scoreText; // ✅ 計分顯示
  int score = 0; // ✅ 記錄跳過的綿羊數

  @override
  Future<void> onLoad() async {
    // ✅ 預載音效，避免跳躍時卡頓
    await FlameAudio.audioCache.loadAll(['jump.m4a']);

    // ✅ 載入背景音樂
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('bgm.m4a');

    // ✅ 設置背景
    _background = await loadParallaxComponent(
      [
        ParallaxImageData('farm_background_2.png'), // ✅ 只使用一張背景
      ],
      baseVelocity: Vector2(50, 0),
      repeat: ImageRepeat.repeat,
    );
    add(_background);

    // ✅ 添加玩家角色（小孩）
    _player = Player();
    add(_player);

    // ✅ 添加血條
    _healthBar = HealthBar();
    add(_healthBar);

    // ✅ 添加計分文字
    _scoreText = TextComponent(
      text: "跳過: 0",
      position: Vector2(size.x - 100, 20),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
    add(_scoreText);

    // ✅ 設定障礙物產生的計時器（初始）
    _spawnObstacleTimer = TimerComponent(
      period: _randomDistance(), // ✅ 初始時間
      repeat: true,
      onTick: _spawnObstacle,
    );
    add(_spawnObstacleTimer);
  }

  void _spawnObstacle() {
    add(Obstacle());

    // ✅ **修正：直接修改 `period`，避免初始化錯誤**
    _spawnObstacleTimer.timer.stop(); // 先停止計時器
    _spawnObstacleTimer.timer.start(); // 重新啟動計時器
    _spawnObstacleTimer.timer.limit = _randomDistance(); // 設定新的間隔時間
  }

  @override
  void onTap() {
    _player.jump();
  }

  void increaseScore() {
    score += 1;
    _scoreText.text = "跳過: $score";
  }

  void reduceHealth() {
    _healthBar.loseHeart();
    if (_healthBar.lives == 0) {
      _gameOver();
    }
  }

  void _gameOver() {
    overlays.add('GameOver'); // ✅ 顯示 Game Over
    pauseEngine(); // ✅ 暫停遊戲
  }

  void restart() {
    overlays.remove('GameOver'); // ✅ 隱藏 Game Over
    resumeEngine(); // ✅ 繼續遊戲
    score = 0;
    _scoreText.text = "跳過: 0";
    _healthBar.reset();
    _player.resetPosition();

    // ✅ **修正：遊戲重啟時隨機間隔**
    _spawnObstacleTimer.timer.stop();
    _spawnObstacleTimer.timer.start();
    _spawnObstacleTimer.timer.limit = _randomDistance();
  }

  double _randomDistance() {
    return Random().nextDouble() * 1.5 + 1.5; // ✅ 隨機 1.5 - 3 秒出現一隻羊
  }
}

// ✅ 玩家角色（小孩）
class Player extends SpriteComponent
    with HasGameRef<RunningGame>, CollisionCallbacks {
  static const double jumpVelocity = -400;
  static const double gravity = 800;
  double speedY = 0;
  int jumpCount = 0; // ✅ 三段跳計數

  Player() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_child.png');
    position = Vector2(100, gameRef.size.y - 100);
    add(RectangleHitbox()); // ✅ 增加碰撞體積
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

  void resetPosition() {
    position = Vector2(100, gameRef.size.y - 100);
    jumpCount = 0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      gameRef.reduceHealth();
      other.removeFromParent();
    }
  }
}

// ✅ 障礙物（綿羊）
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
}

// ✅ 血條顯示
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

  void reset() {
    for (final heart in hearts) {
      remove(heart);
    }
    hearts.clear();
    lives = 3;
    onLoad();
  }
}
