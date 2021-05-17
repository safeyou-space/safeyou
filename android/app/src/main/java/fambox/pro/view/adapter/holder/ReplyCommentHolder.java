package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.thoughtbot.expandablerecyclerview.viewholders.ChildViewHolder;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class ReplyCommentHolder extends ChildViewHolder {

    @BindView(R.id.imgCommentUser)
    ImageView imgCommentUser;
    @BindView(R.id.txtCommentUserName)
    TextView txtCommentUserName;
    @BindView(R.id.txtCommentUserPosition)
    TextView txtCommentUserPosition;
    @BindView(R.id.txtCommentUserComment)
    TextView txtCommentUserComment;
    @BindView(R.id.txtCommentDate)
    TextView txtCommentDate;
    @BindView(R.id.txtReply)
    TextView txtReply;
    @BindView(R.id.txtViewMore)
    TextView txtViewMore;

    public ReplyCommentHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public ImageView getImgCommentUser() {
        return imgCommentUser;
    }

    public TextView getTxtCommentUserName() {
        return txtCommentUserName;
    }

    public TextView getTxtCommentUserPosition() {
        return txtCommentUserPosition;
    }

    public TextView getTxtCommentUserComment() {
        return txtCommentUserComment;
    }

    public TextView getTxtCommentDate() {
        return txtCommentDate;
    }

    public TextView getTxtReply() {
        return txtReply;
    }

    public TextView getTxtViewMore() {
        return txtViewMore;
    }
}
