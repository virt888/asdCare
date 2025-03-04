import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'ASD CARE 關懷',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // ✅ 適配淺米色背景
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFFF5E8D3), // ✅ 淺米色背景
      leading: Builder(
        builder: (context) => IconButton(
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
