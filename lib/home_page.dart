import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'left_menu.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/warm_welcome.png', height: 150), // ✅ 添加溫暖圖片
            const SizedBox(height: 20),
            const Text(
              '這是一個為 ASD 家屬而設的關懷平台',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '我們提供資訊與經驗分享，針對香港政府資源，讓 ASD 家屬找到方向。',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '社區互動 | 問答支持 | 免費使用',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.facebook, color: Colors.white),
              label: const Text('加入 Facebook 社區'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                // Facebook 社群連結
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
              label: const Text('加入 WhatsApp 討論'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                // WhatsApp 群組連結
              },
            ),
          ],
        ),
      ),
    );
  }
}