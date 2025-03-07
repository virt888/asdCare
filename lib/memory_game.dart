import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';
import 'custom_app_bar.dart';
import 'left_menu.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  MemoryGamePageState createState() => MemoryGamePageState();
}

class MemoryGamePageState extends State<MemoryGamePage> {
  final List<String> _cardValues = [
    '🐶',
    '🐶',
    '🐱',
    '🐱',
    '🦊',
    '🦊',
    '🐻',
    '🐻',
    '🐼',
    '🐼',
    '🐸',
    '🐸',
    '🐵',
    '🐵',
    '🦄',
    '🦄',
  ];
  late List<bool> _flipped;
  late List<bool> _matched;
  int? _firstSelected;
  int? _secondSelected;
  bool _isChecking = false;
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  Timer? _timer;
  int _elapsedTime = 0; // 用秒計算時間
  int? _bestTime; // 最佳成績（秒）

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _cardValues.shuffle();
    _flipped = List.filled(_cardValues.length, false);
    _matched = List.filled(_cardValues.length, false);
    _firstSelected = null;
    _secondSelected = null;
    _isChecking = false;
    _elapsedTime = 0;
    _timer?.cancel();
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime++;
        });
      });
    }
  }

  void _onCardTap(int index) {
    if (_isChecking || _flipped[index] || _matched[index]) return;

    // 開始計時（只在第一張牌翻開時開始）
    if (_elapsedTime == 0) {
      _startTimer();
    }

    setState(() {
      _flipped[index] = true;

      if (_firstSelected == null) {
        _firstSelected = index;
      } else {
        _secondSelected = index;
        _isChecking = true;

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (_cardValues[_firstSelected!] == _cardValues[_secondSelected!]) {
              _matched[_firstSelected!] = true;
              _matched[_secondSelected!] = true;
            } else {
              _flipped[_firstSelected!] = false;
              _flipped[_secondSelected!] = false;
            }
            _firstSelected = null;
            _secondSelected = null;
            _isChecking = false;

            // 🎉 若全部配對成功，結束計時並顯示完成訊息
            if (_matched.every((matched) => matched)) {
              _gameCompleted();
            }
          });
        });
      }
    });
  }

  void _gameCompleted() {
    _timer?.cancel(); // 停止計時
    _confettiController.play();

    // 記錄最佳成績
    if (_bestTime == null || _elapsedTime < _bestTime!) {
      _bestTime = _elapsedTime;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "🎉 你好叻呀！ 🎉",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "你用了 $_elapsedTime 秒完成記憶配對遊戲！",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                child: const Text("再玩一次"),
              ),
            ],
          );
        },
      );
    });
  }

  void _restartGame() {
    setState(() {
      _resetGame();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(), // ✅ 加入左側選單
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ⏳ 計時器 & 最佳記錄
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "⏳ 時間: $_elapsedTime 秒",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _bestTime != null ? "🏆 最快: $_bestTime 秒" : "🏆 最快: --",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 記憶遊戲 GRID
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                    itemCount: _cardValues.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _matched[index] ? Colors.green : Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              _flipped[index] || _matched[index]
                                  ? _cardValues[index]
                                  : '❓',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 🎆 煙花動畫
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 5,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
