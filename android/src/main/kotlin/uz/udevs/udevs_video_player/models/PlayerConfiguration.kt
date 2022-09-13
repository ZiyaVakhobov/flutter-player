package uz.udevs.udevs_video_player.models

import java.io.Serializable

data class PlayerConfiguration(
    val initialResolution: HashMap<String, String>,
    val resolutions: HashMap<String, String>,
    val qualityText: String,
    val speedText: String,
    val lastPosition: Long,
    val title: String,
    val isSerial: Boolean,
    val episodeButtonText: String,
    val nextButtonText: String,
    val seasons: List<Season>,
    val isLive: Boolean,
    val tvProgramsText: String,
    val tvPrograms: List<TvProgram>,
) : Serializable