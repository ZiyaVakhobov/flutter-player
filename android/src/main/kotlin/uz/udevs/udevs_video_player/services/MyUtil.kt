package uz.udevs.udevs_video_player.services

import android.content.Context
import androidx.media3.database.DatabaseProvider
import androidx.media3.database.StandaloneDatabaseProvider
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.datasource.cache.Cache
import androidx.media3.datasource.cache.NoOpCacheEvictor
import androidx.media3.datasource.cache.SimpleCache
import androidx.media3.exoplayer.offline.DownloadManager
import androidx.media3.exoplayer.offline.DownloadNotificationHelper
import org.checkerframework.checker.nullness.qual.MonotonicNonNull
import org.chromium.net.CronetEngine
import uz.udevs.udevs_video_player.services.cronet.CronetDataSource
import uz.udevs.udevs_video_player.services.cronet.CronetUtil
import java.io.File
import java.net.CookieHandler
import java.net.CookieManager
import java.net.CookiePolicy
import java.util.concurrent.Executors

class MyUtil {
    private var downloadCache: @MonotonicNonNull Cache? = null
    private var databaseProvider: @MonotonicNonNull DatabaseProvider? = null
    private var downloadManager: @MonotonicNonNull DownloadManager? = null
    private var downloadNotificationHelper: @MonotonicNonNull DownloadNotificationHelper? = null
    private var httpDataSourceFactory: @MonotonicNonNull DataSource.Factory? = null
    private var downloadTracker: @MonotonicNonNull DownloadTracker? = null
    private var downloadDirectory: @MonotonicNonNull File? = null

    companion object {
        val DOWNLOAD_NOTIFICATION_CHANNEL_ID = "download_channel"
    }

    private val DOWNLOAD_CONTENT_DIRECTORY = "downloads"
    private val USE_CRONET_FOR_NETWORKING = true

    @Synchronized
    fun getDownloadManager(context: Context): DownloadManager {
        ensureDownloadManagerInitialized(context)
        return downloadManager!!
    }

    @Synchronized
    private fun ensureDownloadManagerInitialized(context: Context) {
        if (downloadManager == null) {
            downloadManager = DownloadManager(
                context,
                getDatabaseProvider(context),
                getDownloadCache(context),
                getHttpDataSourceFactory(context),
                Executors.newFixedThreadPool(6)
            )
            downloadTracker = DownloadTracker(
                context,
                getHttpDataSourceFactory(context),
                downloadManager
            )
        }
    }

    @Synchronized
    private fun getDatabaseProvider(context: Context): DatabaseProvider {
        if (databaseProvider == null) {
            databaseProvider =
                StandaloneDatabaseProvider(context)
        }
        return databaseProvider!!
    }


    @Synchronized
    private fun getDownloadCache(context: Context): Cache {
        if (downloadCache == null) {
            val downloadContentDirectory = File(
                getDownloadDirectory(context),
                DOWNLOAD_CONTENT_DIRECTORY
            )
            downloadCache = SimpleCache(
                downloadContentDirectory,
                NoOpCacheEvictor(),
                getDatabaseProvider(context)
            )
        }
        return downloadCache!!
    }


    @Synchronized
    fun getDownloadNotificationHelper(
        context: Context
    ): DownloadNotificationHelper {
        if (downloadNotificationHelper == null) {
            downloadNotificationHelper =
                DownloadNotificationHelper(
                    context,
                    DOWNLOAD_NOTIFICATION_CHANNEL_ID
                )
        }
        return downloadNotificationHelper!!
    }


    @Synchronized
    fun getHttpDataSourceFactory(context: Context): DataSource.Factory {
        var context = context
        if (httpDataSourceFactory == null) {
            if (USE_CRONET_FOR_NETWORKING) {
                context = context.applicationContext
                val cronetEngine: CronetEngine? = CronetUtil.buildCronetEngine(context)
                if (cronetEngine != null) {
                    httpDataSourceFactory =
                        CronetDataSource.Factory(cronetEngine, Executors.newSingleThreadExecutor())
                }
            }
            if (httpDataSourceFactory == null) {
                // We don't want to use Cronet, or we failed to instantiate a CronetEngine.
                val cookieManager = CookieManager()
                cookieManager.setCookiePolicy(CookiePolicy.ACCEPT_ORIGINAL_SERVER)
                CookieHandler.setDefault(cookieManager)
                httpDataSourceFactory = DefaultHttpDataSource.Factory()
            }
        }
        return httpDataSourceFactory!!
    }


    @Synchronized
    private fun getDownloadDirectory(context: Context): File? {
        if (downloadDirectory == null) {
            downloadDirectory =
                context.getExternalFilesDir(null)
            if (downloadDirectory == null) {
                downloadDirectory = context.filesDir
            }
        }
        return downloadDirectory
    }

}