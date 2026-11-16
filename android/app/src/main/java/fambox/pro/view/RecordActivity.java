package fambox.pro.view;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.widget.Toolbar;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.presenter.RecordPresenter;
import fambox.pro.utils.SwipeDisabledViewPager;
import fambox.pro.utils.Utils;
import fambox.pro.view.fragment.FragmentRecords;
import fambox.pro.view.viewpager.RecordViewPagerAdapter;
import pro.fambox.materialsearchview.MaterialSearchView;

public class RecordActivity extends BaseActivity implements RecordContract.View, FragmentRecords.SearchListener {

    private RecordPresenter mRecordPresenter;
    private FragmentRecords.DataReceivedListener mDataReceivedListener;
    private int colorWhite;
    private int colorMain;
    private Drawable defaultBackground;
    private Drawable pressedBackground;
    @BindView(R.id.recordViewPager)
    SwipeDisabledViewPager recordViewPager;
    @BindView(R.id.searchView)
    MaterialSearchView searchView;
    @BindView(R.id.toolbarRecordings)
    Toolbar toolbarRecordings;
    @BindView(R.id.notificationView)
    ImageView notificationView;
    @BindView(R.id.searchIcon)
    ImageView searchIcon;

    @BindView(R.id.txtAll)
    TextView txtAll;
    @BindView(R.id.txtSaved)
    TextView txtSaved;
    @BindView(R.id.txtSend)
    TextView txtSend;

    public void setDataReceivedListener(FragmentRecords.DataReceivedListener dataReceivedListener) {
        this.mDataReceivedListener = dataReceivedListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        ButterKnife.bind(this);
        mRecordPresenter = new RecordPresenter();
        mRecordPresenter.attachView(this);
        colorWhite = getResources().getColor(R.color.white);
        colorMain = getResources().getColor(R.color.new_main_color);
        defaultBackground = getResources().getDrawable(R.drawable.recording_filter_background);
        pressedBackground = getResources().getDrawable(R.drawable.recording_filter_pressed_background);
        searchView.setEllipsize(true);
        searchView.setOnQueryTextListener(new MaterialSearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                if (mDataReceivedListener != null) {
                    mDataReceivedListener.onDataReceived(newText);
                }
                return true;
            }
        });

        searchView.setOnSearchViewListener(new MaterialSearchView.SearchViewListener() {
            @Override
            public void onSearchViewShown() {
                searchIcon.setVisibility(View.GONE);
            }

            @Override
            public void onSearchViewClosed() {
                searchIcon.setVisibility(View.VISIBLE);
                searchView.setVisibility(View.GONE);
            }
        });

        searchView.setSubmitOnClick(true);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_record;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mRecordPresenter != null) {
            mRecordPresenter.detachView();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mRecordPresenter != null) {
            mRecordPresenter.viewIsReady();
            toolbarRecordings.setSubtitle(getResources().getString(R.string.all_recordings));
            toolbarRecordings.setNavigationIcon(getResources().getDrawable(R.drawable.icon_back_white));
            toolbarRecordings.setNavigationOnClickListener(v -> onBackPressed());
            toolbarRecordings.setNavigationContentDescription(R.string.back_icon_description);
        }
        searchView.closeSearch();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mRecordPresenter != null) {
            mRecordPresenter.destroy();
        }
    }

    @Override
    public void initViewPager() {
        recordViewPager.setPagingEnabled(false);
        recordViewPager.setAdapter(new RecordViewPagerAdapter(this, getSupportFragmentManager()));
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

    @Override
    public void onSuggestion(List<RecordSearchResult> recordSearchResults) {
        String[] s = new String[recordSearchResults.size()];
        for (int i = 0; i < recordSearchResults.size(); i++) {
            s[i] = recordSearchResults.get(i).getName();
        }
        if (s.length == 0) {
            searchView.dismissSuggestions();
        } else {
            searchView.setSuggestions(s);
        }
        searchView.setOnItemClickListener((parent, view, position, id) -> {
            Bundle bundle = new Bundle();
            if (recordSearchResults.size() > 0) {
                bundle.putLong("record_id", recordSearchResults.get(position).getId());
            }
            nextActivity(RecordActivity.this, RecordDetailsActivity.class, bundle);
        });
    }

    @Override
    public void onBackPressed() {
        if (searchView.isSearchOpen()) {
            searchView.closeSearch();
            searchIcon.setVisibility(View.VISIBLE);
        } else {
            super.onBackPressed();
        }
    }

    @OnClick(R.id.searchIcon)
    void onClickSearch() {
        searchView.setVisibility(View.VISIBLE);
        searchView.showSearch(false);
    }

    @OnClick(R.id.txtAllContainer)
    void txtAllClick() {
        configFilter(true, false, false);
    }

    @OnClick(R.id.txtSavedContainer)
    void txtSavedClick() {
        configFilter(false, true, false);
    }

    @OnClick(R.id.txtSendContainer)
    void txtSendClick() {
        configFilter(false, false, true);
    }

    private void configFilter(boolean txtAllClicked, boolean txtSavedClicked, boolean txtSendClicked) {
        txtAll.setTextColor(txtAllClicked ? colorWhite : colorMain);
        txtAll.setBackground(txtAllClicked ? pressedBackground : defaultBackground);
        txtSaved.setTextColor(txtSavedClicked ? colorWhite : colorMain);
        txtSaved.setBackground(txtSavedClicked ? pressedBackground : defaultBackground);
        txtSend.setTextColor(txtSendClicked ? colorWhite : colorMain);
        txtSend.setBackground(txtSendClicked ? pressedBackground : defaultBackground);

        if (txtAllClicked) {
            recordViewPager.setCurrentItem(0);
        } else if (txtSavedClicked) {
            recordViewPager.setCurrentItem(1);
        } else if (txtSendClicked) {
            recordViewPager.setCurrentItem(2);
        }
    }
}
