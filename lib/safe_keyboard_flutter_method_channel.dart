import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'safe_keyboard_flutter_platform_interface.dart';

/// An implementation of [SafeKeyboardFlutterPlatform] that uses method channels.
class MethodChannelSafeKeyboardFlutter extends SafeKeyboardFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('safe_keyboard_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
