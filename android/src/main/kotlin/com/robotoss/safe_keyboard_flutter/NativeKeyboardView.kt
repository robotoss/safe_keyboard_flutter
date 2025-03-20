package com.robotoss.safe_keyboard_flutter

import android.content.Context
import android.text.Editable
import android.text.InputType
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import kotlin.math.max

class NativeEditTextPlatformView(
    context: Context,
    private val messenger: BinaryMessenger,
    private val fieldId: Long, // Pass fieldId to identify this instance
    private val plugin: SafeKeyboardFlutterPlugin // Pass plugin reference
) : PlatformView {

    // Tracks how many real chars the user has typed so far
    private var localCount = 0

    private var ignoreChanges = false


    init {
        registerWithPlugin(fieldId, plugin)
    }

    private fun registerWithPlugin(fieldId: Long, plugin: SafeKeyboardFlutterPlugin) {
        plugin.registerEditText(fieldId, this)
    }

    private val editText: EditText = EditText(context).apply {
        inputType = InputType.TYPE_CLASS_TEXT or
                InputType.TYPE_TEXT_VARIATION_PASSWORD or
                InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS

        isLongClickable = false
        isCursorVisible = false
        alpha = 0f // Invisible, but we still need it for IME
        importantForAutofill = View.IMPORTANT_FOR_AUTOFILL_NO

        isFocusable = true
        isFocusableInTouchMode = true
        imeOptions = EditorInfo.IME_ACTION_DONE

        addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

                if (ignoreChanges) return

                val api = KeyboardFlutterApi(messenger)

                // CASE A: Characters inserted
                if (count > before && s != null) {
                    // Typically, (count-before) == 1 in normal typing
                    // The user's character is:
                    val added = count - before
                    var userChars = ""

                    if (s.length == 1) {
                        // Field was empty, now 1 char => user typed exactly that char
                        userChars = s.toString()
                    } else if (s.length > 1 && localCount > 0) {
                        // Always get the last typed character
                        userChars = s.substring(s.length - 1)
                    }

                    // Increase localCount
                    localCount += added

                    // Send these new chars to Flutter as INSERT
                    val byteList = userChars.map { it.code.toLong() }
                    api.onInput(KeyboardInput(fieldId, byteList, ActionType.INSERT)) {}
                }

                // CASE B: Characters removed
                if (before > count) {
                    val removed = before - count

                    // If we had 2 chars in s (random + user), now 1 => user pressed Backspace removing user char
                    // If we had 1 char in s, now 0 => user pressed Backspace removing last user char
                    // localCount can't go below 0
                    localCount = max(0, localCount - removed)

                    // Send BACKSPACE to Flutter for each removed char
                    repeat(removed) {
                        api.onInput(KeyboardInput(fieldId, null, ActionType.BACKSPACE)) {}
                    }
                }
            }

            override fun afterTextChanged(s: Editable?) {
                if (ignoreChanges) return

                // Now we clear the field to avoid storing real data
                ignoreChanges = true
                s?.clear()

                // If localCount > 0, we put exactly 1 random char back
                if (localCount > 0) {
                    val placeholder = generateRandomChar()
                    s?.append(placeholder)
                }

                ignoreChanges = false
            }
        })
    }

    //=========================
    // PlatformView overrides
    //=========================
    override fun getView(): View = editText
    override fun dispose() {}

    //=========================
    // Public methods
    //=========================
    fun requestFocus() {
        editText.requestFocus()
        editText.setSelection(editText.text.length)
    }

    fun clearFocus() {
        editText.clearFocus()
    }



    //=========================
    // KeyboardHostApi methods
    //=========================
    fun showKeyboard() {

        editText.post {
            if (!editText.hasFocus()) {
                editText.requestFocus()
            }

            val imm =
                editText.context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
            if (imm != null) {
                imm.showSoftInput(editText, InputMethodManager.SHOW_FORCED)
            } else {
                Log.e("SafeKeyboard", "InputMethodManager is null, cannot show keyboard")
            }
        }
    }

    fun hideKeyboard() {

        editText.post {
            val imm =
                editText.context.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
            if (imm != null) {
                imm.hideSoftInputFromWindow(editText.windowToken, 0)
            } else {
                Log.e("SafeKeyboard", "InputMethodManager is null, cannot hide keyboard")
            }
            editText.clearFocus()
        }
    }

    /**
     * Set localCount from Flutter.
     * If count == 0 => clear the EditText
     * If count > 0 and EditText is empty => add 1 random char
     */
    fun setLocalCount(count: Long) {

        // Convert to Int
        val newCount = count.toInt()

        // We'll update localCount and fix the EditText accordingly
        ignoreChanges = true

        localCount = max(0, newCount)
        editText.text.clear()


        if (localCount > 0) {
            // Insert 1 random placeholder so that user can backspace
            val placeholder = generateRandomChar()

            editText.text.append(placeholder)


        }

        ignoreChanges = false
    }

    //=========================
    // Helpers
    //=========================
    private fun generateRandomChar(): String {
        val chars =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+<>?/{}[]|"
        val length = (1..6).random() // Generate a random length between 1 and 6
        return (1..length).map { chars.random() }.joinToString("")
    }
}
