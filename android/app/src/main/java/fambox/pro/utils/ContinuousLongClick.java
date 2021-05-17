package fambox.pro.utils;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.Nullable;


public class ContinuousLongClick implements View.OnTouchListener, View.OnLongClickListener {
    private final Handler handler;
    private ContinuousLongClickListener mLongClickListener;
    private boolean isLongPressed = false;

    public ContinuousLongClick(View view, @Nullable ContinuousLongClickListener longClickListener) {
        this.mLongClickListener = longClickListener;
        handler = new Handler();
        if (longClickListener != null) {
            view.setOnLongClickListener(this);
            view.setOnTouchListener(this);
        }
    }

    @Override
    public boolean onLongClick(final View view) {
        handler.post(() -> {
            isLongPressed = true;
            if (mLongClickListener != null) {
                mLongClickListener.onStartLongClick(view);
            }
        });
        return true;
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {
            if (isLongPressed) {
                if (mLongClickListener != null) {
                    mLongClickListener.onEndLongClick(v);
                }
                isLongPressed = false;
            }
        }
        return false;
    }

    public interface ContinuousLongClickListener {
        void onStartLongClick(View view);

        void onEndLongClick(View view);
    }
}