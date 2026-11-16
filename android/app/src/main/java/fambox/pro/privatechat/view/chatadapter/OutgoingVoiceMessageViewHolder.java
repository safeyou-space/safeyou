package fambox.pro.privatechat.view.chatadapter;

import android.view.View;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TextView;

import com.fambox.chatkit.messages.MessageHolders;
import com.fambox.chatkit.utils.DateFormatter;

import java.io.IOException;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.privatechat.audio.Player;
import fambox.pro.privatechat.audio.PlayerListener;
import fambox.pro.privatechat.viewmodel.ChatViewModel;

public class OutgoingVoiceMessageViewHolder
        extends MessageHolders.OutcomingTextMessageViewHolder<ChatViewModel.Message> implements PlayerListener {

    private final TextView tvDuration;
    private final TextView tvTime;
    private final ImageButton playPauseBtn;
    private final SeekBar voiceSeekBar;
    private final Player mPlayer;

    public OutgoingVoiceMessageViewHolder(View itemView, Object payload) {
        super(itemView, payload);
        tvDuration = itemView.findViewById(R.id.duration);
        tvTime = itemView.findViewById(R.id.time);
        voiceSeekBar = itemView.findViewById(R.id.voiceSeekBar);
        playPauseBtn = itemView.findViewById(R.id.playPauseBtn);
        mPlayer = Player.getInstance();
        mPlayer.setPlayerListener(this);
    }

    @Override
    public void onBind(ChatViewModel.Message message) {
        super.onBind(message);
        tvDuration.setText(message.getVoice().getDuration());
        tvTime.setText(DateFormatter.format(message.getCreatedAt(), DateFormatter.Template.TIME));
        playPauseBtn.setOnClickListener(v -> {
            try {
                mPlayer.play(Constants.BASE_SOCKET_URL + message.getVoice().getUrl(), v,
                        voiceSeekBar, tvDuration);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }

    @Override
    protected void configureLinksBehavior(TextView text) {
        super.configureLinksBehavior(text);
    }

    @Override
    public void onStart(View view) {
        ((ImageButton) view).setImageResource(R.drawable.icon_pause_chat);
    }

    @Override
    public void onStop(View view) {
        ((ImageButton) view).setImageResource(R.drawable.icon_play_chat);
    }

    @Override
    public void onStopPrevious(View view, SeekBar seekBar, TextView textView) {
        ((ImageButton) view).setImageResource(R.drawable.icon_play_chat);
    }
}