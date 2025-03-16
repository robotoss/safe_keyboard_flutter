import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_keyboard_flutter/src/keyboard_api.dart';

class SafeKeyboardFlutter extends StatefulWidget {
  final Widget child;
  final void Function(List<int>? text, ActionType action) onInput;
  final void Function(KeyboardHostApi hostApi) onHostApiInit;

  const SafeKeyboardFlutter({
    super.key,
    required this.child,
    required this.onInput,
    required this.onHostApiInit,
  });

  @override
  State<SafeKeyboardFlutter> createState() => _SafeKeyboardFlutterState();
}

class _SafeKeyboardFlutterState extends State<SafeKeyboardFlutter> implements KeyboardFlutterApi {
  final KeyboardHostApi hostApi = KeyboardHostApi();
  final FocusNode flutterFocusNode = FocusNode();
  final String viewType = 'safe_keyboard_flutter/edittext';

  @override
  void initState() {
    super.initState();

    KeyboardFlutterApi.setUp(this);

    widget.onHostApiInit(hostApi);

    flutterFocusNode.addListener(() {
      if (flutterFocusNode.hasFocus) {
        debugPrint('[Flutter] Field focused');
        SystemChannels.textInput.invokeMethod('TextInput.clearClient');
        hostApi.showKeyboard('fieldId');
        SystemChannels.textInput.invokeMethod('TextInput.clearClient');
      } else {
        // debugPrint('[Flutter] Field unfocused');
        // hostApi.hideKeyboard();
      }
    });
  }

  @override
  void dispose() {
    flutterFocusNode.dispose();
    super.dispose();
  }

  @override
  void onInput(KeyboardInput input) {
    // debugPrint('[Flutter] onInput received: ${input.text}');
    widget.onInput(input.inputBytes, input.action);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(flutterFocusNode),
          child: Focus(focusNode: flutterFocusNode, child: widget.child),
        ),
        SizedBox(
          width: double.infinity,
          height: 288,
          child: AndroidView(viewType: viewType, creationParamsCodec: const StandardMessageCodec()),
        ),
      ],
    );
  }
}
