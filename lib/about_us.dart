import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'left_menu.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const LeftMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/about_us_banner.png', height: 180), // ✅ 添加溫暖圖片
            const SizedBox(height: 20),
            const Text(
              '🌟 關於 ASD Care 關懷 🌟',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              '👋 你好！我們是 ASD Care 關懷，一個專注於關愛自閉症人士（ASD）及其家庭的非營利平台。',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              '💙 這APP由一位 ASD 孩子的家長創立，希望透過自身經歷和資源，為更多 ASD 家庭帶來支持、理解和溫暖。我們深知這條路不容易走，因此希望用實際行動，幫助更多有需要的人。',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            const Text(
              '我們提供的服務：',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('分享 ASD 相關資訊與實用資源'),
            ),
            const ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('提供家長與照顧者的支持與交流平台'),
            ),
            const ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('推廣社會大眾對 ASD 的認識與接納'),
            ),
            const ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('透過免費服務，讓更多 ASD 人士得到幫助'),
            ),
          ],
        ),
      ),
    );
  }
}
