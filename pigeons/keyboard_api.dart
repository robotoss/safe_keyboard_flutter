import 'package:pigeon/pigeon.dart';

/// Enumeration of possible keyboard actions
enum ActionType {
  insert,    // Insert regular characters
  space,     // Space key pressed
  backspace, // Backspace key pressed
  enter,     // Enter key pressed
}

class KeyboardInput {
  const KeyboardInput({
    required this.fieldId,
    this.inputBytes, // Now inputBytes is nullable
    required this.action,
  });

  final String fieldId;
  final List<int>? inputBytes; // Nullable inputBytes to handle non-character actions
  final ActionType action; // Defines the action type
}

@HostApi()
abstract class KeyboardHostApi {
  void showKeyboard(String fieldId);
  void hideKeyboard();
}

@FlutterApi()
abstract class KeyboardFlutterApi {
  void onInput(KeyboardInput input);
}
