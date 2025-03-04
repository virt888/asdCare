import 'package:flutter/material.dart';

class SelfTestScreen extends StatelessWidget {
  const SelfTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自我測試'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          '這是自我測試頁面',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}