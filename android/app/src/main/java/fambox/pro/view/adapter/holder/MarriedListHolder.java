package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class MarriedListHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.btnMarried)
    Button btnMarried;

    public MarriedListHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public Button getBtnMarried() {
        return btnMarried;
    }
}
