package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class ForumFilterChipsHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.chipName)
    TextView chipName;
    @BindView(R.id.btnChipsClose)
    ImageButton btnChipsClose;

    public ForumFilterChipsHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);

    }
}
