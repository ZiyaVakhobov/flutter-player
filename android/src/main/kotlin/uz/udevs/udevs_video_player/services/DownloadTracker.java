package uz.udevs.udevs_video_player.services;

import static com.google.common.base.Preconditions.checkNotNull;

import android.content.Context;
import android.content.DialogInterface;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.media3.common.C;
import androidx.media3.common.DrmInitData;
import androidx.media3.common.Format;
import androidx.media3.common.MediaItem;
import androidx.media3.common.TrackGroup;
import androidx.media3.common.TrackSelectionOverride;
import androidx.media3.common.TrackSelectionParameters;
import androidx.media3.common.util.Util;
import androidx.media3.datasource.DataSource;
import androidx.media3.exoplayer.drm.DrmSession;
import androidx.media3.exoplayer.drm.DrmSessionEventListener;
import androidx.media3.exoplayer.drm.OfflineLicenseHelper;
import androidx.media3.exoplayer.offline.Download;
import androidx.media3.exoplayer.offline.DownloadCursor;
import androidx.media3.exoplayer.offline.DownloadHelper;
import androidx.media3.exoplayer.offline.DownloadIndex;
import androidx.media3.exoplayer.offline.DownloadManager;
import androidx.media3.exoplayer.offline.DownloadRequest;
import androidx.media3.exoplayer.offline.DownloadService;
import androidx.media3.exoplayer.source.TrackGroupArray;
import androidx.media3.exoplayer.trackselection.DefaultTrackSelector;
import androidx.media3.exoplayer.trackselection.MappingTrackSelector;

import com.google.common.collect.ImmutableList;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArraySet;

import uz.udevs.udevs_video_player.R;

/**
 * Tracks media that has been downloaded.
 */
public class DownloadTracker {

    /**
     * Listens for changes in the tracked downloads.
     */
    public interface Listener {

        /**
         * Called when the tracked downloads changed.
         */
        void onDownloadsChanged();
    }

    private static final String TAG = "DownloadTracker";
    public static final ImmutableList<Integer> SUPPORTED_TRACK_TYPES =
            ImmutableList.of(C.TRACK_TYPE_VIDEO, C.TRACK_TYPE_AUDIO, C.TRACK_TYPE_TEXT);

    private final Context context;
    private final DataSource.Factory dataSourceFactory;
    private final CopyOnWriteArraySet<Listener> listeners;
    private final HashMap<Uri, Download> downloads;
    private final DownloadIndex downloadIndex;

    @Nullable
    private StartDownloadDialogHelper startDownloadDialogHelper;

    public DownloadTracker(
            Context context, DataSource.Factory dataSourceFactory, DownloadManager downloadManager) {
        this.context = context.getApplicationContext();
        this.dataSourceFactory = dataSourceFactory;
        listeners = new CopyOnWriteArraySet<>();
        downloads = new HashMap<>();
        downloadIndex = downloadManager.getDownloadIndex();
        downloadManager.addListener(new DownloadManagerListener());
        loadDownloads();
    }

    public void addListener(Listener listener) {
        listeners.add(checkNotNull(listener));
    }

    public void removeListener(Listener listener) {
        listeners.remove(listener);
    }

    public boolean isDownloaded(MediaItem mediaItem) {
        @Nullable Download download = downloads.get(checkNotNull(mediaItem.localConfiguration).uri);
        return download != null && download.state != Download.STATE_FAILED;
    }

    @Nullable
    public DownloadRequest getDownloadRequest(Uri uri) {
        @Nullable Download download = downloads.get(uri);
        return download != null && download.state != Download.STATE_FAILED ? download.request : null;
    }

    public void toggleDownload(MediaItem mediaItem) {
        @Nullable Download download = downloads.get(checkNotNull(mediaItem.localConfiguration).uri);
        if (download != null && download.state != Download.STATE_FAILED) {
            DownloadService.sendRemoveDownload(
                    context, MyDownloadService.class, download.request.id, /* foreground= */ false);
        } else {
            if (startDownloadDialogHelper != null) {
                startDownloadDialogHelper.release();
            }
            startDownloadDialogHelper =
                    new StartDownloadDialogHelper(
                            DownloadHelper.forMediaItem(context, mediaItem, null, dataSourceFactory),
                            mediaItem);
        }
    }

    private void loadDownloads() {
        try (DownloadCursor loadedDownloads = downloadIndex.getDownloads()) {
            while (loadedDownloads.moveToNext()) {
                Download download = loadedDownloads.getDownload();
                downloads.put(download.request.uri, download);
            }
        } catch (IOException e) {
            Log.w(TAG, "Failed to query downloads", e);
        }
    }

    private class DownloadManagerListener implements DownloadManager.Listener {

