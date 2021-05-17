package fambox.pro.utils;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.ColorLong;
import androidx.core.content.ContextCompat;

import com.google.android.material.snackbar.Snackbar;

import fambox.pro.R;

public class SnackBar {

    public enum SBType {
        SUCCESS(R.color.black), ERROR(R.color.colorAccent);

        private int color;

        SBType(@ColorLong int value) {
            color = value;
        }

        public int getColor() {
            return color;
        }
    }

    public static Snackbar make(Context context, View rootView, SBType type, String massage) {
        final Snackbar snackBar = Snackbar.make(rootView, massage, Snackbar.LENGTH_LONG);
        snackBar.setAction(context.getResources().getString(R.string.close), v -> snackBar.dismiss());
        View sbView = snackBar.getView();
        sbView.setBackgroundColor(Color.parseColor("#F8F5F9"));
        snackBar.setActionTextColor(Color.parseColor("#9834B7"));
        TextView textView = sbView.findViewById(com.google.android.material.R.id.snackbar_text);
        textView.setTextColor(ContextCompat.getColor(context, type.getColor()));
        return snackBar;
    }
}
