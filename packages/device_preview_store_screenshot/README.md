# device_preview_store_screenshot

Using device_preview to create a screenshot for store from a simulator.

1. Press Take a screenshot under Device Screenshot in the plugin
2. Run a script in the terminal to have it automatically copied and pasted
3. Take a screenshot image of the device from the opened filer

Example:

```
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
```
