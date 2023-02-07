package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.R;

public class ChooseCountriesHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.countryImage)
    CircleImageView countryImage;
    @BindView(R.id.countryName)
    TextView countryName;
    @BindView(R.id.radioButton)
    RadioButton radioButton;

    public ChooseCountriesHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public CircleImageView getCountryImage() {
        return countryImage;
    }

    public TextView getCountryName() {
        return countryName;
    }

    public RadioButton getRadioButton() {
        return radioButton;
    }
}
