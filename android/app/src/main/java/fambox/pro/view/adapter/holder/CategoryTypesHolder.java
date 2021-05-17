package fambox.pro.view.adapter.holder;

import android.view.View;
import android.widget.Button;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import lombok.Getter;

@Getter
public class CategoryTypesHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tglCategoryType)
    ToggleButton tglCategoryType;

    public CategoryTypesHolder(@NonNull View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }
}
