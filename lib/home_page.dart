import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'left_menu.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'info_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            image: AssetImage('assets/asd_care_wallpaper_02.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(100, 255, 255, 255),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
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
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.info, color: Colors.white),
                label: const Text(
                  '深入認識 ASD 世界',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text(
                  '加入 Facebook 社區',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final Uri facebookUri = Uri.parse('https://www.facebook.com/profile.php?id=61573752815081');
                  launchUrl(facebookUri, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                label: const Text(
                  '加入 WhatsApp 社區',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final Uri whatsappUri = Uri.parse('https://chat.whatsapp.com/Dpx80ytWHgO2FtStV0ntek');
                  launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}