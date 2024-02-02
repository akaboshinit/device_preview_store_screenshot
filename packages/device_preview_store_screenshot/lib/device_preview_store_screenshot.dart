library device_preview_store_screenshot;

import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DevicePreviewScreenshotTool extends StatelessWidget {
  const DevicePreviewScreenshotTool({
    super.key,
    this.deviceFilePath = '/device_preview_screenshot',
    this.outputFilePath = '~/Downloads',
  });

  final String deviceFilePath;
  final String outputFilePath;

  @override
  Widget build(BuildContext context) {
    return ToolPanelSection(
      title: 'Device Screenshot',
      children: [
        DevicePreviewScreenshot(
          deviceFilePath: deviceFilePath,
          outputFilePath: outputFilePath,
        ),
      ],
    );
  }
}

class DevicePreviewScreenshot extends StatefulWidget {
  const DevicePreviewScreenshot({
    super.key,
    required this.deviceFilePath,
    required this.outputFilePath,
  });

  final String deviceFilePath;
  final String outputFilePath;

  @override
  State<DevicePreviewScreenshot> createState() =>
      _DevicePreviewScreenshotState();
}

class _DevicePreviewScreenshotState extends State<DevicePreviewScreenshot> {
  String? description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Take a screenshot'),
      subtitle: description != null
          ? Text(description!)
          : const Text(
              'Take a screenshot of iPad,iPhone,Android devices.',
            ),
      onTap: () => _takeScreenshot(
        context: context,
        deviceFilePath: widget.deviceFilePath,
        outputFilePath: widget.outputFilePath,
        onUpdate: (value) {
          setState(() {
            description = value;
          });
        },
      ),
    );
  }
}

/// Take a screenshotボタンを押すとクリップボードに便利コマンドがコピーされる
Future<void> _takeScreenshot({
  required BuildContext context,
  required void Function(String value) onUpdate,
  required String deviceFilePath,
  required String outputFilePath,
}) async {
  onUpdate('Start taking screenshots.');

  final timestamp = DateTime.now();
  final tempDir = await getApplicationCacheDirectory();
  final rootFolder = Directory(tempDir.path + deviceFilePath)..createSync();

  for (final deviceIdentifier in _deviceList) {
    if (!context.mounted) {
      return;
    }
    DevicePreview.selectDevice(
      context,
      deviceIdentifier,
    );
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!context.mounted) {
      return;
    }
    final screenshot = await DevicePreview.screenshot(context);

    final file = await File(
      '${rootFolder.path}/${screenshot.device.name}_$timestamp.png',
    ).create();
    file.writeAsBytesSync(screenshot.bytes);

    onUpdate('Screenshot saved: ${screenshot.device.name}');
  }

  // スクショがあるディレクトリのpngファイルをoutputFilePathに移動するコマンドと削除コマンドをクリップボードにセット
  final message = '''
mv ${rootFolder.path}/*.png $outputFilePath
''';

  if (kDebugMode) {
    print(message);
  }
  await Clipboard.setData(ClipboardData(text: message));

  onUpdate('Complete taking screenshots. Execute clipboard commands.');
}

const _deviceList = [
  DeviceIdentifier(
    TargetPlatform.android,
    DeviceType.phone,
    'sony-xperia-1-ii',
  ),
  DeviceIdentifier(
    TargetPlatform.iOS,
    DeviceType.tablet,
    'ipad-pad-pro-11inches',
  ),
  DeviceIdentifier(
    TargetPlatform.iOS,
    DeviceType.phone,
    'iphone-se',
  ),
  DeviceIdentifier(
    TargetPlatform.iOS,
    DeviceType.phone,
    'iphone-13-pro-max',
  ),
];
