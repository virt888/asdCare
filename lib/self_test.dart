import 'package:flutter/material.dart';
import 'dart:math';
import 'custom_app_bar.dart';
import 'left_menu.dart';

class SelfTestPage extends StatefulWidget {
  const SelfTestPage({super.key});

  @override
  SelfTestPageState createState() => SelfTestPageState();
}

class SelfTestPageState extends State<SelfTestPage> {
  final List<List<Map<String, dynamic>>> _questionSets = [
    // **🟢 問題組 1**
    [
      {
        "question": "孩子是否會對自己的名字有反應？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子會不會指著東西示意，或用眼神交流？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子會模仿別人的動作或聲音嗎？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子會對陌生人或新環境感到過度害怕或無動於衷嗎？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子會不會持續重複某些行為（如拍手、轉圈）？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否願意與其他小朋友一起玩？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子對聲音、燈光或觸感會不會過度敏感？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否會嘗試用手勢表達需求？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子是否對改變日常習慣感到焦慮？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子會不會喜歡排列玩具（例如一排車車）？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否會試圖與大人溝通（例如指物、發聲）？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子是否喜歡與家人擁抱？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子是否曾出現過語言倒退的情況？",
        "answers": ["✅ 沒有", "⚠️ 有一點", "❌ 明顯語言倒退"],
      },
      {
        "question": "孩子是否能對他人的情緒變化有所反應？",
        "answers": ["✅ 會", "⚠️ 偶爾", "❌ 不會"],
      },
      {
        "question": "孩子會不會長時間沉迷於某一個特定的物件或主題？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
    ],

    // **🟡 問題組 2**
    [
      {
        "question": "孩子是否經常對特定物品有極端的興趣？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否會發出無意義的聲音，並且頻繁重複？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 經常"],
      },
      {
        "question": "孩子是否習慣用非語言的方式來表達需求，例如拉著你的手去拿東西？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否容易因為環境中的小變化而情緒崩潰？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 容易崩潰"],
      },
      {
        "question": "孩子是否難以理解或適應新的環境？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否對某些質感（如衣服布料）特別敏感？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否經常用手或物品遮住耳朵，以避免某些聲音？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 經常"],
      },
      {
        "question": "孩子是否經常反覆觀看同一部影片或聽同一首歌？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否對旋轉的物體（如風扇、車輪）特別感興趣？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否會用不尋常的方式玩玩具，例如只關心積木的形狀而不搭建？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否對溫度變化（冷、熱）無明顯反應？",
        "answers": ["✅ 會明顯感覺到", "⚠️ 偶爾不在意", "❌ 無感覺"],
      },
      {
        "question": "孩子是否會對某些氣味特別敏感，甚至出現強烈的厭惡或興奮反應？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
      {
        "question": "孩子是否難以與其他小朋友一起參與團體活動？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 經常"],
      },
      {
        "question": "孩子是否有明顯的睡眠困難（如入睡困難、易驚醒）？",
        "answers": ["✅ 沒有", "⚠️ 偶爾", "❌ 經常"],
      },
      {
        "question": "孩子是否經常無故大笑或哭泣，且難以安撫？",
        "answers": ["✅ 不會", "⚠️ 偶爾", "❌ 會"],
      },
    ],
  ];

  List<Map<String, dynamic>> _currentQuestions = [];
  List<int> _answers = [];
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _setRandomQuestionSet();
  }

  void _setRandomQuestionSet() {
    setState(() {
      int randomSetIndex = Random().nextInt(_questionSets.length);
      _currentQuestions = List.from(_questionSets[randomSetIndex])..shuffle();
      _answers = List.filled(_currentQuestions.length, -1);
      _isCompleted = false;
    });
  }

  void _submitTest() {
    int score = _answers.fold(0, (sum, item) => sum + item);
    String resultText;

    if (score <= 5) {
      resultText = "🎉 初步感覺都很正常";
    } else if (score <= 12) {
      resultText = "⚠️ 建議找專業醫生評估";
    } else {
      resultText = "🚨 不可以等！盡快找專業醫生評估";
    }

    setState(() {
      _isCompleted = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("🔍 測試結果"),
          content: Text(
            resultText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setRandomQuestionSet();
              },
              child: const Text("重新測驗"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "🔍 ASD 自閉症初步評估小測驗",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _currentQuestions.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${_currentQuestions[index]['question']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...List.generate(3, (optionIndex) {
                        return RadioListTile<int>(
                          title: Text(
                            _currentQuestions[index]['answers'][optionIndex],
                          ),
                          value: optionIndex,
                          groupValue: _answers[index],
                          onChanged: (value) {
                            setState(() {
                              _answers[index] = value!;
                            });
                          },
                        );
                      }),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _answers.contains(-1) ? null : _submitTest,
              child: const Text("提交測驗結果"),
            ),
          ],
        ),
      ),
    );
  }
}
