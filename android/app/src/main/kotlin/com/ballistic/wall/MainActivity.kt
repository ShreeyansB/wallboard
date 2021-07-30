package com.ballistic.wall

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.ballistic/wallpaper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "setWallpaper") {
                val arg = call.argument<String>("uri")
                val photoURI = FileProvider.getUriForFile(
                    context,
                    context.applicationContext.packageName.toString() + ".provider",
                    File(arg!!)
                )
                setWallpaper(photoURI)
                result.success(arg)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setWallpaper(uri : Uri) {
        val intent = Intent(Intent.ACTION_ATTACH_DATA)
        intent.addCategory(Intent.CATEGORY_DEFAULT)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // Android 7.0+ required
        intent.setDataAndType(uri, "image/jpeg")
        intent.putExtra("mimeType", "image/jpeg")
        this.startActivity(Intent.createChooser(intent, "Set as:"))
    }

}
