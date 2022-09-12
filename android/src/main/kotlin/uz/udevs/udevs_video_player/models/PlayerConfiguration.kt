package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class PlayerConfiguration(
    val initialResolution: HashMap<String, String>,
    //like {"Auto" : "auto_url", "240p" : "240p_url"}
    val resolutions: HashMap<String, String>,
    val qualityText: String,
    val speedText: String,
    val lastPosition: Long,
    val title: String,
    val isSerial: Boolean,
    val episodeButtonText: String,
    val nextButtonText: String,
    // like {"season_title" : ["movie_title,movie_description,movie_image,movie_duration","movie_title1,movie_description1,movie_image1,movie_duration1"]"}
    val seasons: List<Season>,
    val isLive: Boolean,
    val tvProgramsText: String,
    // like ["schedule_time,program_title",""]
    val tvPrograms: List<TvProgram>,
) : Serializable