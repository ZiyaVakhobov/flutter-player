package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class Movie(
    val title: String,
    val description: String,
    val image: String,
    val duration: Long,
    val resolutions: HashMap<String, String>
) : Serializable