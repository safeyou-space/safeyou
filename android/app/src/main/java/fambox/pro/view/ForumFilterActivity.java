package fambox.pro.view;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;

import com.google.android.material.chip.ChipGroup;
import com.robertlevonyan.views.chip.Chip;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.ForumFilterPresenter;
import fambox.pro.utils.Utils;

public class ForumFilterActivity extends BaseActivity implements ForumFilterActivityContract.View {

    private final HashMap<String, String> mapStringCategory = new HashMap<>();
    private final HashMap<String, String> mapStringLanguages = new HashMap<>();
    private ForumFilterPresenter mForumFilterPresenter;

    @BindView(R.id.chipGroupCategory)
    ChipGroup chipGroupCategory;
    @BindView(R.id.chipGroupLanguages)
    ChipGroup chipGroupLanguages;
    @BindView(R.id.btnShow)
    Button btnShow;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        ButterKnife.bind(this);
        mForumFilterPresenter = new ForumFilterPresenter();
        mForumFilterPresenter.attachView(this);
        mForumFilterPresenter.viewIsReady();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_forum_filter;
    }

    @Override
    public void configCategoryChips(TreeMap<String, String> response) {
        mapStringCategory.clear();
        Map<String, String> mapCategory = (HashMap<String, String>) getIntent().getSerializableExtra("mapCategory");
        for (Map.Entry<String, String> value : response.entrySet()) {
            Chip chipCategory = new Chip(this);
            chipCategory.setText(value.getValue());
            chipCategory.setTag(value.getKey());
            chipCategory.setChipTextColor(getResources().getColor(R.color.black));
            chipCategory.setTypeface(Typeface.create(ResourcesCompat.getFont(this, R.font.hay_roboto_regular), Typeface.NORMAL));
            chipCategory.setChipBackgroundColor(getResources().getColor(R.color.chip_background_color));
            chipCategory.setChipSelectedBackgroundColor(getResources().getColor(R.color.new_main_color));
            chipCategory.setChipSelectedTextColor(getResources().getColor(R.color.white));
            chipCategory.setCornerRadius(getResources().getDimensionPixelSize(R.dimen.chip_corner_radius));
            chipCategory.setSelectable(true);
            chipCategory.setChipSelectableWithoutIcon(true);
            chipCategory.setOnSelectClickListener((view, b) -> {
                if (chipGroupCategory.getChildCount() >= 0) {
                    ((Chip) chipGroupCategory.getChildAt(0)).setChipSelected(false);
                }
                if (b) {
                    mapStringCategory.put((String) chipCategory.getTag(), ((Chip) view).getText().toString());
                } else {
                    mapStringCategory.remove((String) chipCategory.getTag());
                }
                if (mapStringCategory.isEmpty()) {
                    ((Chip) chipGroupCategory.getChildAt(0)).setChipSelected(true);
                }
            });

            if (mapCategory != null) {
                String string = mapCategory.get(value.getKey());
                if (string != null && !string.equals("")) {
                    chipCategory.setChipSelected(true);
                    mapStringCategory.put((String) chipCategory.getTag(), value.getValue());
                }
            }

            chipGroupCategory.addView(chipCategory);
            Chip chip1 = (Chip) chipGroupCategory.getChildAt(0);

            if (mapCategory == null || mapCategory.size() == 0) {
                chip1.setChipSelected(true);
            }
            chip1.setOnSelectClickListener((view, b) -> {
                chip1.setChipSelected(true);
                for (int i = 1; i < chipGroupCategory.getChildCount(); i++) {
                    Chip chip2 = (Chip) chipGroupCategory.getChildAt(i);
                    chip2.setChipSelected(false);
                    mapStringCategory.clear();
                }
            });
        }
    }

    @Override
    public void configLanguageChips(TreeMap<String, String> response) {
        mapStringLanguages.clear();
        Map<String, String> mapLanguage = (HashMap<String, String>) getIntent().getSerializableExtra("mapLanguage");
        for (Map.Entry<String, String> value : response.entrySet()) {
            Chip chipLanguage = new Chip(this);
            chipLanguage.setText(value.getValue());
            chipLanguage.setTag(value.getKey());
            chipLanguage.setChipTextColor(getResources().getColor(R.color.black));
            chipLanguage.setTypeface(Typeface.create(ResourcesCompat.getFont(this, R.font.hay_roboto_regular), Typeface.NORMAL));
            chipLanguage.setChipBackgroundColor(getResources().getColor(R.color.chip_background_color));
            chipLanguage.setChipSelectedBackgroundColor(getResources().getColor(R.color.new_main_color));
            chipLanguage.setChipSelectedTextColor(getResources().getColor(R.color.white));
            chipLanguage.setCornerRadius(getResources().getDimensionPixelSize(R.dimen.chip_corner_radius));
            chipLanguage.setSelectable(true);
            chipLanguage.setChipSelectableWithoutIcon(true);
            chipLanguage.setOnSelectClickListener((view, b) -> {
                clearCheck(chipGroupLanguages);

                if (chipGroupLanguages.getChildCount() >= 0) {
                    ((Chip) chipGroupLanguages.getChildAt(0)).setChipSelected(false);
                }
                mapStringLanguages.clear();
                mapStringLanguages.put((String) chipLanguage.getTag(), ((Chip) view).getText().toString());

                if (mapStringLanguages.isEmpty()) {
                    ((Chip) chipGroupLanguages.getChildAt(0)).setChipSelected(true);
                } else {
                    ((Chip) view).setChipSelected(true);
                }
                if (chipLanguage.getTag().equals("all")) {
                    mapStringLanguages.clear();
                }
            });

            if (mapLanguage != null) {
                String string = mapLanguage.get(value.getKey());
                if (string != null && !string.equals("")) {
                    chipLanguage.setChipSelected(true);
                    mapStringLanguages.put((String) chipLanguage.getTag(), value.getValue());
                }
            }

            chipGroupLanguages.addView(chipLanguage);
            Chip chipAllLanguage = (Chip) chipGroupLanguages.getChildAt(0);
            if (mapLanguage == null || mapLanguage.size() == 0) {
                chipAllLanguage.setChipSelected(true);
            }
            chipAllLanguage.setOnSelectClickListener((view, b) -> {
                clearCheck(chipGroupLanguages);
                ((Chip) view).setChipSelected(true);
                mapStringLanguages.clear();
            });
        }


    }


    @OnClick(R.id.btnClearAllCategories)
    void clickClearAllCategories() {
        clearDefault(chipGroupCategory, mapStringCategory);
    }

    @OnClick(R.id.btnClearAllLanguages)
    void clickClearAllLanguages() {
        clearDefault(chipGroupLanguages, mapStringLanguages);
    }

    @OnClick(R.id.btnClearAllFilters)
    void clickClearAllFilters() {
        clearDefault(chipGroupCategory, mapStringCategory);
        clearDefault(chipGroupLanguages, mapStringLanguages);
    }

    @OnClick(R.id.btnShow)
    void clickShow() {
        Intent intent = new Intent();
        intent.putExtra("mapCategory", mapStringCategory);
        intent.putExtra("mapLanguage", mapStringLanguages);
        setResult(RESULT_OK, intent);
        finish();
    }

    @OnClick(R.id.closeFilterActivity)
    void clickCloseFilterActivity() {
        finish();
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }

    private void clearDefault(ChipGroup chipGroup, Map<String, String> map) {
        if (chipGroup.getChildCount() >= 0) {
            Chip chip1 = (Chip) chipGroup.getChildAt(0);
            chip1.setChipSelected(true);
            for (int i = 1; i < chipGroup.getChildCount(); i++) {
                Chip chip2 = (Chip) chipGroup.getChildAt(i);
                chip2.setChipSelected(false);
                map.clear();
            }
        }
    }

    private void clearCheck(ChipGroup chipGroup) {
        for (int i = 0; i < chipGroup.getChildCount(); i++) {
            View child = chipGroup.getChildAt(i);
            if (child instanceof Chip) {
                ((Chip) child).setChipSelected(false);
            }
        }
    }
}