        @Override
        public void onDownloadChanged(
                DownloadManager downloadManager, Download download, @Nullable Exception finalException) {
            downloads.put(download.request.uri, download);
            for (Listener listener : listeners) {
                listener.onDownloadsChanged();
            }
        }

        @Override
        public void onDownloadRemoved(DownloadManager downloadManager, Download download) {
            downloads.remove(download.request.uri);
            for (Listener listener : listeners) {
                listener.onDownloadsChanged();
            }
        }
    }

    private final class StartDownloadDialogHelper
            implements DownloadHelper.Callback,
            DialogInterface.OnDismissListener {

        private final DownloadHelper downloadHelper;
        private final MediaItem mediaItem;

        private WidevineOfflineLicenseFetchTask widevineOfflineLicenseFetchTask;
        @Nullable
        private byte[] keySetId;

        public StartDownloadDialogHelper(DownloadHelper downloadHelper, MediaItem mediaItem) {
            this.downloadHelper = downloadHelper;
            this.mediaItem = mediaItem;
            downloadHelper.prepare(this);
        }

        public void release() {
            downloadHelper.release();
            if (widevineOfflineLicenseFetchTask != null) {
                widevineOfflineLicenseFetchTask.cancel(false);
            }
        }

        // DownloadHelper.Callback implementation.

        @Override
        public void onPrepared(DownloadHelper helper) {
            @Nullable Format format = getFirstFormatWithDrmInitData(helper);
            if (format == null) {
                onDownloadPrepared(helper);
                return;
            }

            // The content is DRM protected. We need to acquire an offline license.
            if (Util.SDK_INT < 18) {
                Toast.makeText(context, R.string.error_drm_unsupported_before_api_18, Toast.LENGTH_LONG)
                        .show();
                Log.e(TAG, "Downloading DRM protected content is not supported on API versions below 18");
                return;
            }
            // TODO(internal b/163107948): Support cases where DrmInitData are not in the manifest.
            if (!hasSchemaData(format.drmInitData)) {
                Toast.makeText(context, R.string.download_start_error_offline_license, Toast.LENGTH_LONG)
                        .show();
                Log.e(
                        TAG,
                        "Downloading content where DRM scheme data is not located in the manifest is not"
                                + " supported");
                return;
            }
            widevineOfflineLicenseFetchTask =
                    new WidevineOfflineLicenseFetchTask(
                            format,
                            mediaItem.localConfiguration.drmConfiguration,
                            dataSourceFactory,
                            /* dialogHelper= */ this,
                            helper);
            widevineOfflineLicenseFetchTask.execute();
        }

        @Override
        public void onPrepareError(DownloadHelper helper, IOException e) {
            boolean isLiveContent = e instanceof DownloadHelper.LiveContentUnsupportedException;
            int toastStringId =
                    isLiveContent ? R.string.download_live_unsupported : R.string.download_start_error;
            String logMessage =
                    isLiveContent ? "Downloading live content unsupported" : "Failed to start download";
            Toast.makeText(context, toastStringId, Toast.LENGTH_LONG).show();
            Log.e(TAG, logMessage, e);
        }

        // TrackSelectionListener implementation.

        public void onTracksSelected(TrackSelectionParameters trackSelectionParameters) {
            for (int periodIndex = 0; periodIndex < downloadHelper.getPeriodCount(); periodIndex++) {
                downloadHelper.clearTrackSelections(periodIndex);
                downloadHelper.addTrackSelection(periodIndex, trackSelectionParameters);
            }
            DownloadRequest downloadRequest = buildDownloadRequest();
            if (downloadRequest.streamKeys.isEmpty()) {
                // All tracks were deselected in the dialog. Don't start the download.
                return;
            }
            startDownload(downloadRequest);
        }

        // DialogInterface.OnDismissListener implementation.

        @Override
        public void onDismiss(DialogInterface dialogInterface) {
            downloadHelper.release();
        }

        // Internal methods.

        /**
         * Returns the first {@link Format} with a non-null {@link Format#drmInitData} found in the
         * content's tracks, or null if none is found.
         */
        @Nullable
        private Format getFirstFormatWithDrmInitData(DownloadHelper helper) {
            for (int periodIndex = 0; periodIndex < helper.getPeriodCount(); periodIndex++) {
                MappingTrackSelector.MappedTrackInfo mappedTrackInfo = helper.getMappedTrackInfo(periodIndex);
                for (int rendererIndex = 0;
                     rendererIndex < mappedTrackInfo.getRendererCount();
                     rendererIndex++) {
                    TrackGroupArray trackGroups = mappedTrackInfo.getTrackGroups(rendererIndex);
                    for (int trackGroupIndex = 0; trackGroupIndex < trackGroups.length; trackGroupIndex++) {
                        TrackGroup trackGroup = trackGroups.get(trackGroupIndex);
                        for (int formatIndex = 0; formatIndex < trackGroup.length; formatIndex++) {
                            Format format = trackGroup.getFormat(formatIndex);
                            if (format.drmInitData != null) {
                                return format;
                            }
                        }
                    }
                }
            }
            return null;
        }

        private void onOfflineLicenseFetched(DownloadHelper helper, byte[] keySetId) {
            this.keySetId = keySetId;
            onDownloadPrepared(helper);
        }

        private void onOfflineLicenseFetchedError(DrmSession.DrmSessionException e) {
            Toast.makeText(context, R.string.download_start_error_offline_license, Toast.LENGTH_LONG)
                    .show();
            Log.e(TAG, "Failed to fetch offline DRM license", e);
        }

        private void onDownloadPrepared(DownloadHelper helper) {
            if (helper.getPeriodCount() == 0) {
                Log.d(TAG, "No periods found. Downloading entire stream.");
                startDownload();
                downloadHelper.release();
                return;
            }

            DefaultTrackSelector.Parameters parameters = DownloadHelper.getDefaultTrackSelectorParameters(context);
            TrackSelectionParameters.Builder builder = parameters.buildUpon();
            for (int i = 0; i < SUPPORTED_TRACK_TYPES.size(); i++) {
                int trackType = SUPPORTED_TRACK_TYPES.get(i);
                builder.setTrackTypeDisabled(trackType, parameters.disabledTrackTypes.contains(trackType));
                builder.clearOverridesOfType(trackType);
                Map<TrackGroup, TrackSelectionOverride> overrides = parameters.overrides;
                for (TrackSelectionOverride override : overrides.values()) {
                    builder.addOverride(override);
                }
            }
            onTracksSelected(builder.build());
        }

        /**
         * Returns whether any the {@link DrmInitData.SchemeData} contained in {@code drmInitData} has
         * non-null {@link DrmInitData.SchemeData#data}.
         */
        private boolean hasSchemaData(DrmInitData drmInitData) {
            for (int i = 0; i < drmInitData.schemeDataCount; i++) {
                if (drmInitData.get(i).hasData()) {
                    return true;
                }
            }
            return false;
        }

        private void startDownload() {
            startDownload(buildDownloadRequest());
        }

        private void startDownload(DownloadRequest downloadRequest) {
            DownloadService.sendAddDownload(
                    context, MyDownloadService.class, downloadRequest, /* foreground= */ false);
        }

        private DownloadRequest buildDownloadRequest() {
            assert mediaItem.mediaMetadata.title != null;
            return downloadHelper
                    .getDownloadRequest(
                            Util.getUtf8Bytes(checkNotNull(mediaItem.mediaMetadata.title.toString())))
                    .copyWithKeySetId(keySetId);
        }
    }

