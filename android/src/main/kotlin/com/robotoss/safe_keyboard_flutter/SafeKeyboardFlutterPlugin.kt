package com.robotoss.safe_keyboard_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class SafeKeyboardFlutterPlugin : FlutterPlugin, KeyboardHostApi, ActivityAware {

    private var activity: Activity? = null
    private lateinit var flutterApi: KeyboardFlutterApi

    private val editTextViews = mutableMapOf<Long, NativeEditTextPlatformView>()


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        KeyboardHostApi.setUp(binding.binaryMessenger, this)
        flutterApi = KeyboardFlutterApi(binding.binaryMessenger)

        binding.platformViewRegistry.registerViewFactory(
            "safe_keyboard_flutter/edittext",
            NativeEditTextViewFactory(binding.binaryMessenger, this) // Pass `this` as plugin
        )

        Log.d("SafeKeyboardFlutter", "Plugin attached to engine")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        KeyboardHostApi.setUp(binding.binaryMessenger, null)
        Log.d("SafeKeyboard", "Plugin detached from engine")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun showKeyboard(fieldId: Long, currentCount: Long) {
        activity?.runOnUiThread {
            editTextViews[fieldId]?.showKeyboard()

            editTextViews[fieldId]?.setLocalCount(currentCount)
        } ?: Log.e("SafeKeyboard", "Cannot show keyboard, activity is null")
    }

    override fun hideKeyboard() {
        activity?.runOnUiThread {
            val imm =
                activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as? android.view.inputmethod.InputMethodManager
            val view = activity?.currentFocus

            if (view != null) {
                imm?.hideSoftInputFromWindow(view.windowToken, 0)
                view.clearFocus()
            } else {
                Log.w("SafeKeyboard", "Cannot hide keyboard, no focused view")
            }
        }
    }

    fun registerEditText(fieldId: Long, view: NativeEditTextPlatformView) {
        editTextViews[fieldId] = view
    }
}
