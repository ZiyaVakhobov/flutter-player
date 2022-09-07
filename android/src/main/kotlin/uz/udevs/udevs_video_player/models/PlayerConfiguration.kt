package uz.udevs.udevs_video_player.models

import io.flutter.plugin.common.MethodCall
import java.io.Serializable

data class PlayerConfiguration(
//    val call: MethodCall,
    val url: String,
    val lastPosition: Long,
    val duration: Long,
    val title: String,
) : Serializable