package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.content.res.Resources
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.*
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.*
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerView
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT
import uz.udevs.udevs_video_player.PLAYER_ACTIVITY_FINISH
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.adapters.EpisodePagerAdapter
import uz.udevs.udevs_video_player.adapters.QualitySpeedAdapter
import uz.udevs.udevs_video_player.adapters.TvProgramsPagerAdapter
import uz.udevs.udevs_video_player.models.BottomSheet
import uz.udevs.udevs_video_player.models.PlayerConfiguration
import java.util.*


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
        setContentView(R.layout.player_activity)
        actionBar?.hide()
        playerView = findViewById(R.id.exo_player_view)
        playerConfiguration = intent.getSerializableExtra(EXTRA_ARGUMENT) as PlayerConfiguration?
        currentQuality = playerConfiguration?.initialResolution?.keys?.first()!!

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
        if (playerConfiguration?.seasons?.isNotEmpty() == true) {
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
        if (playerConfiguration?.isLive == true) {
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

        if (playerConfiguration?.playVideoAsset?.keys?.first() == true) {
            playFromAsset()
        } else {
            playVideo()
        }
    }

    override fun onBackPressed() {
        if (player?.isPlaying == true) {
            player?.stop()
        }
        var seconds = 0L
        if (player?.currentPosition != null) {
            seconds = player?.currentPosition!! / 1000
        }
        val intent = Intent()
        intent.putExtra("position", seconds.toString())
        setResult(PLAYER_ACTIVITY_FINISH, intent)
        finish()
        super.onBackPressed()
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


    private fun playFromAsset() {
        val uri =
            Uri.parse("asset:///flutter_assets/${playerConfiguration!!.playVideoAsset.values.first()}")
        val dataSourceFactory: DataSource.Factory = DefaultDataSource.Factory(this)
        val mediaSource: MediaSource = buildMediaSource(uri, dataSourceFactory)
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = false
        player?.setMediaSource(mediaSource)
        player?.prepare()
        player?.playWhenReady = true
    }

    private fun buildMediaSource(
        uri: Uri, mediaDataSourceFactory: DataSource.Factory
    ): MediaSource {
        return ProgressiveMediaSource.Factory(mediaDataSourceFactory)
            .createMediaSource(MediaItem.fromUri(uri))
    }

    private fun playVideo() {
        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
        val hlsMediaSource: HlsMediaSource = HlsMediaSource.Factory(dataSourceFactory)
            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.initialResolution.values.first())))
        player = ExoPlayer.Builder(this).build()
        playerView?.player = player
        playerView?.keepScreenOn = true
        playerView?.useController = playerConfiguration!!.showController
        player?.setMediaSource(hlsMediaSource)
        player?.seekTo(playerConfiguration!!.lastPosition * 1000)
        player?.prepare()
        player?.addListener(
            object : Player.Listener {
                override fun onPlayerError(error: PlaybackException) {
                    println(error.errorCode)
                }

                override fun onIsPlayingChanged(isPlaying: Boolean) {
                    if (isPlaying) {
                        playPause?.setImageResource(R.drawable.ic_pause)
                    } else {
                        playPause?.setImageResource(R.drawable.ic_play)
                    }
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
                var seconds = 0L
                if (player?.currentPosition != null) {
                    seconds = player?.currentPosition!! / 1000
                }
                val intent = Intent()
                intent.putExtra("position", seconds.toString())
                setResult(PLAYER_ACTIVITY_FINISH, intent)
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
                } else {
                    player?.play()
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
            R.id.video_more -> {
                showSettingsBottomSheet()
            }
            R.id.button_episodes -> {
                showEpisodesBottomSheet()
            }
            R.id.button_tv_programs -> {
                showTvProgramsBottomSheet()
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
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
                    backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
                }
                BottomSheet.SETTINGS -> {
                    backButtonSettingsBottomSheet?.visibility = View.VISIBLE
                }
                BottomSheet.TV_PROGRAMS -> {}
                BottomSheet.QUALITY_OR_SPEED -> backButtonQualitySpeedBottomSheet?.visibility =
                    View.VISIBLE
                BottomSheet.NONE -> {}
            }
        } else {
            cutFullScreen()
            zoom?.visibility = View.GONE
            orientation?.setImageResource(R.drawable.ic_landscape)
            playerView?.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
            when (currentBottomSheet) {
                BottomSheet.EPISODES -> {
                    backButtonEpisodeBottomSheet?.visibility = View.GONE
                }
                BottomSheet.SETTINGS -> {
                    backButtonSettingsBottomSheet?.visibility = View.GONE
                }
                BottomSheet.TV_PROGRAMS -> {}
                BottomSheet.QUALITY_OR_SPEED -> backButtonSettingsBottomSheet?.visibility =
                    View.GONE
                BottomSheet.NONE -> {}
            }
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

    private var currentBottomSheet = BottomSheet.NONE

    private fun showTvProgramsBottomSheet() {
        currentBottomSheet = BottomSheet.TV_PROGRAMS
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.behavior.peekHeight = Resources.getSystem().displayMetrics.heightPixels
        bottomSheetDialog.setContentView(R.layout.tv_programs_sheet)
        val backButtonBottomSheet =
            bottomSheetDialog.findViewById<ImageView>(R.id.tv_program_sheet_back)
        backButtonBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val titleBottomSheet = bottomSheetDialog.findViewById<TextView>(R.id.tv_program_sheet_title)
        titleBottomSheet?.text = title?.text
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.tv_programs_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.tv_programs_view_pager)
        viewPager?.adapter = TvProgramsPagerAdapter(this, playerConfiguration!!.programsInfoList)
        TabLayoutMediator(tabLayout!!, viewPager!!) { tab, position ->
            tab.text = playerConfiguration!!.programsInfoList[position].day
        }.attach()
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
        }
    }

    private var backButtonEpisodeBottomSheet: ImageView? = null
    private fun showEpisodesBottomSheet() {
        currentBottomSheet = BottomSheet.EPISODES
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.episodes)
        backButtonEpisodeBottomSheet =
            bottomSheetDialog.findViewById(R.id.episode_sheet_back)
        if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonEpisodeBottomSheet?.visibility = View.GONE
        } else {
            backButtonEpisodeBottomSheet?.visibility = View.VISIBLE
        }
        backButtonEpisodeBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val titleBottomSheet = bottomSheetDialog.findViewById<TextView>(R.id.episodes_sheet_title)
        titleBottomSheet?.text = title?.text
        val tabLayout = bottomSheetDialog.findViewById<TabLayout>(R.id.episode_tabs)
        val viewPager = bottomSheetDialog.findViewById<ViewPager2>(R.id.episode_view_pager)
        viewPager?.adapter = EpisodePagerAdapter(
            this,
            playerConfiguration!!.seasons,
            object : EpisodePagerAdapter.OnClickListener {
                @SuppressLint("SetTextI18n")
                override fun onClick(episodeIndex: Int, seasonIndex: Int) {
                    title?.text =
                        "S${seasonIndex + 1} E${episodeIndex + 1} ${playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].title}"
                    val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                    val hlsMediaSource: HlsMediaSource =
                        HlsMediaSource.Factory(dataSourceFactory)
                            .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.seasons[seasonIndex].movies[episodeIndex].resolutions[currentQuality])))
                    player?.setMediaSource(hlsMediaSource)
                    player?.prepare()
                    player?.playWhenReady
                    bottomSheetDialog.dismiss()
                }
            })
        TabLayoutMediator(tabLayout!!, viewPager!!) { tab, position ->
            tab.text = playerConfiguration!!.seasons[position].title
        }.attach()
        bottomSheetDialog.show()
        player?.pause()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
            player?.play()
        }
    }

    private var speeds =
        mutableListOf("0.25x", "0.5x", "0.75x", "1.0x", "1.25x", "1.5x", "1.75x", "2.0x")
    private var currentQuality = ""
    private var currentSpeed = "1.0x"
    private var qualityText: TextView? = null
    private var speedText: TextView? = null

    private var backButtonSettingsBottomSheet: ImageView? = null
    private fun showSettingsBottomSheet() {
        currentBottomSheet = BottomSheet.SETTINGS
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.settings_bottom_sheet)
        backButtonSettingsBottomSheet = bottomSheetDialog.findViewById(R.id.settings_sheet_back)
        if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonSettingsBottomSheet?.visibility = View.GONE
        } else {
            backButtonSettingsBottomSheet?.visibility = View.VISIBLE
        }
        backButtonSettingsBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val quality = bottomSheetDialog.findViewById<LinearLayout>(R.id.quality)
        val speed = bottomSheetDialog.findViewById<LinearLayout>(R.id.speed)
        qualityText = bottomSheetDialog.findViewById(R.id.quality_settings_value_text)
        speedText = bottomSheetDialog.findViewById(R.id.speed_settings_value_text)
        qualityText?.text = currentQuality
        speedText?.text = currentSpeed
        quality?.setOnClickListener {
            showQualitySpeedSheet(
                currentQuality,
                playerConfiguration?.resolutions?.keys?.toList() as ArrayList,
                true,
            )
        }
        speed?.setOnClickListener {
            showQualitySpeedSheet(currentSpeed, speeds as ArrayList, false)
        }
        bottomSheetDialog.show()
        player?.pause()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.NONE
            player?.play()
        }
    }

    private var backButtonQualitySpeedBottomSheet: ImageView? = null
    private fun showQualitySpeedSheet(
        initialValue: String,
        list: ArrayList<String>,
        fromQuality: Boolean
    ) {
        currentBottomSheet = BottomSheet.QUALITY_OR_SPEED
        val bottomSheetDialog = BottomSheetDialog(this)
        bottomSheetDialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        bottomSheetDialog.setContentView(R.layout.quality_speed_sheet)
        backButtonQualitySpeedBottomSheet =
            bottomSheetDialog.findViewById(R.id.quality_speed_sheet_back)
        if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
            backButtonQualitySpeedBottomSheet?.visibility = View.GONE
        } else {
            backButtonQualitySpeedBottomSheet?.visibility = View.VISIBLE
        }
        backButtonQualitySpeedBottomSheet?.setOnClickListener {
            bottomSheetDialog.dismiss()
        }
        val listView = bottomSheetDialog.findViewById<View>(R.id.quality_speed_listview) as ListView
        val adapter = QualitySpeedAdapter(
            initialValue,
            this,
            list, (object : QualitySpeedAdapter.OnClickListener {
                override fun onClick(position: Int) {
                    if (fromQuality) {
                        currentQuality = list[position]
                        qualityText?.text = currentQuality
                        if (player?.isPlaying == true) {
                            player?.pause()
                        }
                        val currentPosition = player?.currentPosition
                        val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
                        val hlsMediaSource: HlsMediaSource =
                            HlsMediaSource.Factory(dataSourceFactory)
                                .createMediaSource(MediaItem.fromUri(Uri.parse(playerConfiguration!!.resolutions[currentQuality])))
                        player?.setMediaSource(hlsMediaSource)
                        player?.seekTo(currentPosition!!)
                        player?.prepare()
                        player?.playWhenReady
                    } else {
                        currentSpeed = list[position]
                        speedText?.text = currentSpeed
                        player?.setPlaybackSpeed(currentSpeed.replace("x", "").toFloat())
                    }
                    bottomSheetDialog.dismiss()
                }
            })
        )
        listView.adapter = adapter
        bottomSheetDialog.show()
        bottomSheetDialog.setOnDismissListener {
            currentBottomSheet = BottomSheet.SETTINGS
        }
    }
}