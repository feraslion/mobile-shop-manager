import 'package:flutter/material.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الموردين')),
      body: const Center(child: Text('شاشة إدارة الموردين')),
    );
  }
}

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المحافظ')),
      body: const Center(child: Text('شاشة إدارة المحافظ')),
    );
  }
}

class CashDrawerScreen extends StatelessWidget {
  const CashDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدرج')),
      body: const Center(child: Text('شاشة إدارة الدرج')),
    );
  }
}
