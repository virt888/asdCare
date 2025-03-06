import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart'; // ✅ 導入 HomePage
import 'about_us.dart'; // ✅ 導入 AboutUsPage
import 'info_page.dart'; // ✅ 導入 InfoPage
import 'support_page.dart'; // ✅ 導入 SupportPage

class LeftMenu extends StatelessWidget {
  const LeftMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menu_banner.png'), // ✅ 放置設計的 BANNER
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('主頁'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ), // ✅ 跳轉到 HomePage
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
                ), // ✅ 跳轉到 InfoPage
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
                ), // ✅ 跳轉到 SupportPage
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
              launchUrl(facebookUri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.black,
            ), // ✅ 使用 FontAwesome WhatsApp 圖示
            title: const Text('WHATSAPP 社區'),
            onTap: () {
              final Uri whatsappUri = Uri.parse(
                'https://chat.whatsapp.com/Dpx80ytWHgO2FtStV0ntek',
              );
              launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.black,
            ), // ✅ 使用 FontAwesome WhatsApp 圖示
            title: const Text('WHATSAPP 免費諮詢'),
            onTap: () {
              final Uri whatsappUri = Uri.parse(
                'https://wa.me/85263618727?text=%E6%88%91%E6%83%B3%E8%AB%8B%E5%95%8F%E4%B8%80%E4%B8%8BASD%20%E8%87%AA%E9%96%89%E7%97%87%E5%82%BE%E5%90%91%E7%9A%84%E6%9B%B4%E5%A4%9A%E8%B3%87%E8%A8%8A',
              );
              launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
            },
          ),          
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('設定'),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('關於我們'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsPage(),
                ), // ✅ 跳轉到 AboutUsPage
              );
            },
          ),
          const Spacer(), // ✅ 讓版本號固定在底部
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '        版本號: v1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
