import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'left_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_page.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
              Text(
                'home.page.heading.1'.tr(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'home.page.heading.2'.tr(),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'home.page.heading.3'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.info, color: Colors.white),
                label: Text(
                  'home.page.button.1'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                label: Text(
                  'home.page.button.2'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final Uri facebookUri = Uri.parse(
                    'https://www.facebook.com/profile.php?id=61573752815081',
                  );
                  launchUrl(facebookUri, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                ),
                label: Text(
                  'home.page.button.3'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final Uri whatsappUri = Uri.parse(
                    'https://chat.whatsapp.com/LoV9rBJ18KCGSDNJRFLmws?text=%E6%88%91%E6%83%B3%E8%AB%8B%E5%95%8F%E4%B8%80%E4%B8%8BASD%20%E8%87%AA%E9%96%89%E7%97%87%E5%82%BE%E5%90%91%E7%9A%84%E6%9B%B4%E5%A4%9A%E8%B3%87%E8%A8%8A',
                  );
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
