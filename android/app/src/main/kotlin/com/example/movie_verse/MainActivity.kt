package com.example.movie_verse
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import com.example.movie_verse.AesHelper.cryptoAESHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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
                    try {
                        val decrypt = cryptoAESHandler(encrptedtext,key.toByteArray(),false)?.replace("\\", "")
                        val source = Regex(""""?file"?:\s*"([^"]+)""").find(decrypt.toString())?.groupValues?.get(1)
                        result.success(source);
                    } catch (e: Exception) {
                        result.success("error");
                    }
                }
                else
                {
                    result.success(null);
                }
            }

            if (call.method == "openMxPlayer") {
                val packagename = "com.mxtech.videoplayer.ad"
                val intent = Intent(Intent.ACTION_VIEW)
                intent.setPackage(packagename)
                intent.setDataAndType(
                    Uri.parse(call.argument("videoUrl") as String?),
                    call.argument<Any>("mime") as String?
                )
                val headers = (call.argument<Any>("headers") as Map<String,String>).toList()
                 val headersList = mutableListOf<String>()
                for (pair : Pair<String,String> in headers)
                {
                    headersList.add(pair.first)
                    headersList.add(pair.second)
                }
                intent.putExtra("headers", headersList.toTypedArray())
                intent.putExtra("title", call.argument<Any>("title") as String?)
                this@MainActivity.startActivity(intent)
            }
        }
    }
}