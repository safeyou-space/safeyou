package fambox.pro.privatechat.audio;

import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;

public interface PlayerListener {
    void onStart(View view);

    void onStop(View view);

    void onStopPrevious(View view, SeekBar seekBar, TextView textView);
}
