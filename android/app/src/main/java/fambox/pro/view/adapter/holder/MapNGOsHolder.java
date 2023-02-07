package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageButton;
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
    @BindView(R.id.imgInfo)
    ImageButton imgInfo;
    @BindView(R.id.txtMapNgoName)
    TextView txtMapNgoName;
    @BindView(R.id.txtMapNgoAddress)
    TextView txtMapNgoAddress;
    @BindView(R.id.txtEmail)
    TextView txtEmail;
    @BindView(R.id.txtPhoneNumber)
    TextView txtPhoneNumber;
    @BindView(R.id.ngoImage)
    CircleImageView ngoImage;
    @BindView(R.id.txtShortDecscription)
    TextView txtShortDecscription;
    @BindView(R.id.imgBtnPrivateMessage)
    ImageButton imgBtnPrivateMessage;

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

    public TextView getTxtEmail() {
        return txtEmail;
    }

    public TextView getTxtPhoneNumber() {
        return txtPhoneNumber;
    }

    public CircleImageView getNgoImage() {
        return ngoImage;
    }

    public TextView getTxtShortDecscription() {
        return txtShortDecscription;
    }

    public ImageButton getImgBtnPrivateMessage() {
        return imgBtnPrivateMessage;
    }

    public ImageButton getImgInfo() {
        return imgInfo;
    }
}
