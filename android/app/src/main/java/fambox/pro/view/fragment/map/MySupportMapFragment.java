package fambox.pro.view.fragment.map;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.google.android.gms.maps.SupportMapFragment;

public class MySupportMapFragment extends SupportMapFragment {

    private OnTouchListener mListener;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {

        View layout = super.onCreateView(inflater, parent, savedInstanceState);

        TouchableWrapper frameLayout = new TouchableWrapper(getActivity());
        frameLayout.setBackgroundColor(getResources().getColor(android.R.color.transparent));
        if (layout != null) {
            ((ViewGroup) layout).addView(frameLayout,
                    new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        }

        return layout;
    }

    public void setListener(OnTouchListener listener) {
        mListener = listener;
    }

    public interface OnTouchListener {
        void onTouch();
    }

    public class TouchableWrapper extends FrameLayout {

        public TouchableWrapper(Context context) {
            super(context);
        }

        @Override
        public boolean dispatchTouchEvent(MotionEvent event) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                case MotionEvent.ACTION_UP:
                    mListener.onTouch();
                    break;
            }
            return super.dispatchTouchEvent(event);
        }
    }
}