    /**
     * Downloads a Widevine offline license in a background thread.
     */
    private static final class WidevineOfflineLicenseFetchTask extends AsyncTask<Void, Void, Void> {

        private final Format format;
        private final MediaItem.DrmConfiguration drmConfiguration;
        private final DataSource.Factory dataSourceFactory;
        private final StartDownloadDialogHelper dialogHelper;
        private final DownloadHelper downloadHelper;

        @Nullable
        private byte[] keySetId;
        @Nullable
        private DrmSession.DrmSessionException drmSessionException;

        public WidevineOfflineLicenseFetchTask(
                Format format,
                MediaItem.DrmConfiguration drmConfiguration,
                DataSource.Factory dataSourceFactory,
                StartDownloadDialogHelper dialogHelper,
                DownloadHelper downloadHelper) {
            this.format = format;
            this.drmConfiguration = drmConfiguration;
            this.dataSourceFactory = dataSourceFactory;
            this.dialogHelper = dialogHelper;
            this.downloadHelper = downloadHelper;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            assert drmConfiguration.licenseUri != null;
            OfflineLicenseHelper offlineLicenseHelper =
                    OfflineLicenseHelper.newWidevineInstance(
                            drmConfiguration.licenseUri.toString(),
                            drmConfiguration.forceDefaultLicenseUri,
                            dataSourceFactory,
                            drmConfiguration.licenseRequestHeaders,
                            new DrmSessionEventListener.EventDispatcher());
            try {
                keySetId = offlineLicenseHelper.downloadLicense(format);
            } catch (DrmSession.DrmSessionException e) {
                drmSessionException = e;
            } finally {
                offlineLicenseHelper.release();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            if (drmSessionException != null) {
                dialogHelper.onOfflineLicenseFetchedError(drmSessionException);
            } else {
                dialogHelper.onOfflineLicenseFetched(downloadHelper, checkNotNull(keySetId));
            }
        }
    }
}
