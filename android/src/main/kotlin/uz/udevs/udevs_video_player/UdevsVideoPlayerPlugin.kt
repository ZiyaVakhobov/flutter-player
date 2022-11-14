package uz.udevs.udevs_video_player

import android.app.Activity
import android.content.Intent
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.offline.DownloadService
import com.google.gson.Gson
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
import uz.udevs.udevs_video_player.models.DownloadConfiguration
import uz.udevs.udevs_video_player.models.PlayerConfiguration
import uz.udevs.udevs_video_player.services.DownloadTracker
import uz.udevs.udevs_video_player.services.MyDownloadService
import uz.udevs.udevs_video_player.services.MyUtil

const val EXTRA_ARGUMENT = "uz.udevs.udevs_video_player.ARGUMENT"
const val PLAYER_ACTIVITY = 111
const val PLAYER_ACTIVITY_FINISH = 222

class UdevsVideoPlayerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener, PluginRegistry.ActivityResultListener,
    DownloadTracker.Listener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var resultMethod: Result? = null
    private var downloadResult: Result? = null
    private var downloadTracker: DownloadTracker? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "udevs_video_player")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "playVideo") {
            if (call.hasArgument("playerConfigJsonString")) {
                val playerConfigJsonString = call.argument("playerConfigJsonString") as String?
                val gson = Gson()
                val playerConfiguration =
                    gson.fromJson(playerConfigJsonString, PlayerConfiguration::class.java)
                val intent =
                    Intent(activity?.applicationContext, UdevsVideoPlayerActivity::class.java)
                intent.putExtra(EXTRA_ARGUMENT, playerConfiguration)
                activity?.startActivityForResult(intent, PLAYER_ACTIVITY)
                resultMethod = result
            }
        } else if (call.method == "downloadVideo") {
            if (call.hasArgument("downloadConfigJsonString")) {
                val playerConfigJsonString = call.argument("downloadConfigJsonString") as String?
                val gson = Gson()
                val downloadConfiguration =
                    gson.fromJson(playerConfigJsonString, DownloadConfiguration::class.java)
                downloadResult = result
                downloadTracker!!.toggleDownload(MediaItem.fromUri(downloadConfiguration.url))
            }
        } else if (call.method == "checkIsDownloadedVideo") {
            if (call.hasArgument("downloadConfigJsonString")) {
                val playerConfigJsonString = call.argument("downloadConfigJsonString") as String?
                val gson = Gson()
                val downloadConfiguration =
                    gson.fromJson(playerConfigJsonString, DownloadConfiguration::class.java)
                val isDownloaded =
                    downloadTracker!!.isDownloaded(MediaItem.fromUri(downloadConfiguration.url))
                result.success(isDownloaded)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        binding.addOnNewIntentListener(this)
        binding.addActivityResultListener(this)
        downloadTracker = MyUtil().getDownloadTracker( /* context= */activity!!.applicationContext)
        startDownloadService()
        downloadTracker!!.addListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        downloadTracker!!.removeListener(this)
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PLAYER_ACTIVITY && resultCode == PLAYER_ACTIVITY_FINISH) {
            resultMethod?.success(data?.getStringExtra("position"))
        }
        return true
    }


    /** Start the download service if it should be running but it's not currently.  */
    private fun startDownloadService() {
        // Starting the service in the foreground causes notification flicker if there is no scheduled
        // action. Starting it in the background throws an exception if the app is in the background too
        // (e.g. if device screen is locked).
        try {
            DownloadService.start(activity!!.applicationContext, MyDownloadService::class.java)
        } catch (e: IllegalStateException) {
            DownloadService.startForeground(
                activity!!.applicationContext,
                MyDownloadService::class.java
            )
        }
    }

    override fun onDownloadsChanged() {

    }

}
