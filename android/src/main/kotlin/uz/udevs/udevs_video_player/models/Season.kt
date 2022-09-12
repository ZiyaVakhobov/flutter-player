package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class Season(
    val title: String,
    val movies: List<Movie>,
) : Serializable