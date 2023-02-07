package fambox.pro.view.adapter;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import fambox.pro.R;
import fambox.pro.view.adapter.holder.ChooseProfessionsHolder;

public class AdapterChooseProfession extends RecyclerView.Adapter<ChooseProfessionsHolder> {

    private final Context mContext;
    private final List<Integer> mIdes;
    private final List<String> mNames;
    private RadioButton lastCheckedRB = null;
    private TextView lastCheckedTV = null;
    private EditText lastCheckedEditText = null;
    private boolean isFirst;
    private int mCategoryId = -2;
    private String mOtherProfessionName;
    private boolean isKeyboardOpened;
    private final TextWatcher mTextWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            mOtherProfessionName = s.toString();
        }

        @Override
        public void afterTextChanged(Editable s) {

        }
    };

    public AdapterChooseProfession(Context context, List<Integer> ides, List<String> names) {
        this.mContext = context;
        ides.add(-2);
        names.add(context.getResources().getString(R.string.other_title));
        this.mIdes = ides;
        this.mNames = names;
    }

    @Override
    public int getItemViewType(int position) {
        return mIdes.get(position);
    }


    @NonNull
    @Override
    public ChooseProfessionsHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView;
        if (viewType == -2) {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_professions_other, parent, false);
        } else {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_professions, parent, false);
        }
        return new ChooseProfessionsHolder(itemView);
    }


    @Override
    public void onBindViewHolder(@NonNull ChooseProfessionsHolder holder, int position) {

        holder.getProfessionName().setText(mNames.get(position));
        if (position == 0) {
            holder.getRadioButton().setChecked(true);
            mCategoryId = mIdes.get(position);
            mOtherProfessionName = mNames.get(position);
            holder.getProfessionName().setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
            isFirst = true;
        }
        holder.getRadioButton().setContentDescription(mNames.get(position));
        if (holder.getRadioButton().isChecked()) {
            lastCheckedRB = holder.getRadioButton();
            lastCheckedTV = holder.getProfessionName();
        }

        holder.getRadioButton().setOnClickListener(v -> {
            RadioButton radioButton = (RadioButton) v;
            TextView textView = holder.getProfessionName();
            if (radioButton.isChecked()) {
                if (lastCheckedRB != null) {
                    lastCheckedRB.setChecked(false);
                    lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.black));
                    holder.getProfessionName().setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
                    if (position == mIdes.size() - 1) {
                        holder.getAddProfessionName().setClickable(true);
                        holder.getAddProfessionName().setEnabled(true);
                        holder.getAddProfessionName().setFocusableInTouchMode(true);
                        holder.getAddProfessionName().requestFocus();
                        InputMethodManager imm = (InputMethodManager) mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
                        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
                        isKeyboardOpened = true;
                        lastCheckedEditText = holder.getAddProfessionName();
                        lastCheckedEditText.addTextChangedListener(mTextWatcher);
                    } else if (isKeyboardOpened) {
                        lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.gray));
                        InputMethodManager imm = (InputMethodManager) mContext.getSystemService(
                                Context.INPUT_METHOD_SERVICE);
                        imm.hideSoftInputFromWindow(holder.getAddProfessionName().getWindowToken(), 0);
                        isKeyboardOpened = false;
                        if (lastCheckedEditText != null) {
                            lastCheckedEditText.setClickable(false);
                            lastCheckedEditText.setEnabled(false);
                            lastCheckedEditText.removeTextChangedListener(mTextWatcher);
                        }
                    }

                    holder.getRadioButton().setSelected(false);
                    holder.getRadioButton().setClickable(false);
                    lastCheckedRB.setClickable(true);
                    isFirst = false;
                }
                lastCheckedRB = radioButton;
                lastCheckedTV = textView;
            } else {
                lastCheckedRB = null;
                lastCheckedTV = null;
            }
            mCategoryId = mIdes.get(position);
            mOtherProfessionName = mNames.get(position);
        });
        if (position == 0 && isFirst) {
            holder.getRadioButton().setSelected(false);
            holder.getRadioButton().setClickable(false);
        }
    }

    public int getCategoryId() {
        return mCategoryId;
    }

    public String getOtherProfessionName() {
        return mOtherProfessionName;
    }

    @Override
    public int getItemCount() {
        return mIdes != null ? mIdes.size() : 0;
    }
}
