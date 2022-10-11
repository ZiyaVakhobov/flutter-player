//package uz.udevs.udevs_video_player.view_models
//
//import androidx.lifecycle.LiveData
//import androidx.lifecycle.ViewModel
//import uz.udevs.udevs_video_player.models.MegogoStreamResponse
//import uz.udevs.udevs_video_player.models.PremierStreamResponse
//import uz.udevs.udevs_video_player.repositories.MyRepository
//
//class MyViewModel : ViewModel() {
//
//    private val myRepository = MyRepository()
//
//    fun getMegogoStream(
//        sessionId: String,
//        videoId: String,
//        accessToken: String,
//    ): LiveData<MegogoStreamResponse> {
//        return myRepository.getMegogoStream(sessionId, videoId, accessToken)
//    }
//
//    fun getPremierStream(
//        sessionId: String,
//        videoId: String,
//        episodeId: String,
//    ): LiveData<PremierStreamResponse> {
//        return myRepository.getPremierStream(sessionId, videoId, episodeId)
//    }
//}