import 'package:flutter/material.dart';
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

  Future<void> _fetchFAQs() async {
    try {
      final response = await http
          .get(Uri.parse('https://virt888.github.io/asdCare_files/faqs.yaml'))
          .timeout(const Duration(seconds: 3)); // 設定 3 秒超時
      if (response.statusCode == 200) {
        final String utf8Response = utf8.decode(response.bodyBytes);
        final YamlMap data = loadYaml(utf8Response);
        _parseFAQData(data);
        log("✅ 成功從 GitHub 下載 FAQ 數據");
      } else {
        throw Exception("網絡請求失敗，使用本地數據");
      }
    } catch (e) {
      log("⚠️ 下載 GitHub 數據時出錯，使用本地數據: $e");
      _loadLocalFAQs();
    }
  }

  Future<void> _loadLocalFAQs() async {
    try {
      final String response = await rootBundle.loadString('assets/faqs.yaml');
      final YamlMap data = loadYaml(response);
      _parseFAQData(data);
      log("📂 使用本地 FAQ 數據");
    } catch (e) {
      log("❌ 無法加載本地 FAQ 數據: $e");
    }
  }

  void _parseFAQData(YamlMap data) {
    setState(() {
      faqs = data.map(
        (key, value) => MapEntry(
          key,
          List<Map<String, String>>.from(
            (value as List).map(
              (item) => {
                "question": item["question"].toString(),
                "answer": item["answer"].toString(),
              },
            ),
          ),
        ),
      );
      _isLoading = false;
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712', // 測試 ID
      adUnitId: 'ca-app-pub-8691410470836032~6319886404', // REAL ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          log("✅ 廣告加載成功");
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          log("⚠️ 廣告加載失敗: $error");
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
          log("✅ 用戶已觀看廣告，解鎖答案");
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log("⚠️ 廣告播放失敗: $error");
          setState(() {
            _isAdWatched = true;
          });
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      log("⚠️ 廣告未準備好，直接解鎖答案");
      setState(() {
        _isAdWatched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '深入認識 ASD 世界',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ 適配淺米色背景
          ),
        ),        
        backgroundColor: const Color(0xFFF5E8D3),
      ),      
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
                      "🕰️ 內容將定期更新，請留意最新資訊",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...faqs.keys.map((section) => buildSection(section)).toList(),
                    const SizedBox(height: 30),
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),
        if (faqs.containsKey(sectionTitle) && faqs[sectionTitle]!.isNotEmpty)
          ...faqs[sectionTitle]!.map((faq) => buildFAQItem(faq)).toList()
        else
          const Text(
            "（暫無內容）",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                      ? Text(
                          "答： ${faq['answer']}",
                          style: const TextStyle(fontSize: 16),
                        )
                      : GestureDetector(
                          onTap: _showAdAndUnlockAnswers,
                          child: const Text(
                            "🔒 請觀看廣告解鎖內容",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
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