package uz.udevs.udevs_video_player.retrofit

object Common {
    private const val BASE_URL = "https://api.spec.uzd.udevs.io/v1/"

    fun retrofitService(): RetrofitService {
        return RetrofitClient.getRetrofit(BASE_URL).create(RetrofitService::class.java)
    }
}