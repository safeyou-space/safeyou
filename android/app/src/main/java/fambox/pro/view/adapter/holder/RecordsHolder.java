package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class RecordsHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.recTitle)
    TextView recTitle;
    @BindView(R.id.recTime)
    TextView recTime;
    @BindView(R.id.recData)
    TextView recData;
    @BindView(R.id.recDuration)
    TextView recDuration;
    @BindView(R.id.recShare)
    ImageView recShare;

    public RecordsHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public TextView getRecTitle() {
        return recTitle;
    }

    public TextView getRecTime() {
        return recTime;
    }

    public TextView getRecData() {
        return recData;
    }

    public TextView getRecDuration() {
        return recDuration;
    }

    public ImageView getRecShare() {
        return recShare;
    }
}
