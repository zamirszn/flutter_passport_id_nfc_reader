package com.scansolutions.mrzflutterplugin_example

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.plugin.common.MethodChannel
import com.gemalto.jp2.JP2Decoder
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.InputStream

object ImageUtil {

    fun decodeImage(context: Context?, jp2ImageData: ByteArray, result: MethodChannel.Result) {
        // Convert JP2 ByteArray to InputStream
        val inputStream: InputStream = ByteArrayInputStream(jp2ImageData)

        // Use the existing decodeImage function
        val decodedBitmap = decodeImage(context, "image/jp2", inputStream)

        // Convert the Bitmap to a ByteArray for sending back to Flutter
        val byteArrayOutputStream = ByteArrayOutputStream()
        decodedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()

        // Send the decoded image back to Flutter
        result.success(byteArray)
    }

    fun decodeImage(context: Context?, mimeType: String, inputStream: InputStream?): Bitmap {
        return if (mimeType.equals("image/jp2", ignoreCase = true) || mimeType.equals(
                "image/jpeg2000",
                ignoreCase = true
            )
        ) {
            JP2Decoder(inputStream).decode()
        } else {
            // Add other decoding logic if needed
            BitmapFactory.decodeStream(inputStream)
        }
    }
}
