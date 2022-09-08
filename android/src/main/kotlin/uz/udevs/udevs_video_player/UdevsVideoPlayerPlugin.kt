package uz.udevs.udevs_video_player

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import uz.udevs.udevs_video_player.activities.UdevsVideoPlayerActivity
import uz.udevs.udevs_video_player.models.PlayerConfiguration

const val EXTRA_ARGUMENT = "uz.udevs.udevs_video_player.ARGUMENT"

class UdevsVideoPlayerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "udevs_video_player")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "playVideo") {
            if (call.hasArgument("url") && call.hasArgument("lastPosition") && call.hasArgument("title")) {
                val url = call.argument("url") as String?
                val lastPosition = call.argument("lastPosition") as Int?
                val title = call.argument("title") as String?
                val intent = Intent(activity?.applicationContext, UdevsVideoPlayerActivity::class.java)
                intent.putExtra(
                    EXTRA_ARGUMENT,
                    PlayerConfiguration(url!!, lastPosition!!.toLong(), title!!)
                )
                activity?.startActivity(intent)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onNewIntent(intent: Intent): Boolean {
        return true
    }
}
