package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class PlayerConfiguration(
    val url: String,
    val lastPosition: Long,
    val title: String,
    val isSerial: Boolean,
    val episodeButtonText: String,
    val nextButtonText: String,
    val isLive: Boolean,
    val tvProgramsText: String,
) : Serializable