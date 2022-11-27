package uz.udevs.udevs_video_player.services

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.media3.common.MediaItem
import androidx.media3.common.util.Util
import androidx.media3.datasource.DataSource
import androidx.media3.exoplayer.RenderersFactory
import androidx.media3.exoplayer.offline.*
import com.google.common.base.Preconditions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.withContext
import java.io.IOException
import java.util.concurrent.CopyOnWriteArraySet
import kotlin.math.roundToInt


class DownloadTracker(
    context: Context,
    dataSourceFactory: DataSource.Factory,
    downloadManager: DownloadManager
) : DownloadHelper.Callback {

    interface Listener {
        fun onDownloadsChanged(download: Download)
    }


    private val TAG = "DownloadTracker"

    private var context: Context
    private var dataSourceFactory: DataSource.Factory? = null
    private var listeners: CopyOnWriteArraySet<Listener>
    private var downloads: HashMap<Uri, Download>
    private var downloadIndex: DownloadIndex
    private var downloadHelper: DownloadHelper? = null
    private var mediaItem: MediaItem? = null
    private val keySetId: ByteArray = ByteArray(0)
    private var downloadManager: DownloadManager

    init {
        this.context = context
        this.dataSourceFactory = dataSourceFactory
        this.downloadManager = downloadManager
        listeners = CopyOnWriteArraySet()
        downloads = HashMap()
        downloadIndex = downloadManager.downloadIndex
        downloadManager.addListener(DownloadManagerListener())
        loadDownloads()
    }


    fun addListener(listener: Listener) {
        listeners.add(Preconditions.checkNotNull(listener))
    }

    fun removeListener(listener: Listener?) {
        listeners.remove(listener)
    }

    fun isDownloaded(mediaItem: MediaItem): Boolean {
        val download = downloads[Preconditions.checkNotNull(mediaItem.localConfiguration).uri]
        return download != null && download.state != Download.STATE_FAILED
    }


    fun toggleDownload(mediaItem: MediaItem, renderersFactory: RenderersFactory) {
        val download = downloads[Preconditions.checkNotNull(mediaItem.localConfiguration).uri]
        if (download != null && download.state != Download.STATE_FAILED) {
            DownloadService.sendRemoveDownload(
                context, MyDownloadService::class.java, download.request.id, false
            )
        } else {
            this.mediaItem = mediaItem
            downloadHelper =
                DownloadHelper.forMediaItem(context, mediaItem, renderersFactory, dataSourceFactory)
            downloadHelper?.prepare(this)
        }
    }

    fun resumeAllDownload() {
        DownloadService.sendResumeDownloads(context, MyDownloadService::class.java, false)
    }

    fun pauseAllDownloading() {
        DownloadService.sendPauseDownloads(context, MyDownloadService::class.java, false)
    }

    private fun loadDownloads() {
        try {
            downloadIndex.getDownloads().use { loadedDownloads ->
                while (loadedDownloads.moveToNext()) {
                    val download = loadedDownloads.download
                    downloads[download.request.uri] = download
                }
            }
        } catch (e: IOException) {
            Log.w(TAG, "Failed to query downloads", e)
        }
    }

    fun getCurrentProgressDownload(mediaItem: MediaItem): Int? {
        val download = downloads[Preconditions.checkNotNull(mediaItem.localConfiguration).uri]
        if (download != null) {
            return 100
        }
        return downloadManager.currentDownloads.find {
            it.request.uri == mediaItem.localConfiguration?.uri
        }?.percentDownloaded?.roundToInt()
    }

    override fun onPrepared(helper: DownloadHelper) {
        startDownload(buildDownloadRequest())
        downloadHelper!!.release()
    }

    override fun onPrepareError(helper: DownloadHelper, e: IOException) {
        e.printStackTrace()
    }

    private fun startDownload(downloadRequest: DownloadRequest) {
        DownloadService.sendAddDownload(
            context, MyDownloadService::class.java, downloadRequest, false
        )
    }

    private fun buildDownloadRequest(): DownloadRequest {
        assert(mediaItem!!.mediaMetadata.title != null)
        return downloadHelper!!
            .getDownloadRequest(Util.getUtf8Bytes(Preconditions.checkNotNull(mediaItem!!.mediaMetadata.title.toString())))
            .copyWithKeySetId(keySetId)
    }

    inner class DownloadManagerListener : DownloadManager.Listener {

        override fun onDownloadChanged(
            downloadManager: DownloadManager,
            download: Download,
            finalException: Exception?
        ) {
            downloads[download.request.uri] = download
            for (listener in listeners) {
                listener.onDownloadsChanged(download)
            }
        }

        override fun onDownloadRemoved(downloadManager: DownloadManager, download: Download) {
            downloads.remove(download.request.uri)
            for (listener in listeners) {
                listener.onDownloadsChanged(download)
            }
        }
    }
}