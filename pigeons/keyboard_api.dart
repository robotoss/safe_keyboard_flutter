import 'package:pigeon/pigeon.dart';

/// Enumeration of possible keyboard actions
enum ActionType {
  insert, // Insert regular characters
  space, // Space key pressed
  backspace, // Backspace key pressed
  enter, // Enter key pressed
}

class KeyboardInput {
  const KeyboardInput({
    required this.fieldId,
    this.inputBytes, // Now inputBytes is nullable
    required this.action,
  });

  final int fieldId;
  final List<int>?
  inputBytes; // Nullable inputBytes to handle non-character actions
  final ActionType action; // Defines the action type
}

@HostApi()
abstract class KeyboardHostApi {
  /// Sets the localCount on Android side.
  /// If count == 0, clear the field.
  /// Otherwise, insert one random placeholder if the field is empty.
  void showKeyboard(int fieldId, int currentCount);

  void hideKeyboard();
}

@FlutterApi()
abstract class KeyboardFlutterApi {
  /// Called by Android when user input is detected
  void onInput(KeyboardInput input);
}
