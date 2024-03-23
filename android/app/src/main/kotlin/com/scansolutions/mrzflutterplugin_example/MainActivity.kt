package com.scansolutions.mrzflutterplugin_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import com.scansolutions.mrzflutterplugin_example.ImageUtil

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "image_channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "decodeImage") {
                    val jp2ImageData = call.argument<ByteArray?>("jp2ImageData")
                    if (jp2ImageData != null) {
                        ImageUtil.decodeImage(applicationContext, jp2ImageData, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "jp2ImageData is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
