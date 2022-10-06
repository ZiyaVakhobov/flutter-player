package uz.udevs.udevs_video_player.models

data class PremierStreamResponse(
    val file_info: List<FileInfo?>?
) {
    data class FileInfo(
        val duration: Int?,
        val file_name: String?,
        val height: Int?,
        val quality: String?,
        val width: Int?
    )
}