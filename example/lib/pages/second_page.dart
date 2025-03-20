import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safe_keyboard_flutter/safe_keyboard_flutter.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _loginController = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();

  final _passwordSafeKeyboardEditingController = SafeKeyboardEditingController(
    text: 'random',
    textEditingController: TextEditingController(),
    focusNode: FocusNode(),
  );

  final _secondPasswordSafeKeyboardEditingController = SafeKeyboardEditingController(
    text: '',
    textEditingController: TextEditingController(),
    focusNode: FocusNode(),
  );

  final secondPasswordGlobalKey = GlobalKey();

  bool _obscurePassword = true;

  String test = 'test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login to Your Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("Test Text: $test"),
            const SizedBox(height: 16),
            // Email TextField
            TextFormField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: "Login",
                prefixIcon: const Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password TextField
            SafeKeyboardFlutter(
              controller: _passwordSafeKeyboardEditingController,
              child: TextFormField(
                controller: _passwordSafeKeyboardEditingController.textEditingController,
                obscureText: _obscurePassword,
                focusNode: _passwordSafeKeyboardEditingController.focusNode,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType:
                    Platform.isAndroid ? TextInputType.none : TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(height: 24),
            SafeKeyboardFlutter(
              key: secondPasswordGlobalKey,
              controller: _secondPasswordSafeKeyboardEditingController,
              child: TextFormField(
                controller: _secondPasswordSafeKeyboardEditingController.textEditingController,
                obscureText: true,
                focusNode: _secondPasswordSafeKeyboardEditingController.focusNode,
                decoration: InputDecoration(
                  labelText: "Second Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType:
                    Platform.isAndroid ? TextInputType.none : TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(height: 24),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle login action
                  setState(() {
                    test = 'clear';
                    // _keyboardController?.hideKeyboard();
                  });
                },
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    test = 'dispose_text';

    _loginController.dispose();
    _loginFocusNode.dispose();
    _passwordSafeKeyboardEditingController.dispose();
    _secondPasswordSafeKeyboardEditingController.dispose();

    super.dispose();
  }
}
