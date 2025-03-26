import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:easy_localization/easy_localization.dart';

class SelfTestPage extends StatefulWidget {
  const SelfTestPage({super.key});

  @override
  SelfTestPageState createState() => SelfTestPageState();
}

class SelfTestPageState extends State<SelfTestPage> {
  List<List<Map<String, dynamic>>> _questionSets = [];
  List<Map<String, dynamic>> _currentQuestions = [];
  List<int> _answers = [];
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    // 載入 YAML 資料，然後隨機抽題
    _loadQuestionsFromYaml();
  }

  Future<void> _loadQuestionsFromYaml() async {
    // 直接從翻譯檔中取得 YAML 檔案名稱，這個 key 在你的 translations 裡面定義，例如：
    // en.yaml: self.test.questions: "assets/en-question-sets.yaml"
    // zh-HK.yaml: self.test.questions: "assets/zh-HK-question-sets.yaml"
    // zh-CN.yaml: self.test.questions: "assets/zh-CN-question-sets.yaml"
    final String fileName = 'self.test.questions'.tr();
    try {
      final String yamlString = await rootBundle.loadString(fileName);
      final yamlMap = loadYaml(yamlString);
      // 假設 YAML 結構為：
      // self_test:
      //   questionSets: [ [...], [...] ]
      final List<dynamic> qs = yamlMap['self_test']['questionSets'];
      setState(() {
        _questionSets = qs.map<List<Map<String, dynamic>>>((set) {
          return (set as List).map<Map<String, dynamic>>((q) {
            return Map<String, dynamic>.from(q);
          }).toList();
        }).toList();
        _setRandomQuestionSet();
      });
    } catch (e) {
      debugPrint("⚠️ Unable to load question set from YAML: $e");
    }
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
      resultText = 'self.test.result.1'.tr();
    } else if (score <= 12) {
      resultText = 'self.test.result.2'.tr();
    } else {
      resultText = 'self.test.result.3'.tr();
    }
    setState(() {
      _isCompleted = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('self.test.result.label'.tr()),
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
              child: Text('self.test.result.testagain'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questionSets.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'self.test.app.bar'.tr(),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFF5E8D3),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/self_test_wallpaper.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(40, 255, 255, 255),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'self.test.title'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
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
                ),
                ElevatedButton(
                  onPressed: _answers.contains(-1) ? null : _submitTest,
                  child: Text('self.test.submit.button'.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}