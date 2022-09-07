package uz.udevs.udevs_video_player.activities

import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.Window
import android.view.WindowManager
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.Timeline
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsManifest
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.PlayerView
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class UdevsVideoPlayerActivity : Activity(), View.OnClickListener {

    private var player: ExoPlayer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setFullScreen()
        setContentView(R.layout.player)
        actionBar?.hide()
        val playerView: PlayerView = findViewById(R.id.video_view)
        val playerConfiguration =
            intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?
        playVideo(playerView, playerConfiguration!!.url, playerConfiguration.lastPosition)
    }

    override fun onBackPressed() {
        super.onBackPressed()
        if (player?.isPlaying == true) {
            player?.stop()
        }
    }

    override fun onPause() {
        super.onPause()
        player?.playWhenReady = false
    }

    override fun onResume() {
        super.onResume()
        player?.playWhenReady = true
    }

    override fun onRestart() {
        super.onRestart()
        player?.playWhenReady = true
    }

    private fun setFullScreen() {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )
    }

    private fun playVideo(playerView: PlayerView, url: String, lastPosition: Long) {
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
        player = ExoPlayer.Builder(this).build()
        playerView.player = player
        playerView.keepScreenOn = true
        player?.setMediaSource(hlsMediaSource)
        player?.prepare()
        player?.seekTo(lastPosition)

        player?.addListener(
            object : Player.Listener {
                override fun onPlayerError(error: PlaybackException) {
                    println(error.errorCode)
                }

                override fun onTimelineChanged(
                    timeline: Timeline, reason: @Player.TimelineChangeReason Int
                ) {
                    val manifest = player?.currentManifest
                    if (manifest != null) {
                        val hlsManifest = manifest as HlsManifest
                        // Do something with the manifest.
                        print(hlsManifest.toString())
                    }
                }
            })
        player?.playWhenReady = true
    }

    override fun onClick(p0: View?) {
        when (p0?.id) {
            R.id.video_back -> finish()
        }
    }
}