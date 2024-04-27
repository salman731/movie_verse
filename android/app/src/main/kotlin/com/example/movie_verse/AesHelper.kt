package com.example.movie_verse


import android.os.Build
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.json.JsonMapper
import com.fasterxml.jackson.module.kotlin.kotlinModule
import com.fasterxml.jackson.module.kotlin.readValue
import java.security.DigestException
import java.security.MessageDigest
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object AesHelper {

    private const val HASH = "AES/CBC/PKCS5PADDING"
    private const val KDF = "MD5"

    val mapper = JsonMapper.builder().addModule(kotlinModule())
        .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false).build()!!

    fun cryptoAESHandler(
        data: String,
        pass: ByteArray,
        encrypt: Boolean = true,
        padding: String = HASH,
    ): String? {
        val parse = tryParseJson<AesData>(data) ?: return null
        val (key, iv) = generateKeyAndIv(
            pass,
            parse.s.hexToByteArray(),
            ivLength = parse.iv.length / 2,
            saltLength = parse.s.length / 2
        ) ?: return null
        val cipher = Cipher.getInstance(padding)
        return if (!encrypt) {
            cipher.init(Cipher.DECRYPT_MODE, SecretKeySpec(key, "AES"), IvParameterSpec(iv))
            String(cipher.doFinal(base64DecodeArray(parse.ct)))
        } else {
            cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(key, "AES"), IvParameterSpec(iv))
            base64Encode(cipher.doFinal(parse.ct.toByteArray()))
        }
    }

    // https://stackoverflow.com/a/41434590/8166854
    fun generateKeyAndIv(
        password: ByteArray,
        salt: ByteArray,
        hashAlgorithm: String = KDF,
        keyLength: Int = 32,
        ivLength: Int,
        saltLength: Int,
        iterations: Int = 1
    ): Pair<ByteArray,ByteArray>? {

        val md = MessageDigest.getInstance(hashAlgorithm)
        val digestLength = md.digestLength
        val targetKeySize = keyLength + ivLength
        val requiredLength = (targetKeySize + digestLength - 1) / digestLength * digestLength
        val generatedData = ByteArray(requiredLength)
        var generatedLength = 0

        try {
            md.reset()

            while (generatedLength < targetKeySize) {
                if (generatedLength > 0)
                    md.update(
                        generatedData,
                        generatedLength - digestLength,
                        digestLength
                    )

                md.update(password)
                md.update(salt, 0, saltLength)
                md.digest(generatedData, generatedLength, digestLength)

                for (i in 1 until iterations) {
                    md.update(generatedData, generatedLength, digestLength)
                    md.digest(generatedData, generatedLength, digestLength)
                }

                generatedLength += digestLength
            }
            return generatedData.copyOfRange(0, keyLength) to generatedData.copyOfRange(keyLength, targetKeySize)
        } catch (e: DigestException) {
            return null
        }
    }

    fun String.hexToByteArray(): ByteArray {
        check(length % 2 == 0) { "Must have an even length" }
        return chunked(2)
            .map { it.toInt(16).toByte() }
            .toByteArray()
    }

    private data class AesData(
        @JsonProperty("ct") val ct: String,
        @JsonProperty("iv") val iv: String,
        @JsonProperty("s") val s: String
    )

    inline fun <reified T> parseJson(value: String): T {
        return mapper.readValue(value)
    }

    inline fun <reified T> tryParseJson(value: String?): T? {
        return try {
            parseJson(value ?: return null)
        } catch (_: Exception) {
            null
        }
    }


    fun base64Decode(string: String): String {
        return String(base64DecodeArray(string), Charsets.ISO_8859_1)
    }



    fun base64DecodeArray(string: String): ByteArray {
        return try {
            android.util.Base64.decode(string, android.util.Base64.DEFAULT)
        } catch (e: Exception) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Base64.getDecoder().decode(string)
            } else {
                TODO("VERSION.SDK_INT < O")
            }
        }
    }


    fun base64Encode(array: ByteArray): String {
        return try {
            String(android.util.Base64.encode(array, android.util.Base64.NO_WRAP), Charsets.ISO_8859_1)
        } catch (e: Exception) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                String(Base64.getEncoder().encode(array))
            } else {
                TODO("VERSION.SDK_INT < O")
            }
        }
    }

}