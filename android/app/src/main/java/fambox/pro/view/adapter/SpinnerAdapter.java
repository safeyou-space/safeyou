package fambox.pro.view.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.Arrays;
import java.util.List;

import fambox.pro.R;

public class SpinnerAdapter extends BaseAdapter {
    public static final int REGISTRATION = 0;
    public static final int OTHER = 1;
    private Context context;
    private List<Integer> list = Arrays.asList(R.string.select_marital, R.string.married, R.string.unmarried);
    private List<Integer> list1 = Arrays.asList(R.string.dont_selected, R.string.married, R.string.unmarried);
    private int type;

    public SpinnerAdapter(Context applicationContext, int type) {
        this.context = applicationContext;
        this.type = type;
    }

    @Override
    public int getCount() {
        switch (type) {
            case REGISTRATION:
                return list == null ? 0 : list.size();
            case OTHER:
                return list1 == null ? 0 : list1.size();

        }
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int i) {
        return list.get(i);
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @SuppressLint({"ViewHolder", "InflateParams"})
    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        view = LayoutInflater.from(context).inflate(R.layout.select_marital_spinner_item, null);
        TextView names = view.findViewById(R.id.spinnerId);
        String name = "";
        int color = Color.BLACK;
        switch (type) {
            case REGISTRATION:
                name = context.getResources().getString(list.get(i));
                color = context.getResources().getColor(R.color.hint_gray);
                break;
            case OTHER:
                name = context.getResources().getString(list1.get(i));
                color = context.getResources().getColor(R.color.black);
                break;
        }
        names.setTextColor(color);
        names.setText(name);
        return view;
    }
}