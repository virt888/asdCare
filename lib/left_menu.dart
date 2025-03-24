import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart'; // ✅ 新增這個
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      title: Text('left.menu.home'.tr()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text('left.menu.asd.world'.tr()),
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
                      title: Text('left.menu.support'.tr()),
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
                      title: Text('left.menu.game.1'.tr()),
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
                      title: Text('left.menu.test'.tr()),
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
                      title: Text('left.menu.facebook'.tr()),
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
                      title: Text('left.menu.whatsapp'.tr()),
                      onTap: () {
                        final Uri whatsappUri = Uri.parse(
                          'https://chat.whatsapp.com/KSaVDBs9E9ABn34UezfgjG?text=我想請問一下ASD自閉症傾向的更多資訊',
                        );
                        launchUrl(
                          whatsappUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: Text('left.menu.source'.tr()),
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
                      title: Text('left.menu.about'.tr()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text('left.menu.language'.tr()),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (value) async {
                          Locale newLocale;
                          switch (value) {
                            case 'zh-TW':
                              newLocale = const Locale('zh', 'HK');
                              break;
                            case 'zh-CN':
                              newLocale = const Locale('zh', 'CN');
                              break;
                            case 'en':
                              newLocale = const Locale('en');
                              break;
                            default:
                              newLocale = const Locale('en');
                          }
                          await context.setLocale(newLocale);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('language_code', value);
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'zh-TW',
                                child: Text('繁體中文'),
                              ),
                              const PopupMenuItem(
                                value: 'zh-CN',
                                child: Text('简体中文'),
                              ),
                              const PopupMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                            ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'left.menu.version'.tr(namedArgs: {'appVersion': appVersion}),
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
