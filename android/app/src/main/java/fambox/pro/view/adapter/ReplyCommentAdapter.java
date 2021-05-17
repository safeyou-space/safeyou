package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.chat.Comments;
import fambox.pro.view.adapter.holder.ForumCommentHolder;
import fambox.pro.view.adapter.holder.ReplyCommentHolder;

import static fambox.pro.Constants.BASE_URL;

public class ReplyCommentAdapter extends RecyclerView.Adapter<ReplyCommentHolder> {

    private Context mContext;
    private List<Comments> replyComments;

    public ReplyCommentAdapter(List<Comments> replyComments, Context mContext) {
        this.mContext = mContext;
        this.replyComments = replyComments;
    }

    @NonNull
    @Override
    public ReplyCommentHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater
                .from(parent.getContext())
                .inflate(R.layout.adapter_reply_comment, parent, false);
        return new ReplyCommentHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull ReplyCommentHolder holder, int position) {
        holder.getTxtCommentUserName().setText(replyComments.get(position).getName());
        holder.getTxtCommentUserComment().setText(replyComments.get(position).getMessage());
        holder.getTxtCommentDate().setText(replyComments.get(position).getCreated_at());
        holder.getTxtCommentUserPosition().setText(replyComments.get(position).getUser_type());
        if (replyComments.get(position).getImage_path() != null) {
            Glide.with(mContext).load(BASE_URL.concat(replyComments.get(position).getImage_path()))
                    .into(holder.getImgCommentUser());
        }
    }

    @Override
    public int getItemCount() {
        return replyComments == null ? 0 : replyComments.size();
    }
}
