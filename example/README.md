# 🔐 Safe Keyboard Flutter - Example App

This example demonstrates how to use **`safe_keyboard_flutter`** to prevent sensitive text input from being leaked in memory.

## 📢 Purpose of This Example

The goal is to test whether `safe_keyboard_flutter` successfully prevents **password data** from being stored in memory while allowing normal logging for non-sensitive fields.

📌 **Testing Process:**  
We will check if the password field remains secure by performing **memory forensics** on an Android emulator.

---

## 🚀 How to Run the Example

1. Ensure you have **Flutter installed** and set up an **Android emulator**.
2. Clone this repository and navigate to the `example` folder:

   ```sh
   git clone https://github.com/YOUR_USERNAME/safe_keyboard_flutter.git
   cd safe_keyboard_flutter/example
   ```

3. Run the application:

   ```sh
   flutter run
   ```

---

## 🛠️ How to Test Security

We will perform **Android memory forensics** to check whether the password input remains in memory.

### 📋 **Testing Instructions**
1. **Start the Android emulator** and launch the example app.
2. **Navigate to the second screen** in the app.
3. **Enter text in the following fields:**
    - **Login field** → This field uses the **old** text handling approach and may be stored in memory.
    - **Password field** → This field uses **`safe_keyboard_flutter`**, and its contents should not be found in memory dumps.
4. Follow this guide to **dump the app's memory**:
    - 📖 [Memory Forensics - Dumping Android Application Memory](https://medium.com/@softMonkeys/memory-forensics-dumping-android-application-memory-1f3f092298e3)
    - Can help: adb shell / su / then command to start frida
5. **Analyze the memory dump** to verify:
    - The **login field data may be present** (old approach).
    - The **password field data should not be found** (new secure approach).

---

## 📊 Expected Results

| Field  | Security Approach | Expected in Memory Dump? |
|--------|------------------|--------------------------|
| **Login** | Standard Flutter `TextField` | ✅ Yes (Old approach) |
| **Password** | `safe_keyboard_flutter` | ❌ No (New secure approach) |

If the password **is not found** in memory dumps, this confirms that `safe_keyboard_flutter` effectively prevents sensitive data leaks.

---

## 📅 Roadmap

- [x] **Android testing**
- [ ] **Improve debugging tools**
- [ ] **Implement iOS support**
- [ ] **Advanced memory security features**

---

## 🤝 Contributing

If you encounter any issues or have suggestions, feel free to:
- Open a [GitHub Issue](https://github.com/YOUR_USERNAME/safe_keyboard_flutter/issues) 🛠️
- Submit a pull request 📬

---

## ⚖️ License

This example app is part of **`safe_keyboard_flutter`**, licensed under the **BSD-3-Clause License**. See [LICENSE](../LICENSE) for details.
```
