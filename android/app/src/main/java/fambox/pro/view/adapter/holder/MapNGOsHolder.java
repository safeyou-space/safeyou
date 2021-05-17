package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.R;

public class MapNGOsHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.imgBtnCall)
    ImageButton imgBtnCall;
    @BindView(R.id.imgBtnEmail)
    ImageButton imgBtnEmail;
    @BindView(R.id.txtMapNgoName)
    TextView txtMapNgoName;
    @BindView(R.id.txtMapNgoAddress)
    TextView txtMapNgoAddress;

    public MapNGOsHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public ImageButton getImgBtnCall() {
        return imgBtnCall;
    }

    public ImageButton getImgBtnEmail() {
        return imgBtnEmail;
    }

    public TextView getTxtMapNgoName() {
        return txtMapNgoName;
    }

    public TextView getTxtMapNgoAddress() {
        return txtMapNgoAddress;
    }
}
