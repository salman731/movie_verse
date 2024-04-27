package com.example.movie_verse
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.movie_verse.AesHelper.cryptoAESHandler

class MainActivity: FlutterActivity() {
    private val CHANNEL = "KOTLIN_CHANNEL"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "getEncryptedText")
            {
                val key = call.argument<String>("key")
                val encrptedtext = call.argument<String>("encryptedText");
                if(key != null && encrptedtext != null)
                {
                    val decrypt = cryptoAESHandler(encrptedtext,key.toByteArray(),false)?.replace("\\", "")
                    val source = Regex(""""?file"?:\s*"([^"]+)""").find(decrypt.toString())?.groupValues?.get(1)
                    result.success(source);
                }
                else
                {
                    result.success(null);
                }
            }
        }
    }
}