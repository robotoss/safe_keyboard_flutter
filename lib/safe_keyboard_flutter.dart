
import 'safe_keyboard_flutter_platform_interface.dart';

class SafeKeyboardFlutter {
  Future<String?> getPlatformVersion() {
    return SafeKeyboardFlutterPlatform.instance.getPlatformVersion();
  }
}
