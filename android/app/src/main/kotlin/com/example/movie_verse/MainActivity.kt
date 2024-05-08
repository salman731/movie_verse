package com.example.movie_verse
import android.content.Intent
import android.net.Uri
import android.util.Base64
import androidx.annotation.NonNull
import com.example.movie_verse.AesHelper.base64Encode
import com.example.movie_verse.AesHelper.cryptoAESHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URLDecoder

import javax.crypto.Cipher

import javax.crypto.spec.SecretKeySpec

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

            if(call.method == "getDecodedVidSrcUrl")
            {
                val encrStr = call.argument<Any>("encString") as String?
                var decStr = ""
                if(encrStr != null)
                {
                    decStr = DecryptUrl(encrStr);
                }
                result.success(decStr)
            }

            if(call.method == "getEncodeId")
            {
                val id = call.argument<Any>("id") as String?
                val keys = call.argument<Any>("keys") as List<String>?
                var encodedID = ""
                if(id != null && keys != null)
                {
                    encodedID = encodeId(id,keys)
                }
                result.success(encodedID);

            }

            if(call.method == "getMediaUrl")
            {
                val id = call.argument<Any>("id") as String?
                val script = call.argument<Any>("script") as String?
                val mainUrl = call.argument<Any>("mainUrl") as String?
                val embededUrl = call.argument<Any>("embededUrl") as String?
                var mediaUrl = ""
                if(id != null && script != null && mainUrl != null && embededUrl != null)
                {
                    mediaUrl = callFutoken(script,id,embededUrl,mainUrl)
                }

                result.success(mediaUrl)
            }



        }
    }

    fun DecryptUrl(encUrl: String): String {
        var data = encUrl.toByteArray()
        data = Base64.decode(data, Base64.URL_SAFE)
        val rc4Key = SecretKeySpec("WXrUARXb1aDLaZjI".toByteArray(), "RC4")
        val cipher = Cipher.getInstance("RC4")
        cipher.init(Cipher.DECRYPT_MODE, rc4Key, cipher.parameters)
        data = cipher.doFinal(data)
        return URLDecoder.decode(data.toString(Charsets.UTF_8), "utf-8")
    }

      fun callFutoken(script: String,id :String, url: String,mainUrl :String): String {
        val k = "k='(\\S+)'".toRegex().find(script)?.groupValues?.get(1) ?: return ""
        val a = mutableListOf(k)
        for (i in id.indices) {
            a.add((k[i % k.length].code + id[i].code).toString())
        }
        return "$mainUrl/mediainfo/${a.joinToString(",")}?${url.substringAfter("?")}"
    }

     fun encodeId(id: String, keyList: List<String>): String {
        val cipher1 = Cipher.getInstance("RC4")
        val cipher2 = Cipher.getInstance("RC4")
        cipher1.init(
            Cipher.DECRYPT_MODE,
            SecretKeySpec(keyList[0].toByteArray(), "RC4"),
            cipher1.parameters
        )
        cipher2.init(
            Cipher.DECRYPT_MODE,
            SecretKeySpec(keyList[1].toByteArray(), "RC4"),
            cipher2.parameters
        )
        var input = id.toByteArray()
        input = cipher1.doFinal(input)
        input = cipher2.doFinal(input)
        return base64Encode(input).replace("/", "_")
    }
}