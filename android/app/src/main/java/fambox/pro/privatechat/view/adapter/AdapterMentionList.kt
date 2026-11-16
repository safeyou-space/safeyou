package fambox.pro.privatechat.view.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.fambox.mention.suggestions.interfaces.Suggestible
import fambox.pro.databinding.AdapterMentionListBinding
import fambox.pro.privatechat.network.model.User

class AdapterMentionList : RecyclerView.Adapter<AdapterMentionList.MentionListHolder>() {

    private var mMentions = mutableListOf<Suggestible?>()
    private lateinit var mContext: Context
    var mMentionClickListener: MentionClickListener? = null

    fun setMention(rooms: List<Suggestible?>) {
        this.mMentions = rooms.toMutableList()
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MentionListHolder {
        mContext = parent.context
        val inflater = LayoutInflater.from(mContext)
        val binding = AdapterMentionListBinding.inflate(inflater, parent, false)
        return MentionListHolder(binding)
    }

    override fun onBindViewHolder(holder: MentionListHolder, position: Int) {
        val suggestion: Suggestible = mMentions[position] as? User ?: return
        val user: User = suggestion as User
        val userName = user.user_username
        holder.binding.userName.text = userName
        //TODO add base url
        val imagePath = user.user_image
        Glide.with(mContext)
            .load(imagePath)
            .circleCrop()
            .into(holder.binding.userImage)
        holder.binding.root.setOnClickListener {
            if (mMentionClickListener != null) {
                mMentionClickListener!!.onClickMention(user)
            }
        }
    }

    override fun getItemCount(): Int {
        return mMentions.size
    }

    class MentionListHolder(val binding: AdapterMentionListBinding) :
        RecyclerView.ViewHolder(binding.root)

    interface MentionClickListener {
        fun onClickMention(user: User)
    }
}