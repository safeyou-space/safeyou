package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class ChooseLanguageHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.languageName)
    TextView languageName;
    @BindView(R.id.radioButton)
    RadioButton radioButton;

    public ChooseLanguageHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }
}
