import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart'
    show YamlAssetLoader;
import 'package:shared_preferences/shared_preferences.dart';

class CustomYamlAssetLoader extends AssetLoader {
  final YamlAssetLoader _loader = YamlAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) {
    return _loader.load(path, locale);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');

  // 先在 if 外宣告 systemLocale
  Locale systemLocale;
  if (WidgetsBinding.instance.platformDispatcher.locales.isNotEmpty) {
    systemLocale = WidgetsBinding.instance.platformDispatcher.locales.first;
  } else {
    systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  }

  // Debug: Print the system's country code and language code
  debugPrint('System country code: ${systemLocale.countryCode}');
  debugPrint('System languageCode: ${systemLocale.languageCode}');

  // 如果 SharedPreferences 裡沒有設定語言，則使用 systemLocale 的語言碼
  if (languageCode == null) {
    languageCode = systemLocale.languageCode;
    debugPrint('languageCode read from systems country code');
  } else {
    debugPrint('languageCode read from shared_preferences');
  }

  // easy localization
  await EasyLocalization.ensureInitialized();
  Locale startLocale;
  if (systemLocale.languageCode == 'zh') {
    if (systemLocale.countryCode == 'HK' || systemLocale.countryCode == 'TW') {
      startLocale = const Locale('zh', 'HK'); // 繁體中文
      debugPrint('startLocale = zh, HK');
    } else if (systemLocale.countryCode == 'CN' ||
        systemLocale.countryCode == 'SG') {
      startLocale = const Locale('zh', 'CN'); // 簡體中文
      debugPrint('startLocale = zh, CN');
    } else {
      // 若 countryCode 不明確，預設為繁體中文
      startLocale = const Locale('zh', 'HK');
      debugPrint('startLocale = zh, HK');
    }
  } else if (systemLocale.languageCode == 'en') {
    startLocale = const Locale('en');
    debugPrint('startLocale = en');
  } else {
    startLocale = const Locale('en'); // 其他語言都以英文為預設
    debugPrint('startLocale = en');
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
      assetLoader: CustomYamlAssetLoader(),
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: ASDCareApp(),
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
      home: MainPage(),
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
