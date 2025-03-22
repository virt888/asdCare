import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 強制 widget 依賴 locale，讓它在語言變化時重建
    final _ = context.locale; // 這一行讓 widget 監聽 locale 變化

    return AppBar(
      title: Text(
        'app.bar.title'.tr(),
        style: const TextStyle(
          // fontWeight: FontWeight.bold,
          color: Colors.black, // ✅ 適配淺米色背景
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFF5E8D3), // ✅ 淺米色背景
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black), // ✅ 漢堡選單顏色
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
