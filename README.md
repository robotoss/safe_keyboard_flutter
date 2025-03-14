# 🔐 Safe Keyboard Flutter

A secure and privacy-focused keyboard plugin for Flutter, designed to prevent **text input leaks** and **enhance security** when handling sensitive data (e.g., passwords, PINs). 🚀

## 📢 Why Use This Plugin?

Flutter’s default `TextField` can **leak input data** due to the way it interacts with the native platform. This plugin helps mitigate such issues by ensuring **secure text entry** and preventing sensitive data from lingering in memory.

🔍 **More about the problem:**  
Check this detailed research on **security leaks in Flutter's `TextField`**:  
[Exploring the security leakage issue in Flutter](https://medium.com/@GSYTech/explores-the-text-input-implementation-from-the-security-leakage-of-textfield-with-flutter-7491ebf7370f)

---

## ✅ Features

- 🛡️ **Prevents memory leaks from Flutter's `TextField`**
- 🚀 **Easy integration with existing `TextField`**
- 🔒 **Designed for secure text input handling**

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  safe_keyboard_flutter: latest_version
```

Then run:

```sh
flutter pub get
```

---

## 🛠️ How to Use

Wrap your existing `TextField` inside `SecureTextFieldWrapper`:

```dart
import 'package:safe_keyboard_flutter/safe_keyboard_flutter.dart';

SecureTextFieldWrapper(
  child: TextField(
    obscureText: true, // Extra security for passwords
    decoration: InputDecoration(
      labelText: "Enter Secure Password",
    ),
  ),
)
```

---

## 📊 Platform Support

| Platform | Support Status |
|----------|---------------|
| 🚧 **Android** | In Development |
| ❌ **iOS** | Planned |
| ❌ **Web** | Not Supported |
| ❌ **MacOS** | Not Supported |
| ❌ **Windows** | Not Supported |
| ❌ **Linux** | Not Supported |

🚀 **Currently, the focus is on Android** due to its unique security challenges. iOS support is planned in future releases.

---

## ⚠️ What Problems Does This Solve?

### 🚨 **The Security Issue with Default `TextField`**
By default, Flutter's `TextField` can **leak sensitive data** because:
1. **Keyboard apps** can log user input.
2. **Input is stored in system buffers**, which **third-party apps** might access.
3. **Flutter's text input mechanism does not immediately clear sensitive data from memory**, creating potential leakage risks.

**Check this article for a deep dive:**
[Security Leak in Flutter `TextField`](https://medium.com/@GSYTech/explores-the-text-input-implementation-from-the-security-leakage-of-textfield-with-flutter-7491ebf7370f)

### 🔐 **How `safe_keyboard_flutter` Helps**
- Clears **sensitive input data from memory** immediately after use 🔏
- Prevents **keyboard input logging** 🛡️
- Forces **secure input handling** in sensitive fields (passwords, PINs) 🔑

---

## 💡 Roadmap

- [ ] **Complete Android Support**
- [ ] **iOS Implementation**
- [ ] **Custom Security Features**
- [ ] **Advanced Encryption Support**
- [ ] **Hide screen recorde**

---

## 🤝 Contributing

We welcome contributions! If you have ideas or found issues, feel free to:
- Open a [GitHub Issue](https://github.com/robotoss/safe_keyboard_flutter/issues) 🛠️
- Submit a pull request 📬

---

## ⚖️ License

This project is licensed under the **BSD-3-Clause License**. See [LICENSE](LICENSE) for details.
```

---
