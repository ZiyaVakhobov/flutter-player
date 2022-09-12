package uz.udevs.udevs_video_player.activities

import android.app.Activity
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.*
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.Timeline
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerView
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.PlayerConfiguration

class UdevsVideoPlayerActivity : Activity(), View.OnClickListener {

    private var playerView: PlayerView? = null
    private var player: ExoPlayer? = null
    private var playerConfiguration: PlayerConfiguration? = null
    private var close: ImageView? = null
    private var more: ImageView? = null
    private var title: TextView? = null
    private var rewind: ImageView? = null
    private var forward: ImageView? = null
    private var playPause: ImageView? = null
    private var timer: LinearLayout? = null
    private var live: LinearLayout? = null
    private var episodesButton: LinearLayout? = null
    private var episodesText: TextView? = null
    private var nextButton: LinearLayout? = null
    private var nextText: TextView? = null
    private var tvProgramsButton: LinearLayout? = null
    private var tvProgramsText: TextView? = null
    private var zoom: ImageView? = null
    private var orientation: ImageView? = null
    private var exoProgress: DefaultTimeBar? = null
    private var customSeekBar: SeekBar? = null
    private var currentOrientation: Int = Configuration.ORIENTATION_PORTRAIT

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.player)
        actionBar?.hide()
        playerView = findViewById(R.id.exo_player_view)
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?

        close = findViewById(R.id.video_close)
        more = findViewById(R.id.video_more)
        title = findViewById(R.id.video_title)
        title?.text = playerConfiguration?.title

        rewind = findViewById(R.id.video_rewind)
        forward = findViewById(R.id.video_forward)
        playPause = findViewById(R.id.video_play_pause)
        timer = findViewById(R.id.timer)
        if (playerConfiguration?.isLive == true) {
            timer?.visibility = View.GONE
        }
        live = findViewById(R.id.live)
        if (playerConfiguration?.isLive == true) {
            live?.visibility = View.VISIBLE
        }
        episodesButton = findViewById(R.id.button_episodes)
        episodesText = findViewById(R.id.text_episodes)
        if (playerConfiguration?.isSerial == true) {
            episodesButton?.visibility = View.VISIBLE
            episodesText?.text = playerConfiguration?.episodeButtonText
        }
        nextButton = findViewById(R.id.button_next)
        nextText = findViewById(R.id.text_next)
        if (playerConfiguration?.isSerial == true) {
            nextButton?.visibility = View.VISIBLE
            nextText?.text = playerConfiguration?.nextButtonText
        }
        tvProgramsButton = findViewById(R.id.button_tv_programs)
        tvProgramsText = findViewById(R.id.text_tv_programs)
        if (playerConfiguration?.isLive == true) {
            tvProgramsButton?.visibility = View.VISIBLE
            tvProgramsText?.text = playerConfiguration?.tvProgramsText
        }
        zoom = findViewById(R.id.zoom)
        orientation = findViewById(R.id.orientation)
        exoProgress = findViewById(R.id.exo_progress)
        customSeekBar = findViewById(R.id.progress_bar)
        customSeekBar?.isEnabled = false
        if(playerConfiguration?.isLive == true) {
            exoProgress?.visibility = View.GONE
            rewind?.visibility = View.GONE
            forward?.visibility = View.GONE
            customSeekBar?.visibility = View.VISIBLE
        }

        close?.setOnClickListener(this)
        more?.setOnClickListener(this)
        rewind?.setOnClickListener(this)
        forward?.setOnClickListener(this)
        playPause?.setOnClickListener(this)
        episodesButton?.setOnClickListener(this)
        nextButton?.setOnClickListener(this)
        tvProgramsButton?.setOnClickListener(this)
        zoom?.setOnClickListener(this)
        orientation?.setOnClickListener(this)

        playVideo()
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

    private fun playVideo() {
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.url)))
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true

        player?.setMediaSource(hlsMediaSource)
        player?.prepare()
        player?.seekTo(playerConfiguration!!.lastPosition)
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
            R.id.zoom -> {}
            R.id.orientation -> {
                requestedOrientation =
                    if (currentOrientation == Configuration.ORIENTATION_LANDSCAPE) {
                        ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    } else {
                        ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    }
            }
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        currentOrientation = newConfig.orientation
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            setFullScreen()
            zoom?.visibility = View.VISIBLE
            orientation?.setImageResource(R.drawable.ic_portrait)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FILL
        } else {
            cutFullScreen()
            zoom?.visibility = View.GONE
            orientation?.setImageResource(R.drawable.ic_landscape)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
        }
    }

    private fun setFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        WindowInsetsControllerCompat(window, findViewById(R.id.exo_player_view)).let { controller ->
            controller.hide(WindowInsetsCompat.Type.systemBars())
            controller.systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }
    }

    private fun cutFullScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, true)
        WindowInsetsControllerCompat(window, findViewById(R.id.exo_player_view)).show(
            WindowInsetsCompat.Type.systemBars()
        )
    }
}