package uz.udevs.udevs_video_player.activities

import android.app.Application
import android.content.Context
import android.net.Uri
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.*
import uz.udevs.udevs_video_player.services.DownloadUtil

class PlayerViewModel(application: Application) : AndroidViewModel(application) {

    private val _downloadPercent = MutableLiveData<Float>()
    val downloadPercent: LiveData<Float>
        get() = _downloadPercent

    private var coroutineScope: CoroutineScope? = null

    @OptIn(ExperimentalCoroutinesApi::class)
    fun startFlow(context: Context, uri: Uri) {
        coroutineScope?.cancel()
        val job = SupervisorJob()
        coroutineScope = CoroutineScope(Dispatchers.Main + job).apply {
            launch {
                DownloadUtil.getDownloadTracker(context).getCurrentProgressDownload(uri).collect {
                    _downloadPercent.postValue(it)
                }
            }
        }
    }

    fun stopFlow() {
        coroutineScope?.cancel()
    }

}