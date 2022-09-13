package uz.udevs.udevs_video_player.adapters

import android.annotation.SuppressLint
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.Season


class EpisodePagerAdapter(
    var context: Context,
    var seasons: List<Season>,
    var onClickListener: OnClickListener
) :
    RecyclerView.Adapter<EpisodePagerAdapter.Vh>() {
    inner class Vh(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val rv: RecyclerView

        init {
            rv = itemView.findViewById(R.id.episodes_rv)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.episode_page, parent, false)
        return Vh(view)
    }

    override fun onBindViewHolder(holder: Vh, @SuppressLint("RecyclerView") position: Int) {
        val layoutManager =
            LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
        holder.rv.layoutManager = layoutManager
        holder.rv.adapter = EpisodesRvAdapter(
            context,
            seasons[position].movies,
            object : EpisodesRvAdapter.OnClickListener {
                override fun onClick(episodeIndex: Int) {
                    onClickListener.onClick(episodeIndex, position)
                }
            })
    }

    override fun getItemCount(): Int {
        return seasons.size
    }

    interface OnClickListener {
        fun onClick(episodeIndex: Int, seasonIndex: Int)
    }
}