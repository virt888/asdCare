import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SourcePage extends StatelessWidget {
  const SourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'source.page.app.bar'.tr(),
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ 適配淺米色背景
          ),
        ),        
        backgroundColor: const Color(0xFFF5E8D3),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/source_wallpaper.png",
              fit: BoxFit.cover, // ✅ 讓圖片填滿整個畫面，避免白邊
              alignment: Alignment.center, // ✅ 確保圖片置中
              color: const Color.fromARGB(77, 255, 255, 255), // ✅ 替代 withOpacity()
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter, // ✅ 置頂顯示資訊框
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(190, 255, 255, 255), // ✅ 半透明白底
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'source.page.title'.tr(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSourceItem(
                        title: 'source.page.title.1'.tr(),
                        url: 'source.page.url.1'.tr(),
                      ),
                      _buildSourceItem(
                        title: 'source.page.title.2'.tr(),
                        url: 'source.page.url.2'.tr(),
                      ),
                      _buildSourceItem(
                        title: 'source.page.title.3'.tr(),
                        url: 'source.page.url.3'.tr(),
                      ),
                      _buildSourceItem(
                        title: 'source.page.title.4'.tr(),
                        url: 'source.page.url.4'.tr(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'source.page.reminder'.tr(),
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem({required String title, required String url}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint("無法開啟連結: $url");
          }
        },
        child: Row(
          children: [
            const Icon(Icons.open_in_new, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}