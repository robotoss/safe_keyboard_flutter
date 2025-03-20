import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_keyboard_flutter/src/keyboard_channel.dart';
import 'package:safe_keyboard_flutter/src/keyboard_api.dart';
import 'package:safe_keyboard_flutter/src/safe_keyboard_editing_controller.dart';

class SafeKeyboardFlutter extends StatefulWidget {
  const SafeKeyboardFlutter({
    super.key,
    required this.child,
    required this.controller,
  });

  final Widget child;

  final SafeKeyboardEditingController controller;

  @override
  State<SafeKeyboardFlutter> createState() => _SafeKeyboardFlutterState();
}

class _SafeKeyboardFlutterState extends State<SafeKeyboardFlutter> {
  final String viewType = 'safe_keyboard_flutter/edittext';

  @override
  void initState() {
    super.initState();

    if (!Platform.isAndroid) return;

    KeyboardFlutterApi.setUp(KeyboardChannel.instance);

    KeyboardChannel.instance.inputData.addListener(() {
      final input = KeyboardChannel.instance.inputData.value;
      if (input != null) {
        widget.controller.onInput(input);
      }
    });

    widget.controller.focusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        if (widget.controller.focusNode.hasFocus) {
          widget.controller.showKeyboard();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) return widget.child;

    return Stack(
      children: [
        widget.child,
        SizedBox(
          width: double.infinity,
          height: 1,
          child: AndroidView(
            viewType: viewType,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (platformId) {
              widget.controller.platformId = platformId;
            },
          ),
        ),
      ],
    );
  }
}
