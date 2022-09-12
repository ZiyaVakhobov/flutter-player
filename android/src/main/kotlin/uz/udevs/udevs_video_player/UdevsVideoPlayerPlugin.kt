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
import uz.udevs.udevs_video_player.models.Season
import uz.udevs.udevs_video_player.models.TvProgram
import uz.udevs.udevs_video_player.utils.MyHelper

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
            if (call.hasArgument("cryptKey") && call.hasArgument("initialResolution") && call.hasArgument("resolutions") &&
                call.hasArgument("qualityText") && call.hasArgument("speedText") && call.hasArgument("lastPosition") &&
                call.hasArgument("title") && call.hasArgument("isSerial") && call.hasArgument("episodeButtonText") &&
                call.hasArgument("nextButtonText") && call.hasArgument("seasons") && call.hasArgument("isLive") &&
                call.hasArgument("tvProgramsText") && call.hasArgument("tvPrograms")
            ) {

                val cryptKey =
                    call.argument("cryptKey") as String?
                val initialResolution =
                    call.argument("initialResolution") as HashMap<String, String>?
                val resolutions = call.argument("resolutions") as HashMap<String, String>?
                val qualityText = call.argument("qualityText") as String?
                val speedText = call.argument("speedText") as String?
                val lastPosition = call.argument("lastPosition") as Int?
                val title = call.argument("title") as String?
                val isSerial = call.argument("isSerial") as Boolean?
                val episodeButtonText = call.argument("episodeButtonText") as String?
                val nextButtonText = call.argument("nextButtonText") as String?
                val seasonsArg = call.argument("seasons") as HashMap<String, List<String>>?
                val seasons = arrayListOf<Season>()
                seasonsArg?.forEach {
                    seasons.add(Season(it.key, MyHelper().customDecoderMovieList(it.value, cryptKey!!)))
                }
                val isLive = call.argument("isLive") as Boolean?
                val tvProgramsText = call.argument("tvProgramsText") as String?
                val tvProgramsArg = call.argument("tvPrograms") as List<String>?
                val tvPrograms = arrayListOf<TvProgram>()
                tvProgramsArg?.forEach {
                    tvPrograms.add(MyHelper().customDecoderTvProgram(it, cryptKey!!))
                }
                val intent =
                    Intent(activity?.applicationContext, UdevsVideoPlayerActivity::class.java)
                intent.putExtra(
                    EXTRA_ARGUMENT,
                    PlayerConfiguration(
                        initialResolution!!,
                        resolutions!!,
                        qualityText!!,
                        speedText!!,
                        lastPosition!!.toLong(),
                        title!!,
                        isSerial!!,
                        episodeButtonText!!,
                        nextButtonText!!,
                        seasons,
                        isLive!!,
                        tvProgramsText!!,
                        tvPrograms,
                    )
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
