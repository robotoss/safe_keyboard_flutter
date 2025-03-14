import 'package:flutter_test/flutter_test.dart';
import 'package:safe_keyboard_flutter/safe_keyboard_flutter.dart';
import 'package:safe_keyboard_flutter/safe_keyboard_flutter_platform_interface.dart';
import 'package:safe_keyboard_flutter/safe_keyboard_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSafeKeyboardFlutterPlatform
    with MockPlatformInterfaceMixin
    implements SafeKeyboardFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SafeKeyboardFlutterPlatform initialPlatform = SafeKeyboardFlutterPlatform.instance;

  test('$MethodChannelSafeKeyboardFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSafeKeyboardFlutter>());
  });

  test('getPlatformVersion', () async {
    SafeKeyboardFlutter safeKeyboardFlutterPlugin = SafeKeyboardFlutter();
    MockSafeKeyboardFlutterPlatform fakePlatform = MockSafeKeyboardFlutterPlatform();
    SafeKeyboardFlutterPlatform.instance = fakePlatform;

    expect(await safeKeyboardFlutterPlugin.getPlatformVersion(), '42');
  });
}
