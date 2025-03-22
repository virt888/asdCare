import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');
  if (languageCode == null) {
    Locale systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    languageCode = systemLocale.languageCode;
  }

  // easy localization
  await EasyLocalization.ensureInitialized();
  Locale? startLocale;
  if (languageCode == 'zh-HK' || languageCode == 'zh_TW') {
    startLocale = const Locale('zh', 'HK'); // 繁體中文
  } else if (languageCode == 'zh' ||
      languageCode == 'zh-CN' ||
      languageCode == 'zh_SG') {
    startLocale = const Locale('zh', 'CN'); // 簡體中文
  } else {
    startLocale = const Locale('en'); // 英文預設
  }

  MobileAds.instance.initialize(); // ✅ 初始化 AdMob

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('zh', 'HK'),
        Locale('zh', 'CN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: const ASDCareApp(),
    ),
  );
}

class ASDCareApp extends StatelessWidget {
  const ASDCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASD CARE',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainPage(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Color.fromARGB(
                  204,
                  255,
                  255,
                  255,
                ), // ✅ 使用 .fromARGB 替代 withOpacity
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
              child: Text(
                'enter'.tr(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 80), // ✅ 讓按鈕位置更接近畫面底部但不貼邊
          ],
        ),
      ),
    );
  }
}
