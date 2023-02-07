package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import fambox.pro.R;


public class AdapterForumSort extends ArrayAdapter<String> {

    private final int resourceLayout;
    private final Context mContext;
    private int selection;

    public AdapterForumSort(Context context, int resource, List<String> items) {
        super(context, resource, items);
        this.resourceLayout = resource;
        this.mContext = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) mContext
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate(resourceLayout, parent, false);

        TextView tt1 = (TextView) rowView.findViewById(R.id.sortCategory);
        tt1.setText(getItem(position));
        if (position == selection) {
            rowView.setBackgroundResource(R.color.sort_by_selected_background);
        }

        return rowView;
    }

    public void setSelection(int position) {
        selection = position;
    }

}
