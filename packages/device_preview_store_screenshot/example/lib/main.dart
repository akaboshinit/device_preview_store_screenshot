import 'package:device_preview/device_preview.dart';
import 'package:device_preview_store_screenshot/device_preview_store_screenshot.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
      tools: const [
        ...DevicePreview.defaultTools,
        DevicePreviewScreenshotTool(),
      ],
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
