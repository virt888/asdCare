import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'left_menu.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ 新增 URL 啟動功能

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

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
            image: AssetImage('assets/asd_care_wallpaper_04.png'), // ✅ 背景圖片
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(80, 255, 255, 255), // ✅ 讓背景變淡
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏥 標題 + 醫生 ICON
              Row(
                children: [
                  Image.asset(
                    'assets/doctor_icon.png',
                    width: 48,
                    height: 48,
                  ), // 🏥 醫生 ICON
                  const SizedBox(width: 10),
                  const Text(
                    "故事例子 （一）",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildMessageBox("當發現孩子可能有 ASD，家長第一時間應該冷靜，了解應該走的流程，儘早安排支援！"),
              const SizedBox(height: 20),

              _buildStep(
                "👶 1. 兒科醫生的初步診斷",
                "🔹 1 歲時打疫苗，醫生建議我們帶小孩看 ASD 專科。\n🔹 1.5 歲時醫生再提醒，我們才開始重視。",
              ),
              _buildStep(
                "🩺 2. 專科醫生評估（診斷報告很重要！）",
                "🔹 診斷報告是申請政府資助和學前服務的關鍵！\n🔹 有保險的可考慮私家醫生，無保險則需排期到公立醫院。",
              ),
              _buildStep(
                "📂 3. 診斷後立即申請政府資源",
                "🔹 拿著報告到社會福利署（社署）登記。\n🔹 申請學前特殊教育支援（E 位、S 位等）。",
              ),
              _buildStep("🏥 4. 別忘了到醫院排期", "🔹 我們當時忽略了，原來政府醫院醫生的報告有額外補貼！"),
              _buildStep(
                "🎓 5. 特殊學校 or 主流學校？",
                "🔹 4 歲時，我們終於安排孩子進入特殊學校。\n🔹 之前在主流學校，但發現孩子需要小班教學。",
              ),
              _buildStep(
                "💡 6. 最重要的是家長的態度",
                "🔹 無需害怕 ASD，最重要的是早發現、早介入、早支援！\n🔹 整理好資料，儘力幫助孩子適應社會。",
              ),

              const SizedBox(height: 30),

              // ℹ️ 重要連結（白色 INFO BOX）
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(
                    (0.95 * 255).toInt(),
                  ), // ✅ 半透明白底
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/info_icon.png',
                          width: 30,
                          height: 30,
                        ), // ℹ️ INFO ICON
                        const SizedBox(width: 10),
                        const Text(
                          "重要連結",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildLink(
                      "📝 康復服務中央轉介系統輪候冊",
                      "https://www.swd.gov.hk/tc/pubsvc/rehab/cat_crsrehab/crsrehabwa/",
                    ),
                    _buildLink(
                      "🏥 兒童體能及智力測驗中心",
                      "https://www.dhcas.gov.hk/tc/center_info.html",
                    ),
                    _buildLink(
                      "🎓 香港政府 - 特殊教育需要",
                      "https://www.edb.gov.hk/tc/curriculum-development/curriculum-area/special-educational-needs/index.html",
                    ),
                    _buildLink(
                      "📘 香港支援SEN學童及其家長的機構",
                      "https://www.socialcareer.org/blogs/hong-kong-support-for-sen-students-and-parents-list-of-organisations-and-programmes",
                    ),
                    _buildLink("🧩 香港自閉症聯盟", "https://www.autism.hk/"),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /// 📌 流程步驟（鬼腳圖）
  Widget _buildStep(String title, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.95 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: Colors.teal, width: 5)),
          ),
          child: Text(details, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  /// 📨 文字訊息區塊（大 Message Box）
  Widget _buildMessageBox(String message) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.95 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 2),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 🔗 重要連結（可點擊開啟外部網頁）
  Widget _buildLink(String text, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          Uri link = Uri.parse(url);
          if (await canLaunchUrl(link)) {
            await launchUrl(link, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D6D6D), // ✅ 柔和的深灰色
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
