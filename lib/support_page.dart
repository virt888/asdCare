import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  List<Map<String, String>> referenceLinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReferenceLinks();
  }

  void _fetchReferenceLinks() async {
    try {
      final response = await http
          .get(Uri.parse('support.page.url.1'.tr()))
          .timeout(const Duration(seconds: 3)); // ✅ 設置 3 秒 Timeout

      if (response.statusCode == 200) {
        final String utf8Response = utf8.decode(response.bodyBytes);
        final YamlMap data = loadYaml(utf8Response);

        setState(() {
          referenceLinks = List<Map<String, String>>.from(
            (data['links'] as List).map(
              (item) => {
                "title": item["title"].toString(),
                "url": item["url"].toString(),
              },
            ),
          );
          _isLoading = false;
        });

        debugPrint("✅ 成功從 GitHub 下載 Reference Links");
      } else {
        throw Exception("❌ 網絡請求失敗，使用本地數據");
      }
    } catch (e) {
      debugPrint("⚠️ 下載 Reference Links 時出錯，使用本地數據: $e");
      _loadLocalReferenceLinks();
    }
  }

  void _loadLocalReferenceLinks() async {
    final String localFile = 'support.page.url.2'.tr();
    final String response = await rootBundle.loadString(localFile);
    final YamlMap data = loadYaml(response);

    setState(() {
      referenceLinks = List<Map<String, String>>.from(
        (data['links'] as List).map(
          (item) => {
            "title": item["title"].toString(),
            "url": item["url"].toString(),
          },
        ),
      );
      _isLoading = false;
    });

    debugPrint("📂 使用本地 Reference Links");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'support.page.app.bar'.tr(),
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ 適配淺米色背景
          ),
        ),
        backgroundColor: const Color(0xFFF5E8D3),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/asd_care_wallpaper_04.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(80, 255, 255, 255),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏥 標題 + 醫生 ICON
              Row(
                children: [
                  Image.asset('assets/doctor_icon.png', width: 48, height: 48),
                  const SizedBox(width: 10),
                  Text(
                    "support.page.story.1.title".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildMessageBox("support.page.story.1.title.content".tr()),
              const SizedBox(height: 20),

              _buildStep(
                "support.page.story.1.step.1.title".tr(),
                "support.page.story.1.step.1.content".tr(),
              ),
              _buildStep(
                "support.page.story.1.step.2.title".tr(),
                "support.page.story.1.step.2.content".tr(),
              ),
              _buildStep(
                "support.page.story.1.step.3.title".tr(),
                "support.page.story.1.step.3.content".tr(),
              ),
              _buildStep(
                "support.page.story.1.step.4.title".tr(),
                "support.page.story.1.step.4.content".tr(),
              ),
              _buildStep(
                "support.page.story.1.step.5.title".tr(),
                "support.page.story.1.step.5.content".tr(),
              ),
              _buildStep(
                "support.page.story.1.step.6.title".tr(),
                "support.page.story.1.step.6.content".tr(),
              ),

              const SizedBox(height: 30),

              // ℹ️ 重要連結（白色 INFO BOX）
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.95 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/info_icon.png',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "support.page.url.title".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // ✅ 確保文字左對齊
                          children:
                              referenceLinks
                                  .map(
                                    (link) => Align(
                                      alignment:
                                          Alignment
                                              .centerLeft, // ✅ 讓每個 Link 左對齊
                                      child: _buildLink(
                                        link['title']!,
                                        link['url']!,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /// 📌 流程步驟（鬼腳圖）
  Widget _buildStep(String title, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.95 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: Colors.teal, width: 5)),
          ),
          child: Text(details, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  /// 📨 文字訊息區塊（大 Message Box）
  Widget _buildMessageBox(String message) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.95 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 2),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 🔗 重要連結（可點擊開啟外部網頁）
  Widget _buildLink(String text, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          Uri link = Uri.parse(url);
          if (await canLaunchUrl(link)) {
            await launchUrl(link, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D6D6D),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
