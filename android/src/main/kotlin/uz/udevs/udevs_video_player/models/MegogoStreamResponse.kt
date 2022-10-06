package uz.udevs.udevs_video_player.models

data class MegogoStreamResponse(
    val code: Int?,
    val `data`: Data?,
    val result: String?
) {
    data class Data(
        val advert_url: String?,
        val allow_external_streaming: Boolean?,
        val audio_tracks: List<AudioTrack?>?,
        val bitrates: List<Bitrate?>?,
        val cdn_id: Int?,
        val content_type: String?,
        val credits_start: Int?,
        val drm_type: String?,
        val external_source: Boolean?,
        val hierarchy_titles: HierarchyTitles?,
        val is_3d: Boolean?,
        val is_autoplay: Boolean?,
        val is_embed: Boolean?,
        val is_favorite: Boolean?,
        val is_hdr: Boolean?,
        val is_hierarchy: Boolean?,
        val is_live: Boolean?,
        val is_tv: Boolean?,
        val is_uhd: Boolean?,
        val is_uhd_8k: Boolean?,
        val is_wvdrm: Boolean?,
        val parental_control_required: Boolean?,
        val play_start_time: Int?,
        val preview_images: PreviewImages?,
        val share_link: String?,
        val show_best_quality_link: Boolean?,
        val src: String?,
        val start_session_url: String?,
        val stream_type: String?,
        val subtitles: List<String?>?,
        val title: String?,
        val video_id: Int?,
        val watermark: String?,
        val watermark_clickable_enabled: Boolean?,
        val wvls: String?
    ) {
        data class AudioTrack(
            val display_name: String?,
            val id: Int?,
            val index: Int?,
            val is_active: Boolean?,
            val lang: String?,
            val lang_iso_639_1: String?,
            val lang_original: String?,
            val lang_tag: String?,
            val require_subtitles: Boolean?
        )

        data class Bitrate(
            val bitrate: Int?,
            val src: String?
        )

        data class HierarchyTitles(
            val VIDEO: String?
        )

        data class PreviewImages(
            val thumbsline_list: List<Thumbsline?>?,
            val thumbsline_list_full_hd: List<ThumbslineFullHd?>?,
            val thumbsline_list_uhd: List<ThumbslineUhd?>?,
            val thumbsline_xml: String?
        ) {
            data class Thumbsline(
                val id: Int?,
                val url: String?
            )

            data class ThumbslineFullHd(
                val id: Int?,
                val url: String?
            )

            data class ThumbslineUhd(
                val id: Int?,
                val url: String?
            )
        }
    }
}