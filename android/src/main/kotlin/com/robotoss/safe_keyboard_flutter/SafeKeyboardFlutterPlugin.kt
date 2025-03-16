package com.robotoss.safe_keyboard_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.inputmethod.InputMethodManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class SafeKeyboardFlutterPlugin : FlutterPlugin, KeyboardHostApi, ActivityAware {

  private var activity: Activity? = null
  private lateinit var flutterApi: KeyboardFlutterApi

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    KeyboardHostApi.setUp(binding.binaryMessenger, this)
    flutterApi = KeyboardFlutterApi(binding.binaryMessenger)
    binding.platformViewRegistry.registerViewFactory(
      "safe_keyboard_flutter/edittext",
      NativeEditTextViewFactory(binding.binaryMessenger)
    )
    Log.d("SafeKeyboardFlutter", "Plugin attached to engine")
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    KeyboardHostApi.setUp(binding.binaryMessenger, null)
    Log.d("SafeKeyboard", "Plugin detached from engine")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    Log.d("SafeKeyboard", "Plugin attached to activity: ${activity?.javaClass?.simpleName}")
  }

  override fun onDetachedFromActivity() {
    activity = null
    Log.d("SafeKeyboard", "Plugin detached from activity")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
    Log.d("SafeKeyboard", "Detached from activity for config changes")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    Log.d("SafeKeyboard", "Reattached to activity after config changes")
  }

  override fun showKeyboard(fieldId: String) {
    activity?.runOnUiThread {
      val imm = activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as? android.view.inputmethod.InputMethodManager
      val focusedView = activity?.currentFocus

      if (focusedView != null) {
        imm?.showSoftInput(focusedView, android.view.inputmethod.InputMethodManager.SHOW_IMPLICIT)
        Log.d("SafeKeyboard", "Showing keyboard for fieldId: $fieldId")
      } else {
        Log.w("SafeKeyboard", "Cannot show keyboard, no focused view")
      }
    } ?: Log.e("SafeKeyboard", "Cannot show keyboard, activity is null")
  }

  override fun hideKeyboard() {
    activity?.runOnUiThread {
      val imm = activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as? android.view.inputmethod.InputMethodManager
      val view = activity?.currentFocus

      if (view != null) {
        imm?.hideSoftInputFromWindow(view.windowToken, 0)
        view.clearFocus()
        Log.d("SafeKeyboard", "Hiding keyboard")
      } else {
        Log.w("SafeKeyboard", "Cannot hide keyboard, no focused view")
      }
    }
  }
}
