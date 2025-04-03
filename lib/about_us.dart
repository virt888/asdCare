import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'about.page.app.bar'.tr(),
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ 適配淺米色背景
          ),
        ),        
        backgroundColor: const Color(0xFFF5E8D3),
      ),      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/about_us_banner.png', height: 180), // ✅ 添加溫暖圖片
            const SizedBox(height: 20),
            Text(
              'about.page.title'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'about.page.content.1'.tr(),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'about.page.content.2'.tr(),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Text(
              'about.page.service.title'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('about.page.service.1'.tr()),
            ),
            ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('about.page.service.2'.tr()),
            ),
            ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('about.page.service.3'.tr()),
            ),
            ListTile(
              leading: Icon(Icons.arrow_right_rounded, color: Colors.green),
              title: Text('about.page.service.4'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
