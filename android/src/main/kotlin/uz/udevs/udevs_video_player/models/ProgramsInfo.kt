package uz.udevs.udevs_video_player.models

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class ProgramsInfo(
    @SerializedName("title")
    val title: String,
    @SerializedName("movies")
    val movies: List<TvProgram>,
) : Serializable