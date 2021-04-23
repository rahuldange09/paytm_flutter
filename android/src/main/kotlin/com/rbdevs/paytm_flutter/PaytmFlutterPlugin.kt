package com.rbdevs.paytm_flutter

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** PaytmFlutterPlugin */
public class PaytmFlutterPlugin: FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var plugin : AllInOneSDKPlugin

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().dartExecutor, "paytm_flutter")
    channel.setMethodCallHandler(this);
  }

// Required for pre flutter 1.12
  companion object {
    private lateinit var activity : Activity
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      activity = registrar.activity()
      val channel = MethodChannel(registrar.messenger(), "paytm_flutter")
      val paytmFlutter = PaytmFlutterPlugin();
      channel.setMethodCallHandler(paytmFlutter);
      registrar.addActivityResultListener(paytmFlutter);

    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    plugin = AllInOneSDKPlugin(activity, call, result)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if(::plugin.isInitialized) {
        plugin.onActivityResult(requestCode, resultCode, data)
      }
    return true
    }

  override fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // activity = null
//    print("")
  }

  override fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    // activity = null
//    print("")

  }
}
