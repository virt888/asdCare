import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart'; // ✅ 新增這個

import 'home_page.dart';
import 'about_us.dart';
import 'info_page.dart';
import 'support_page.dart';

import 'memory_game.dart'; // ✅ 新增 記憶翻牌遊戲
import 'self_test.dart'; // ✅ 新增 小測驗
import 'source_page.dart'; //

class LeftMenu extends StatefulWidget {
  const LeftMenu({super.key});

  @override
  LeftMenuState createState() => LeftMenuState();
}

class LeftMenuState extends State<LeftMenu> {
  String appVersion = "載入中..."; // 預設值

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  void _loadAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        appVersion = "無法讀取版本";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 🔝 Banner 會從最頂顯示
          Container(
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu_banner.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ 把 SafeArea 包在 Flexible 區塊裡
          Flexible(
            child: SafeArea(
              top: false, // 這行加上就能解決空白
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('主頁'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('深入認識 ASD 世界'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InfoPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.support),
                      title: const Text('資訊/支援'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.memory),
                      title: const Text('小遊戲'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryGamePage(),
                          ), // ✅ 記憶翻牌遊戲
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.memory),
                      title: const Text('小遊戲'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryGamePage(),
                          ), // ✅ 記憶翻牌遊戲
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.memory),
                      title: const Text('小遊戲'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryGamePage(),
                          ), // ✅ 記憶翻牌遊戲
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.memory),
                      title: const Text('小遊戲'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryGamePage(),
                          ), // ✅ 記憶翻牌遊戲
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.assignment), // ✅ 使用問卷圖標
                      title: const Text('小測驗'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelfTestPage(),
                          ), // ✅ 自閉症小測驗
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.facebook),
                      title: const Text('FACEBOOK 社區'),
                      onTap: () {
                        final Uri facebookUri = Uri.parse(
                          'https://www.facebook.com/profile.php?id=61573752815081',
                        );
                        launchUrl(
                          facebookUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.black,
                      ),
                      title: const Text('WHATSAPP 諮詢'),
                      onTap: () {
                        final Uri whatsappUri = Uri.parse(
                          'https://chat.whatsapp.com/LoV9rBJ18KCGSDNJRFLmws?text=%E6%88%91%E6%83%B3%E8%AB%8B%E5%95%8F%E4%B8%80%E4%B8%8BASD%20%E8%87%AA%E9%96%89%E7%97%87%E5%82%BE%E5%90%91%E7%9A%84%E6%9B%B4%E5%A4%9A%E8%B3%87%E8%A8%8A',
                        );
                        launchUrl(
                          whatsappUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text('醫學資訊來源'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SourcePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('關於我們'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '        版本號: v$appVersion',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
