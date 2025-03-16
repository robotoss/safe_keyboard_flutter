package com.robotoss.safe_keyboard_flutter

import android.content.Context
import android.text.Editable
import android.text.InputType
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import kotlin.math.max

class NativeEditTextPlatformView(
    context: Context,
    private val messenger: BinaryMessenger
) : PlatformView {

    // Tracks how many real chars the user has typed so far
    private var localCount = 0

    private var ignoreChanges = false

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
                    } else if (s.length == 2 && localCount > 0) {
                        // Field had 1 random char, now 2 => user typed the second char
                        userChars = s.substring(1, 2)
                    }

                    // Increase localCount
                    localCount += added

                    // Send these new chars to Flutter as INSERT
                    val byteList = userChars.map { it.code.toLong() }
                    api.onInput(KeyboardInput("field", byteList, ActionType.INSERT)) {}
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
                        api.onInput(KeyboardInput("field", null, ActionType.BACKSPACE)) {}
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

    override fun getView(): View = editText
    override fun dispose() {}

    fun requestFocus() {
        editText.requestFocus()
        editText.setSelection(editText.text.length)
    }

    fun clearFocus() {
        editText.clearFocus()
    }

    private fun generateRandomChar(): String {
        val chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return chars.random().toString()
    }
}
