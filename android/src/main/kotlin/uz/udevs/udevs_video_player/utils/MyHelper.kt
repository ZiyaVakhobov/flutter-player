package uz.udevs.udevs_video_player.utils

import org.json.JSONArray
import org.json.JSONObject
import uz.udevs.udevs_video_player.models.Movie
import uz.udevs.udevs_video_player.models.TvProgram

class MyHelper {
    // ["movie_title[cryptKey]movie_description[cryptKey]movie_image[cryptKey]movie_duration[cryptKey]{"Auto":"Auto_url"}"]
    fun customDecoderMovieList(l: List<String>, cryptKey: String): List<Movie> {
        val list = arrayListOf<Movie>()
        l.forEach {
            val split = it.split(cryptKey)
            val jsonObject = JSONObject(split[4])
            val map: HashMap<String, String> = jsonObject.toMap() as HashMap<String, String>
            val movie = Movie(split[0], split[1], split[2], split[3].toLong(), map)
            list.add(movie)
        }
        return list
    }

    // "schedule_time,program_title"
    fun customDecoderTvProgram(value: String, cryptKey: String): TvProgram {
        val split = value.split(cryptKey)
        return TvProgram(split[0], split[1])
    }

    private fun JSONObject.toMap(): Map<String, *> = keys().asSequence().associateWith { it ->
        when (val value = this[it]) {
            is JSONArray -> {
                val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
                JSONObject(map).toMap().values.toList()
            }
            is JSONObject -> value.toMap()
            JSONObject.NULL -> null
            else -> value
        }
    }
}