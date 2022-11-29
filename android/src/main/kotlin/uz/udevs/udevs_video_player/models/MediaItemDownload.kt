package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class MediaItemDownload(
    @SerializedName("url")
    val url: String,
    @SerializedName("percent")
    val percent: Int,
    @SerializedName("state")
    val state: Int,
    @SerializedName("contentBytes")
    val contentBytes: Long,
    @SerializedName("downloadedBytes")
    val downloadedBytes: Long,
) : Serializable