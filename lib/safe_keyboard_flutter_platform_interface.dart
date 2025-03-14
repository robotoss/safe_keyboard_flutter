import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'safe_keyboard_flutter_method_channel.dart';

abstract class SafeKeyboardFlutterPlatform extends PlatformInterface {
  /// Constructs a SafeKeyboardFlutterPlatform.
  SafeKeyboardFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SafeKeyboardFlutterPlatform _instance = MethodChannelSafeKeyboardFlutter();

  /// The default instance of [SafeKeyboardFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSafeKeyboardFlutter].
  static SafeKeyboardFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SafeKeyboardFlutterPlatform] when
  /// they register themselves.
  static set instance(SafeKeyboardFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
