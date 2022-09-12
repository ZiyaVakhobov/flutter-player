package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class TvProgram(
    val scheduledTime: String,
    val programTitle: String,
) : Serializable