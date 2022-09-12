package uz.udevs.udevs_video_player.utils

import uz.udevs.udevs_video_player.models.Movie
import uz.udevs.udevs_video_player.models.TvProgram

class MyHelper {
    // ["movie_title,movie_description,movie_image,movie_duration"]
    fun customDecoderMovieList(l: List<String>, cryptKey: String): List<Movie> {
        val list = arrayListOf<Movie>()
        l.forEach {
            val split = it.split(cryptKey)
            val movie = Movie(split[0], split[1], split[2], split[3].toLong())
            list.add(movie)
        }
        return list
    }

    // "schedule_time,program_title"
    fun customDecoderTvProgram(value: String, cryptKey: String): TvProgram {
        val split = value.split(cryptKey)
        return TvProgram(split[0], split[1])
    }
}