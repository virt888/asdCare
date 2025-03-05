import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // ✅ 初始化 AdMob
  runApp(const ASDCareApp());
}

class ASDCareApp extends StatelessWidget {
  const ASDCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASD CARE',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/asd_care_wallpaper.png'), // ✅ 更新背景圖片
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // ✅ 按鈕放低一些
          children: [
            const SizedBox(height: 50), // ✅ 增加空間，讓按鈕不擋住圖片重點
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Color.fromARGB(204, 255, 255, 255), // ✅ 使用 .fromARGB 替代 withOpacity
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text(
                '進入',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 80), // ✅ 讓按鈕位置更接近畫面底部但不貼邊
          ],
        ),
      ),
    );
  }
}