//
//  MegogoStreamResponse.swift
//  udevs_video_player
//
//  Created by Udevs on 07/10/22.
//

import Foundation

struct MegogoStreamResponse:Decodable{
    var result: String?
    var code: Int?
    var data: Data?
}
struct Data:Decodable{
    
    var video_id: Int?
    var title: String?
    var hierarchy_titles: HierarchyTitles?
    var src: String?
    var drm_type: String?
    var stream_type: String?
    var content_type: String?
    var audio_tracks: [AudioTrack]?
    var subtitles: [Subtitle]?
    var bitrates: [Bitrate]?
    var cdn_id: Int?
    var advert_url: String?
    var allow_external_streaming: Bool?
    var start_session_url: String?
    var parental_control_required: Bool?
    var play_start_time: Int?
    var wvls: String?
    var watermark: String?
    var watermark_clickable_enabled: Bool?
    var show_best_quality_link: Bool?
    var share_link: String?
    var credits_start: Int?
    var external_source: Bool?
    var preview_images: PreviewImages?
    var is_autoplay: Bool?
    var is_wvdrm: Bool?
    var is_embed: Bool?
    var is_hierarchy: Bool?
    var is_live: Bool?
    var is_tv: Bool?
    var is_3d: Bool?
    var is_uhd: Bool?
    var is_uhd_8k: Bool?
    var is_hdr: Bool?
    var is_favorite: Bool?
}

struct HierarchyTitles:Decodable{
    var VIDEO: String?
}

struct AudioTrack:Decodable{
    var id: Int?
    var lang: String?
    var lang_tag: String?
    var lang_original: String?
    var display_name: String?
    var index: Int?
    var require_subtitles: Bool?
    var lang_iso_639_1: String?
    var is_active: Bool?
}

struct Subtitle:Decodable{
    var display_name: String?
    var index: Int?
    var lang: String?
    var lang_iso_639_1: String?
    var lang_original: String?
    var lang_tag: String?
    var type: String?
    var url: String?
}

struct Bitrate:Decodable{
    var bitrate: Int?
    var src: String?
}

struct PreviewImages:Decodable{
    var thumbsline_xml: String?
    var thumbsline_list: [Thumbsline]?
    var thumbsline_list_full_hd: [ThumbslineFullHd]?
    var thumbsline_list_uhd: [ThumbslineUhd]?
    
}

struct Thumbsline:Decodable{
    var id: Int?
    var url: String?
}

struct ThumbslineFullHd:Decodable{
    var id: Int?
    var url: String?
}

struct ThumbslineUhd:Decodable{
    var id: Int?
    var url: String?
}

