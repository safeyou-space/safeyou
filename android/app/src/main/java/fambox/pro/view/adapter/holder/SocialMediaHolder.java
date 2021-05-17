package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;

public class SocialMediaHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.socialMediaIcon)
    ImageView socialMediaIcon;
    @BindView(R.id.socialMediaName)
    TextView socialMediaName;
    @BindView(R.id.socialMediaTitle)
    TextView socialMediaTitle;
    @BindView(R.id.viewDivider)
    View viewDivider;

    public SocialMediaHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this,itemView);
    }

    public ImageView getSocialMediaIcon() {
        return socialMediaIcon;
    }

    public void setSocialMediaIcon(ImageView socialMediaIcon) {
        this.socialMediaIcon = socialMediaIcon;
    }

    public TextView getSocialMediaName() {
        return socialMediaName;
    }

    public void setSocialMediaName(TextView socialMediaName) {
        this.socialMediaName = socialMediaName;
    }

    public TextView getSocialMediaTitle() {
        return socialMediaTitle;
    }

    public void setSocialMediaTitle(TextView socialMediaTitle) {
        this.socialMediaTitle = socialMediaTitle;
    }

    public View getViewDivider() {
        return viewDivider;
    }

    public void setViewDivider(View viewDivider) {
        this.viewDivider = viewDivider;
    }
}
