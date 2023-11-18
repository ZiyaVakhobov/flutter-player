package uz.udevs.udevs_video_player

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.view.View
import androidx.media3.common.MediaItem
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class FlutterVideoPlayerView internal constructor(
    context: Context,
    messenger: BinaryMessenger,
    id: Int
) :
    PlatformView, MethodCallHandler {
    private var playerView: PlayerView
    private var player: ExoPlayer
    private val methodChannel: MethodChannel
    override fun getView(): View {
        return playerView
    }

    init {
        // Init WebView
        player = ExoPlayer.Builder(context).build()
        playerView = PlayerView(context)
        methodChannel = MethodChannel(messenger, "plugins.codingwithtashi/flutter_web_view_$id")
        // Init methodCall Listener
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "setUrl" -> setText(methodCall, result)
            else -> result.notImplemented()
        }
    }

    // set and load new Url
    @SuppressLint("UnsafeOptInUsageError")
    private fun setText(methodCall: MethodCall, result: MethodChannel.Result) {
        val url = methodCall.arguments as String

        val uri = Uri.parse("asset:///flutter_assets/${url}")
//        val uri = Uri.parse("https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8")
        val dataSourceFactory: DataSource.Factory = DefaultDataSource.Factory(playerView.context)
        val mediaSource: MediaSource = ProgressiveMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(uri))
//        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
//            .createMediaSource(MediaItem.fromUri(uri))
        playerView.player = player
        playerView.keepScreenOn = true
        playerView.useController = false
        playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
        player.setMediaSource(mediaSource)
        player.prepare()
        player.playWhenReady = true
        result.success(null)
    }

    // Destroy WebView when PlatformView is destroyed
    override fun dispose() {
        player.pause()
        player.release()
    }

}