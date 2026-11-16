package fambox.pro.privatechat.audio;

import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Handler;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Objects;

public class Player extends MediaPlayer implements SeekBar.OnSeekBarChangeListener {
    private static final int UPDATE_INTERVAL = 100;
    private static volatile Player instance;
    private static final Object monitor = new Object();
    private View mView;
    private SeekBar mSeekBar;
    private TextView mDuration;
    private String mPlaySrc;
    private PlayerListener mPlayerListener;
    private final Handler mHandler = new Handler();
    private final Runnable mTracker = new Runnable() {
        @Override
        public void run() {
            int mCurrentPosition = getCurrentPosition() / UPDATE_INTERVAL;
            if (mPlayerListener != null) {
                mDuration.setText(new SimpleDateFormat("mm:ss", Locale.US)
                        .format(new Date(mCurrentPosition * UPDATE_INTERVAL)));
                mSeekBar.setProgress(mCurrentPosition);
            }
            mHandler.postDelayed(this, UPDATE_INTERVAL);
        }
    };

    public static Player getInstance() {
        synchronized (monitor) {
            if (instance == null) {
                instance = new Player();
            }
            return instance;
        }
    }

    public void clear() {
        stop();
        reset();
    }

    private Player() {
        setAudioStreamType(AudioManager.STREAM_MUSIC);
    }

    public void setPlayerListener(PlayerListener mPlayerListener) {
        this.mPlayerListener = mPlayerListener;
    }

    public void play(String src, View view, SeekBar seekBar, TextView duration) throws IOException {
        View mPreviousView = mView == null ? view : mView;
        SeekBar mPreviousSeekBar = mSeekBar == null ? seekBar : mSeekBar;
        TextView mPreviousDuration = mDuration == null ? duration : mDuration;
        if (mPlayerListener != null && mPreviousView != null
                && mPreviousSeekBar != null && mPreviousDuration != null) {
            mPlayerListener.onStopPrevious(mPreviousView, mPreviousSeekBar, mPreviousDuration);
            mPreviousSeekBar.setProgress(0);
            mPreviousDuration.setText(new SimpleDateFormat("mm:ss", Locale.US)
                    .format(new Date(getDuration())));
        }

        this.mView = view;
        this.mSeekBar = seekBar;
        this.mDuration = duration;

        if (mPlaySrc != null && Objects.equals(mPlaySrc, src) && isPlaying()) {
            if (mPlayerListener != null) {
                stop();
                mPlayerListener.onStop(mView);
            }
        } else {
            reset();
            setDataSource(src);
            prepare();
            completed();
            start();
            mSeekBar.setOnSeekBarChangeListener(this);
            mSeekBar.setMax(getDuration() / UPDATE_INTERVAL);
            if (mPlayerListener != null) {
                mPlayerListener.onStart(mView);
            }
            mHandler.postDelayed(mTracker, UPDATE_INTERVAL);
        }
        this.mPlaySrc = src;
    }

    private void completed() {
        setOnCompletionListener(mp -> {
            reset();
            mHandler.removeCallbacks(mTracker);
            mSeekBar.setProgress(0);
            if (mPlayerListener != null) {
                mPlayerListener.onStop(mView);
            }
        });
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        if (fromUser) {
            mHandler.removeCallbacks(mTracker);
            seekTo(progress * UPDATE_INTERVAL);
            seekBar.setProgress(progress);
        }
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
        mHandler.postDelayed(mTracker, UPDATE_INTERVAL);
    }
}
