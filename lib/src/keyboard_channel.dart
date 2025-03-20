import 'package:flutter/cupertino.dart';
import 'package:safe_keyboard_flutter/safe_keyboard_flutter.dart';

@protected
class KeyboardChannel implements KeyboardFlutterApi {
  KeyboardChannel._privateConstructor();

  static final KeyboardChannel instance = KeyboardChannel._privateConstructor();

  final ValueNotifier<KeyboardInput?> inputData = ValueNotifier<KeyboardInput?>(null);

  @override
  void onInput(KeyboardInput input) {
    inputData.value = input;
    inputData.value = null;
  }

  void dispose() {}
}
