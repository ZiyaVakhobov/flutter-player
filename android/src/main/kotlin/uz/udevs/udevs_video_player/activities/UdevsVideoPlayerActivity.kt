package uz.udevs.udevs_video_player.activities

import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.widget.ImageView
import android.widget.TextView
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.Timeline
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.PlayerView
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class UdevsVideoPlayerActivity : Activity(), View.OnClickListener {

    private var player: ExoPlayer? = null
    private var close: ImageView? = null
    private var more: ImageView? = null
    private var title: TextView? = null
    private var rewind: ImageView? = null
    private var forward: ImageView? = null
    private var playPause: ImageView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player)
        actionBar?.hide()
        val playerView: PlayerView = findViewById(R.id.exo_player_view)
        val playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?

        close = findViewById(R.id.video_close)
        more = findViewById(R.id.video_more)
        title = findViewById(R.id.video_title)
        title?.text = playerConfiguration?.title

        rewind = findViewById(R.id.video_rewind)
        forward = findViewById(R.id.video_forward)
        playPause = findViewById(R.id.video_play_pause)

        close?.setOnClickListener(this)
        more?.setOnClickListener(this)
        rewind?.setOnClickListener(this)
        forward?.setOnClickListener(this)
        playPause?.setOnClickListener(this)

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

                }
            })
        player?.playWhenReady = true
    }

    override fun onClick(p0: View?) {
        when (p0?.id) {
            R.id.video_close -> {
                if (player?.isPlaying == true) {
                    player?.stop()
                }
                finish()
            }
            R.id.video_rewind -> {
                player?.seekTo(player!!.currentPosition - 10000)
            }
            R.id.video_forward -> {
                player?.seekTo(player!!.currentPosition + 10000)
            }
            R.id.video_play_pause -> {
                if (player?.isPlaying == true) {
                    player?.pause()
                    playPause?.setImageResource(R.drawable.ic_play)
                } else {
                    player?.play()
                    playPause?.setImageResource(R.drawable.ic_pause)
                }
            }
        }
    }
}