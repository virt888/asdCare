import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'left_menu.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  Map<String, List<Map<String, String>>> faqs = {};
  bool _isAdWatched = false;
  bool _isLoading = true;
  late InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _fetchFAQs();
  }

  void _fetchFAQs() async {
    try {
      final response = await http.get(Uri.parse('https://virt888.github.io/asdCare_files/faqs.yaml'));
      if (response.statusCode == 200) {
        final String utf8Response = utf8.decode(response.bodyBytes); // 解決中文亂碼
        final YamlMap data = loadYaml(utf8Response);
        setState(() {
          faqs = data.map((key, value) => MapEntry(
              key,
              List<Map<String, String>>.from((value as List).map((item) => {
                    "question": item["question"].toString(),
                    "answer": item["answer"].toString()
                  }))));
          _isLoading = false;
        });
      } else {
        throw Exception("網絡請求失敗，使用本地數據");
      }
    } catch (e) {
      log("下載 GitHub 數據時出錯，使用本地數據: $e");
      _loadLocalFAQs();
    }
  }

  void _loadLocalFAQs() async {
    final String response = await rootBundle.loadString('assets/faqs.yaml');
    final YamlMap data = loadYaml(response);
    setState(() {
      faqs = data.map((key, value) => MapEntry(
          key,
          List<Map<String, String>>.from((value as List).map((item) => {
                "question": item["question"].toString(),
                "answer": item["answer"].toString()
              }))));
      _isLoading = false;
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // 測試ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          log('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showAdAndUnlockAnswers() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          setState(() {
            _isAdWatched = true;
          });
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('Ad failed to show: $error');
          setState(() {
            _isAdWatched = true;
          });
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      setState(() {
        _isAdWatched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/asd_care_wallpaper_03.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromARGB(100, 255, 255, 255),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    const Text(
                      "🕒 內容將定期更新，請留意最新資訊",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    buildSection("認識"),
                    buildSection("接納"),
                    buildSection("行動"),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _showAdAndUnlockAnswers,
                      child: const Text("觀看廣告解鎖所有答案"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAdWatched = !_isAdWatched;
                        });
                      },
                      child: Text("DEBUG 模式: ${_isAdWatched ? "隱藏答案" : "顯示答案"}"),
                    ),
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
        Divider(color: Colors.teal.shade700, thickness: 2),
        Text(
          sectionTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
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
              Image.asset('assets/question_icon.png', width: 48, height: 48),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
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
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isAdWatched
                      ? Text("答： ${faq['answer']}", style: const TextStyle(fontSize: 16))
                      : GestureDetector(
                          onTap: _showAdAndUnlockAnswers,
                          child: const Text("🔒 請觀看廣告解鎖內容", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset('assets/answer_icon.png', width: 48, height: 48),
            ],
          ),
        ),
      ],
    );
  }
}