package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class ChooseProfessionsHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.professionName)
    TextView professionName;
    @BindView(R.id.radioButton)
    RadioButton radioButton;
    @BindView(R.id.addProfessionName)
    EditText addProfessionName;

    public ChooseProfessionsHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

}
