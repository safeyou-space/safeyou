package fambox.pro.privatechat.view.chatadapter;

import android.view.View;
import android.widget.TextView;

import com.fambox.chatkit.messages.MessageHolders;

import fambox.pro.R;
import fambox.pro.privatechat.viewmodel.ChatViewModel;
import fambox.pro.utils.Utils;

public class OutgoingReplyMessageViewHolder
        extends MessageHolders.OutcomingTextMessageViewHolder<ChatViewModel.Message> {
    private final TextView replyUserName;
    private final TextView replyText;
    private final TextView time;

    public OutgoingReplyMessageViewHolder(View itemView, Object payload) {
        super(itemView, payload);
        replyUserName = itemView.findViewById(R.id.replyUserName);
        replyText = itemView.findViewById(R.id.replyText);
        time = itemView.findViewById(R.id.time);
    }

    @Override
    public void onBind(ChatViewModel.Message message) {
        super.onBind(message);
        replyUserName.setText(message.getReplyMessage().getUserName());
        replyText.setText(message.getReplyMessage().getReplyMessage());
        time.setText(Utils.chatReplyTime(message.getReplyMessage().getTime()));
    }

    @Override
    protected void configureLinksBehavior(TextView text) {
        super.configureLinksBehavior(text);
    }
}