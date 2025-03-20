import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'keyboard_api.dart';

/// A controller for managing text input with a custom keyboard on Android.
///
/// This controller extends [ValueNotifier] to notify listeners about changes in text input.
/// It also implements [KeyboardFlutterApi] to handle keyboard events from the native side.
///
/// **Note:** This implementation is only functional on Android. On other platforms, it will not interact with the keyboard.
class SafeKeyboardEditingController extends ValueNotifier<TextEditingValue>
    implements KeyboardFlutterApi {
  /// Creates a [SafeKeyboardEditingController] with optional initial text.
  ///
  /// The [textEditingController] manages the text input field, and [focusNode] handles focus state.
  SafeKeyboardEditingController({
    String? text,
    required this.textEditingController,
    required this.focusNode,
  }) : super(
         text == null ? TextEditingValue.empty : TextEditingValue(text: text),
       ) {
    if (text?.isNotEmpty ?? false) {
      textEditingController.text = text!;
    }
  }

  /// The Flutter text controller managing text input.
  final TextEditingController textEditingController;

  /// The focus node associated with the input field.
  final FocusNode focusNode;

  /// Handles interactions with the native keyboard API.
  final KeyboardHostApi _hostApi = KeyboardHostApi();

  /// The platform-specific ID for the keyboard input field.
  ///
  /// This ID is used to associate keyboard events with the correct input field.
  int? _platformId;

  /// Returns the platform-specific input field ID.
  ///
  /// Defaults to `0` if not set.
  int get platformId => _platformId ?? 0;

  /// Sets the platform-specific input field ID.
  set platformId(int platformId) {
    _platformId = platformId;
  }

  /// The current text content in the input field.
  String get text => value.text;

  /// Updates the text in the input field.
  ///
  /// When setting a new text value, it updates both the internal state
  /// and the associated [TextEditingController].
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );

    textEditingController.value = value;
  }

  /// Hides the custom keyboard.
  void hideKeyboard() {
    if (Platform.isAndroid) {
      _hostApi.hideKeyboard();
    }
  }

  /// Shows the custom keyboard.
  void showKeyboard() {
    if (Platform.isAndroid) {
      _hostApi.showKeyboard(platformId, text.length);
    }
  }

  /// Handles keyboard input events from the native platform.
  @override
  void onInput(KeyboardInput input) {
    if (!Platform.isAndroid) return;

    if (input.fieldId == platformId) {
      String valueText = value.text;

      if (input.action == ActionType.insert && input.inputBytes != null) {
        // Append new characters to the existing string.
        valueText += utf8.decode(input.inputBytes ?? []);
      } else if (input.action == ActionType.space) {
        // Append a space character.
        valueText += " ";
      } else if (input.action == ActionType.backspace && valueText.isNotEmpty) {
        // Remove the last character when Backspace is pressed.
        valueText = valueText.substring(0, valueText.length - 1);
      }

      text = valueText;
    }
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields.',
    );
    super.value = newValue;
    textEditingController.value = value;
  }

  /// The currently selected range within [text].
  ///
  /// If the selection is collapsed, this property gives the offset of the
  /// cursor within the text.
  TextSelection get selection => value.selection;

  /// Updates the text selection range.
  ///
  /// Ensures that the selection is within valid text bounds.
  /// Notifies listeners when updated.
  set selection(TextSelection newSelection) {
    if (text.length < newSelection.end || text.length < newSelection.start) {
      throw FlutterError('Invalid text selection: $newSelection');
    }
    final TextRange newComposing =
        _isSelectionWithinComposingRange(newSelection)
            ? value.composing
            : TextRange.empty;
    value = value.copyWith(selection: newSelection, composing: newComposing);
  }

  /// Checks if the [selection] is within the composing range.
  bool _isSelectionWithinComposingRange(TextSelection selection) {
    return selection.start >= value.composing.start &&
        selection.end <= value.composing.end;
  }

  /// Clears the text input field.
  ///
  /// After calling this function, [text] will be empty, and the selection
  /// will be collapsed at offset `0`.
  void clear() {
    value = const TextEditingValue(
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  /// Disposes of the controller and releases resources.
  @override
  void dispose() {
    text = '';
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
