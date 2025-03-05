import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'left_menu.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart'; // ✅ 新增 YAML 解析器

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  Map<String, List<Map<String, String>>> faqs = {};

  @override
  void initState() {
    super.initState();
    loadFAQs();
  }

  Future<void> loadFAQs() async {
    final String response = await rootBundle.loadString('assets/faqs.yaml');
    final YamlMap data = loadYaml(response); // ✅ 正確解析 YAML

    setState(() {
      faqs = data.map((key, value) => MapEntry(
          key,
          List<Map<String, String>>.from((value as List).map((item) => {
                "question": item["question"].toString(),
                "answer": item["answer"].toString()
              }))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/asd_care_wallpaper_03.png'), // ✅ 新增背景圖片
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(100, 255, 255, 255), // ✅ 讓背景變淡
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              buildSection("認識"),
              buildSection("接納"),
              buildSection("行動"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        const SizedBox(height: 10),
        if (faqs.containsKey(sectionTitle) && faqs[sectionTitle]!.isNotEmpty)
          ...faqs[sectionTitle]!.map((faq) => buildFAQItem(faq)).toList()
        else
          const Text("（暫無內容）", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildFAQItem(Map<String, String> faq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/question_icon.png', width: 48, height: 48), // ✅ 加入小圖示
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(150, 0, 128, 128),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "問： ${faq['question']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(150, 255, 165, 0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "答： ${faq['answer']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset('assets/answer_icon.png', width: 48, height: 48), // ✅ 加入小圖示
            ],
          ),
        ),
      ],
    );
  }
}
