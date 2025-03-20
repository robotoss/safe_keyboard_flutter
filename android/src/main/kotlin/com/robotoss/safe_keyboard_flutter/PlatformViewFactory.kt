package com.robotoss.safe_keyboard_flutter

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class NativeEditTextViewFactory(
    private val messenger: BinaryMessenger,
    private val plugin: SafeKeyboardFlutterPlugin // Pass plugin reference
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativeEditTextPlatformView(context, messenger, viewId.toLong(), plugin)
    }
}