package fambox.pro.privatechat.view.chatadapter;

import android.view.View;
import android.widget.TextView;

import com.fambox.chatkit.messages.MessageHolders;

import fambox.pro.R;
import fambox.pro.privatechat.viewmodel.ChatViewModel;

public class IncomingReplyMessageViewHolder
        extends MessageHolders.IncomingTextMessageViewHolder<ChatViewModel.Message> {
    private final TextView replyUserName;
    private final TextView replyText;


    public IncomingReplyMessageViewHolder(View itemView, Object payload) {
        super(itemView, payload);
        replyUserName = itemView.findViewById(R.id.replyUserName);
        replyText = itemView.findViewById(R.id.replyText);
    }

    @Override
    public void onBind(ChatViewModel.Message message) {
        super.onBind(message);
        replyUserName.setText(message.getReplyMessage().getUserName());
        replyText.setText(message.getReplyMessage().getReplyMessage());
    }

    @Override
    protected void configureLinksBehavior(TextView text) {
        super.configureLinksBehavior(text);
    }
}