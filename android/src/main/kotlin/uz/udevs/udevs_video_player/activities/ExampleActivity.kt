package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.media3.common.MediaItem
import androidx.media3.common.MediaMetadata
import androidx.media3.common.util.Util
import androidx.media3.exoplayer.RenderersFactory
import androidx.media3.exoplayer.offline.Download
import androidx.media3.exoplayer.offline.DownloadService
import uz.udevs.udevs_video_player.EXTRA_ARGUMENT1
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.DownloadConfiguration
import uz.udevs.udevs_video_player.services.DownloadTracker
import uz.udevs.udevs_video_player.services.DownloadUtil
import uz.udevs.udevs_video_player.services.MyDownloadService
import kotlin.math.roundToInt

class ExampleActivity : AppCompatActivity(), DownloadTracker.Listener {
    private var downloadTracker: DownloadTracker? = null
    private lateinit var renderersFactory: RenderersFactory
    private lateinit var downloadConfiguration: DownloadConfiguration
    lateinit var text: TextView
    private lateinit var downloadButton: Button
    lateinit var removeAllButton: Button
    lateinit var pauseAllButton: Button
    lateinit var resumeAllButton: Button
    private var isDownloaded = false

    private val playerViewModel by lazy {
        ViewModelProvider(this)[PlayerViewModel::class.java]
    }

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_example)
        downloadConfiguration =
            intent.getSerializableExtra(EXTRA_ARGUMENT1) as DownloadConfiguration

        initialize()

        downloadTracker = DownloadUtil.getDownloadTracker(this)
        startDownloadService(this)
        renderersFactory =
            DownloadUtil.buildRenderersFactory(this, false)
        isDownloaded =
            downloadTracker!!.isDownloaded(MediaItem.fromUri(downloadConfiguration.url))
        if (isDownloaded) {
            downloadButton.text = "Downloaded"
        }

        playerViewModel.downloadPercent.observe(this) {
            it?.let {
                text.text = it.roundToInt().toString()
            }
        }
    }

    private fun initialize() {
        text = findViewById(R.id.percent)
        downloadButton = findViewById(R.id.btn)
        removeAllButton = findViewById(R.id.removeAll)
        pauseAllButton = findViewById(R.id.pauseAll)
        resumeAllButton = findViewById(R.id.resumeAll)
        downloadButton.setOnClickListener {
            val uri = Uri.parse(downloadConfiguration.url)
            val adaptiveMimeType: String? =
                Util.getAdaptiveMimeTypeForContentType(Util.inferContentType(uri))
            val mediaItem = MediaItem.Builder()
                .setUri(uri)
                .setMediaMetadata(MediaMetadata.Builder().setTitle("My title").build())
                .setMimeType(adaptiveMimeType).build()
            downloadTracker?.toggleDownload(mediaItem, renderersFactory)
        }
        removeAllButton.setOnClickListener {
            downloadTracker?.removeAllDownload()
        }
        pauseAllButton.setOnClickListener {
            downloadTracker?.pauseAllDownloading()
        }
        resumeAllButton.setOnClickListener {
            downloadTracker?.resumeAllDownload()
        }
    }

    override fun onStart() {
        super.onStart()
        downloadTracker!!.addListener(this)
    }

    override fun onStop() {
        playerViewModel.stopFlow()
        downloadTracker!!.removeListener(this)
        super.onStop()
    }


    /** Start the download service if it should be running but it's not currently.  */
    private fun startDownloadService(context: Context) {
        // Starting the service in the foreground causes notification flicker if there is no scheduled
        // action. Starting it in the background throws an exception if the app is in the background too
        // (e.g. if device screen is locked).
        try {
            DownloadService.start(context, MyDownloadService::class.java)
        } catch (e: IllegalStateException) {
            DownloadService.startForeground(
                context,
                MyDownloadService::class.java
            )
        }
    }

    override fun onDownloadsChanged(download: Download) {
        when (download.state) {
            Download.STATE_DOWNLOADING -> {
                playerViewModel.startFlow(this, download.request.uri)
            }
            Download.STATE_QUEUED, Download.STATE_STOPPED -> {}
            Download.STATE_COMPLETED -> {}
            Download.STATE_REMOVING -> {}
            Download.STATE_FAILED, Download.STATE_RESTARTING -> {}
        }
    }

}