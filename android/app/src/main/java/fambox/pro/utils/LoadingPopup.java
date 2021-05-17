package fambox.pro.utils;

import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.PopupWindow;

import androidx.fragment.app.FragmentActivity;

import fambox.pro.R;

import static android.content.Context.LAYOUT_INFLATER_SERVICE;

public class LoadingPopup extends PopupWindow {
    public LoadingPopup(FragmentActivity context, View view) {
        super(((LayoutInflater) context.getSystemService(LAYOUT_INFLATER_SERVICE))
                        .inflate(R.layout.loading_view, null),
                ViewGroup.LayoutParams.MATCH_PARENT, 0);

        view.post(() -> {
            View rootView = context.findViewById(Window.ID_ANDROID_CONTENT);
            int statusBarHeight = 0;
            int resourceId = context.getResources()
                    .getIdentifier("status_bar_height", "dimen", "android");
            if (resourceId > 0) {
                statusBarHeight = context.getResources().getDimensionPixelSize(resourceId);
            }
            int contentHeight = rootView.getBottom();
            setHeight(contentHeight - (view.getHeight() + statusBarHeight));
            showAtLocation(view, Gravity.BOTTOM, 0, 0);
        });

    }

}
