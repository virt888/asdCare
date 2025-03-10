import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SourcePage extends StatelessWidget {
  const SourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '醫學資訊來源',
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
                      const Text(
                        "本應用程式內提供的 ASD（自閉症光譜）相關資訊均參考以下權威醫學及學術機構，確保資訊的準確性及可靠性：",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSourceItem(
                        title: "美國疾病控制與預防中心 (CDC)",
                        url: "https://www.cdc.gov/ncbddd/autism/index.html",
                      ),
                      _buildSourceItem(
                        title: "世界衛生組織 (WHO)",
                        url: "https://www.who.int/news-room/fact-sheets/detail/autism-spectrum-disorders",
                      ),
                      _buildSourceItem(
                        title: "香港中文大學",
                        url: "http://autism.cuhk.edu.hk",
                      ),
                      _buildSourceItem(
                        title: "香港大學自閉症兒童訓練資源手冊",
                        url: "https://www.socsc.hku.hk/JCA-Connect/en/%E8%87%AA%E9%96%89%E7%97%87%E5%85%92%E7%AB%A5%E8%A8%93%E7%B7%B4%E8%B3%87%E6%BA%90%E6%89%8B%E5%86%8A/",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "我們建議家長如對資訊有疑問，應諮詢專業醫生或專家，以獲取最適切的建議。",
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