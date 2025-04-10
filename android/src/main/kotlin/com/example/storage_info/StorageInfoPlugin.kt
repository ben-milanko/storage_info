package com.example.storage_info

import android.os.Environment
import android.os.StatFs
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** StorageInfoPlugin */
class StorageInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.storage_info")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getStorageInfo" -> {
        try {
          val externalStorageDirectory = Environment.getExternalStorageDirectory()
          val stat = StatFs(externalStorageDirectory.path)
          
          val blockSize = stat.blockSizeLong
          val totalBlocks = stat.blockCountLong
          val availableBlocks = stat.availableBlocksLong
          
          val totalBytes = totalBlocks * blockSize
          val freeBytes = availableBlocks * blockSize
          
          val response = HashMap<String, Long>()
          response["totalBytes"] = totalBytes
          response["freeBytes"] = freeBytes
          
          result.success(response)
        } catch (e: Exception) {
          result.error("STORAGE_ERROR", e.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
} 