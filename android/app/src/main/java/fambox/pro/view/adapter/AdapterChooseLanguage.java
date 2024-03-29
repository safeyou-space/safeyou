package fambox.pro.view.adapter;

import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.content.Context;
import android.content.res.Configuration;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.view.adapter.holder.ChooseLanguageHolder;

public class AdapterChooseLanguage extends RecyclerView.Adapter<ChooseLanguageHolder> {

    private final Context mContext;
    private final List<CountriesLanguagesResponseBody> mCountriesLanguagesResponseBodyList;
    private final boolean isChangeLanguage;
    private final String locale;

    private RadioButton lastCheckedRB = null;
    private TextView lastCheckedTV = null;
    private boolean isFirst;
    private String languageCode;

    public AdapterChooseLanguage(Context context, List<CountriesLanguagesResponseBody>
            mCountriesLanguagesResponseBodyList, String locale, boolean isChangeLanguage) {
        this.mContext = context;
        this.mCountriesLanguagesResponseBodyList = mCountriesLanguagesResponseBodyList;
        this.locale = locale;
        this.isChangeLanguage = isChangeLanguage;
    }

    @NonNull
    @Override
    public ChooseLanguageHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView;
        if (isChangeLanguage) {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_language_settings, parent, false);
        } else {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_language, parent, false);
        }

        return new ChooseLanguageHolder(itemView);
    }


    @Override
    public void onBindViewHolder(@NonNull ChooseLanguageHolder holder, int position) {
        holder.getLanguageName().setText(mCountriesLanguagesResponseBodyList.get(position).getTitle());
        holder.getRadioButton().setContentDescription(mCountriesLanguagesResponseBodyList.get(position).getTitle());
        if (position == 0 && !isChangeLanguage) {
            holder.getRadioButton().setChecked(true);
            languageCode = mCountriesLanguagesResponseBodyList.get(position).getCode();
            isFirst = true;
        } else if (isChangeLanguage) {
            if (Objects.equals(mCountriesLanguagesResponseBodyList.get(position).getCode(), locale)) {
                lastCheckedTV = holder.getLanguageName();
                lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
                holder.getRadioButton().setChecked(true);
                holder.getRadioButton().setClickable(false);
                languageCode = mCountriesLanguagesResponseBodyList.get(position).getCode();
            }
        }
        if (holder.getRadioButton().isChecked()) {
            lastCheckedRB = holder.getRadioButton();
            lastCheckedTV = holder.getLanguageName();
        }
        holder.getRadioButton().setOnClickListener(v -> {
            RadioButton radioButton = (RadioButton) v;
            TextView textView = holder.getLanguageName();
            if (radioButton.isChecked()) {
                if (lastCheckedRB != null) {
                    lastCheckedRB.setChecked(false);
                    if (isChangeLanguage) {
                        lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.black));
                        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
                        int nightModeFlags =
                                mContext.getResources().getConfiguration().uiMode &
                                        Configuration.UI_MODE_NIGHT_MASK;
                        if (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES) {
                            lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.white));

                        }
                        holder.getLanguageName().setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
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
            languageCode = mCountriesLanguagesResponseBodyList.get(position).getCode();
        });
        if (position == 0 && isFirst) {
            holder.getRadioButton().setSelected(false);
            holder.getRadioButton().setClickable(false);
        }
    }

    public String getLanguageCode() {
        return languageCode;
    }

    @Override
    public int getItemCount() {
        return mCountriesLanguagesResponseBodyList != null ? mCountriesLanguagesResponseBodyList.size() : 0;
    }


}
