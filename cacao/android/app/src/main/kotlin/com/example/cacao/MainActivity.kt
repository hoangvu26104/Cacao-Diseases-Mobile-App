package com.example.cacao

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import org.pytorch.IValue
import org.pytorch.Module
import org.pytorch.Tensor
import org.pytorch.torchvision.TensorImageUtils
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "cacao.disease/classifier"
    private lateinit var model: Module

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 🔥 Load mô hình 1 lần duy nhất
        model = Module.load(assetFilePath("shufflenet_scripted.pt"))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "classifyImage") {
                val imageBytes = call.argument<ByteArray>("image")
                if (imageBytes != null) {
                    try {
                        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                        val inputTensor = TensorImageUtils.bitmapToFloat32Tensor(
                            bitmap,
                            floatArrayOf(0.485f, 0.456f, 0.406f),
                            floatArrayOf(0.229f, 0.224f, 0.225f)
                        )

                        val outputTensor = model.forward(IValue.from(inputTensor)).toTensor()
                        val scores = outputTensor.dataAsFloatArray

                        var maxIdx = 0
                        var maxScore = scores[0]
                        for (i in scores.indices) {
                            if (scores[i] > maxScore) {
                                maxScore = scores[i]
                                maxIdx = i
                            }
                        }

                        val resultMap = mapOf(
                            "labelIndex" to maxIdx,
                            "score" to maxScore,
                            "allScores" to scores.toList()
                        )
                        result.success(resultMap)

                    } catch (e: Exception) {
                        result.error("MODEL_ERROR", e.message, null)
                    }
                } else {
                    result.error("NO_IMAGE", "Image data is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }


    // Copy mô hình từ asset vào bộ nhớ nội bộ để PyTorch đọc được
    @Throws(Exception::class)
    private fun assetFilePath(assetName: String): String {
        val file = File(filesDir, assetName)

        if (file.exists() && file.length() > 0) {
            return file.absolutePath
        }

        assets.open(assetName).use { inputStream ->
            FileOutputStream(file).use { outputStream ->
                val buffer = ByteArray(4 * 1024)
                var read: Int
                while (inputStream.read(buffer).also { read = it } != -1) {
                    outputStream.write(buffer, 0, read)
                }
                outputStream.flush()
            }
        }

        return file.absolutePath
    }
}
