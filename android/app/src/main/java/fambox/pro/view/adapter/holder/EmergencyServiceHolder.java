package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class EmergencyServiceHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgEditService)
    ImageView imgEditService;
    @BindView(R.id.txtServiceTitle)
    TextView txtServiceTitle;
    @BindView(R.id.txtServiceName)
    TextView txtServiceName;
    @BindView(R.id.txtServiceClear)
    TextView txtServiceClear;

    public EmergencyServiceHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

}
