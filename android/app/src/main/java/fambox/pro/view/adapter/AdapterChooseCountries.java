package fambox.pro.view.adapter;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
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

import com.bumptech.glide.Glide;

import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.CountriesLanguagesResponseBody;
import fambox.pro.view.adapter.holder.ChooseCountriesHolder;

public class AdapterChooseCountries extends RecyclerView.Adapter<ChooseCountriesHolder> {

    private final Context mContext;
    private final List<CountriesLanguagesResponseBody> mCountriesResponseBodyList;
    private final boolean isSettings;
    private final String currentCountryCode;

    private RadioButton lastCheckedRB = null;
    private TextView lastCheckedTV = null;
    private boolean isFirst;
    private String countryCode;
    private String countryName;

    public AdapterChooseCountries(Context context, List<CountriesLanguagesResponseBody> mCountriesResponseBodyList,
                                  boolean isSettings) {
        this.mContext = context;
        this.mCountriesResponseBodyList = mCountriesResponseBodyList;
        this.isSettings = isSettings;
        currentCountryCode = SafeYouApp.getPreference(context).getStringValue(KEY_COUNTRY_CODE, "");
    }

    @NonNull
    @Override
    public ChooseCountriesHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView;
        if (isSettings) {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_country_settings, parent, false);
        } else {
            itemView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.adapter_choose_country, parent, false);
        }
        return new ChooseCountriesHolder(itemView);
    }


    @Override
    public void onBindViewHolder(@NonNull ChooseCountriesHolder holder, int position) {
        if (mCountriesResponseBodyList.get(position).getImage() != null) {
            String imagePath = mCountriesResponseBodyList.get(position).getImage();
            if (imagePath != null) {
                Glide.with(mContext)
                        .load(BASE_URL.concat(imagePath.replaceAll("\"", "")))
                        .error(R.drawable.country_error_image)
                        .into(holder.getCountryImage());
            }
        }

        holder.getCountryName().setText(mCountriesResponseBodyList.get(position).getName());
        holder.getRadioButton().setContentDescription(mCountriesResponseBodyList.get(position).getName());

        if (position == 0 && !isSettings) {
            holder.getRadioButton().setChecked(true);
            countryCode = mCountriesResponseBodyList.get(position).getShort_code();
            countryName = mCountriesResponseBodyList.get(position).getName();
            isFirst = true;
        } else if (isSettings) {
            if (Objects.equals(mCountriesResponseBodyList.get(position).getShort_code(), currentCountryCode)) {
                lastCheckedTV = holder.getCountryName();
                holder.getRadioButton().setChecked(true);
                holder.getRadioButton().setClickable(false);
                countryCode = mCountriesResponseBodyList.get(position).getShort_code();
                holder.getCountryName().setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
            }
        }

        if (holder.getRadioButton().isChecked()) {
            lastCheckedRB = holder.getRadioButton();
            lastCheckedTV = holder.getCountryName();
        }
        holder.getRadioButton().setOnClickListener(v -> {
            RadioButton radioButton = (RadioButton) v;
            TextView textView = holder.getCountryName();
            if (radioButton.isChecked()) {
                if (lastCheckedRB != null) {
                    lastCheckedRB.setChecked(false);
                    if (isSettings) {
                        lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.black));
                        boolean isDarkModeEnabled = SafeYouApp.getPreference().getBooleanValue(KEY_IS_DARK_MODE_ENABLED, false);
                        int nightModeFlags =
                                mContext.getResources().getConfiguration().uiMode &
                                        Configuration.UI_MODE_NIGHT_MASK;
                        if (isDarkModeEnabled || nightModeFlags == Configuration.UI_MODE_NIGHT_YES) {
                            lastCheckedTV.setTextColor(mContext.getResources().getColor(R.color.white));

                        }
                        holder.getCountryName().setTextColor(mContext.getResources().getColor(R.color.textPurpleColor));
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
            countryCode = mCountriesResponseBodyList.get(position).getShort_code();
            countryName = mCountriesResponseBodyList.get(position).getName();
        });
        if (position == 0 && isFirst) {
            holder.getRadioButton().setSelected(false);
            holder.getRadioButton().setClickable(false);
        }
    }

    public String getCountryCode() {
        return countryCode;
    }

    public String getCountryName() {
        return countryName;
    }

    @Override
    public int getItemCount() {
        return mCountriesResponseBodyList != null ? mCountriesResponseBodyList.size() : 0;
    }
}
