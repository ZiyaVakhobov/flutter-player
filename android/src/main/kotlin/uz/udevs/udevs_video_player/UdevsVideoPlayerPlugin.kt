package uz.udevs.udevs_video_player

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.Player.TimelineChangeReason
import androidx.media3.common.Timeline
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsManifest
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.PlayerView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val EXTRA_ARGUMENTS = "uz.udevs.udevs_video_player.ARGUMENTS"

class UdevsVideoPlayerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var urls: List<String> = ArrayList()
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "udevs_video_player")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "playVideo") {
            urls = call.arguments as List<String>
            val intent =
                Intent(activity?.applicationContext!!, UdevsVideoPlayerActivity::class.java).apply {
                    putExtra(EXTRA_ARGUMENTS, urls)
                }
            activity?.startActivity(intent)
            activity?.setContentView(R.layout.player)
            val playerView: PlayerView? = activity?.findViewById(R.id.media_view)
            activity?.actionBar?.hide()
            val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
            val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
                .createMediaSource(MediaItem.fromUri(Uri.parse(urls.first())))
            val player = ExoPlayer.Builder(activity?.applicationContext!!).build()
            playerView?.player = player
            playerView?.keepScreenOn = true
            player.setMediaSource(hlsMediaSource)
            player.prepare()

            player.addListener(
                object : Player.Listener {
                    override fun onPlayerError(error: PlaybackException) {
                        println(error.errorCode)
                    }

                    override fun onTimelineChanged(
                        timeline: Timeline, reason: @TimelineChangeReason Int
                    ) {
                        val manifest = player.currentManifest
                        if (manifest != null) {
                            val hlsManifest = manifest as HlsManifest
                            // Do something with the manifest.
                            print(hlsManifest.toString())
                        }
                    }
                })
            player.playWhenReady = true
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    private fun playVideo(url: String) {

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
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
}
