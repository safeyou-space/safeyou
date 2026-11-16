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
public class EmergencyContactHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgEditContact)
    ImageView imgEditContact;
    @BindView(R.id.txtContactTitle)
    TextView txtContactTitle;
    @BindView(R.id.txtContactName)
    TextView txtContactName;
    @BindView(R.id.txtContactClear)
    TextView txtContactClear;

    public EmergencyContactHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

}
