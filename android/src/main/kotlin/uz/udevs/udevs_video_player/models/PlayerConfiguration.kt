package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class PlayerConfiguration(
    val url: String,
    val lastPosition: Long,
    val title: String,
) : Serializable