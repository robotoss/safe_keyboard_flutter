import 'dart:convert';

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

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  String test = 'test';

  KeyboardHostApi? _keyboardController;

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
              onInput: (byteData, action) {
                setState(() {
                  if (action == ActionType.insert && byteData != null) {
                    // Append new characters to the existing string
                    test += utf8.decode(byteData);
                  } else if (action == ActionType.space) {
                    // Append a space character
                    test += " ";
                  } else if (action == ActionType.backspace && test.isNotEmpty) {
                    // Remove the last character when Backspace is pressed
                    test = test.substring(0, test.length - 1);
                  }
                });
              },
              onHostApiInit: (keyboardController) {
                _keyboardController = keyboardController;
              },
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
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
                keyboardType: TextInputType.none,
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
                    _keyboardController?.hideKeyboard();
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
    _passwordController.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }
}
