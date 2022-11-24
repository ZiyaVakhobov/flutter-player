package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class DownloadConfiguration(
    @SerializedName("url")
    val url: String,
    @SerializedName("percent")
    var percent: Int,
) : Serializable