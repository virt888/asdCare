import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'left_menu.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  Map<String, List<Map<String, String>>> faqs = {};
  bool hasWatchedAd = false;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadFAQs();
    _loadAd();
  }

  Future<void> loadFAQs() async {
    final String response = await rootBundle.loadString('assets/faqs.yaml');
    final YamlMap data = loadYaml(response);

    setState(() {
      faqs = data.map((key, value) => MapEntry(
          key,
          List<Map<String, String>>.from((value as List).map((item) => {
                "question": item["question"].toString(),
                "answer": item["answer"].toString()
              }))));
    });
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 測試廣告 ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  void _showRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // 測試廣告 ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            setState(() {
              hasWatchedAd = true;
            });
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            hasWatchedAd = true;
          });
        },
      ),
    );
  }

  void _toggleDebugMode() {
    setState(() {
      hasWatchedAd = !hasWatchedAd;
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
            image: AssetImage('assets/asd_care_wallpaper_03.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(100, 255, 255, 255),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                "⏳ 內容將定期更新，請留意最新資訊",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              buildSection("認識"),
              buildSection("接納"),
              buildSection("行動"),
              if (!hasWatchedAd)
                ElevatedButton(
                  onPressed: _showRewardedAd,
                  child: const Text("觀看廣告以解鎖所有答案"),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleDebugMode,
                child: Text(hasWatchedAd ? "🔴 隱藏答案 (DEBUG)" : "🟢 顯示答案 (DEBUG)"),
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
        Divider(thickness: 2, color: Colors.teal),
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
              Image.asset('assets/question_icon.png', width: 48, height: 48),
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
        if (hasWatchedAd)
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
                    child: Text("答： ${faq['answer']}", style: const TextStyle(fontSize: 16)),
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