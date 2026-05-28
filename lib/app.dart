import 'package:flutter/material.dart';

/// Root application widget.
/// Navigation and theming will be expanded in subsequent tasks.
class VeggieMergeApp extends StatelessWidget {
  const VeggieMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veggie Merge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // veggie green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins', // added in TASK-VMG-007
      ),
      // GameScreen will replace this placeholder in TASK-VMG-007.
      home: const _PlaceholderScreen(),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🥦',
              style: TextStyle(fontSize: 64),
            ),
            SizedBox(height: 16),
            Text(
              'Veggie Merge',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Setting up…',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}