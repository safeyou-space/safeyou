package fambox.pro.view;

import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.res.ResourcesCompat;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.ittianyu.bottomnavigationviewex.BottomNavigationViewEx;

import java.util.List;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.presenter.MainPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.fragment.FragmentHelp;
import fambox.pro.view.fragment.FragmentNetwork;
import fambox.pro.view.fragment.FragmentProfile;
import fambox.pro.view.viewpager.MainViewPager;
import pro.fambox.materialsearchview.MaterialSearchView;

import static fambox.pro.Constants.Key.KEY_SERVICE_ID;
import static fambox.pro.Constants.Key.KEY_SERVICE_TYPE;

public class MainActivity extends BaseActivity implements MainContract.View,
        FragmentHelp.PassData, FragmentNetwork.TransferDataListener,
        FragmentProfile.ChangeMainPageListener {

    private MainPresenter mMainPresenter;
    private FragmentNetwork.TransferSearchTextListener mTransferSearchTextListener;
    private Fragment fragment;
    private FragmentNetwork fragmentNetwork;

    @BindView(R.id.bottomNavigationViewEx)
    BottomNavigationViewEx bottomNavigationViewEx;
    @BindView(R.id.fab)
    FloatingActionButton fab;
    @BindView(R.id.viewPager)
    ViewPager viewPager;
    @BindView(R.id.screenDimmer)
    View screenDimmer;
    @BindView(R.id.containerNetworkSearch)
    ConstraintLayout containerNetworkSearch;
    @BindView(R.id.networkSearch)
    TextView networkSearch;
    @BindView(R.id.searchView)
    MaterialSearchView searchView;
    @BindView(R.id.bottomNotificationIcon)
    ImageView bottomNotificationIcon;

    public ImageView getBottomNotificationIcon() {
        return bottomNotificationIcon;
    }

    public void setTransferSearchTextListener(FragmentNetwork.TransferSearchTextListener mTransferSearchTextListener) {
        this.mTransferSearchTextListener = mTransferSearchTextListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addAppBar(null, false, false, false,
                getResources().getString(R.string.help), true);
//        setSupportActionBar(toolbar);
        ButterKnife.bind(this);
        mMainPresenter = new MainPresenter();
        mMainPresenter.attachView(MainActivity.this);
        mMainPresenter.viewIsReady();
        mMainPresenter.checkPin(getIntent().getExtras());
        searchView.setOnQueryTextListener(new MaterialSearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                if (mTransferSearchTextListener != null) {
                    mTransferSearchTextListener.onSendSearch(newText);
                }
                return true;
            }
        });

        searchView.setOnSearchViewListener(new MaterialSearchView.SearchViewListener() {
            @Override
            public void onSearchViewShown() {
                networkSearch.setVisibility(View.GONE);
            }

            @Override
            public void onSearchViewClosed() {
                networkSearch.setVisibility(View.VISIBLE);
                searchView.setVisibility(View.GONE);
            }
        });

        searchView.setSubmitOnClick(true);

        logSentFriendRequestEvent();
    }

    /**
     * This function assumes logger is an instance of AppEventsLogger and has been
     * created using AppEventsLogger.newLogger() call.
     */
    public void logSentFriendRequestEvent() {
        AppEventsLogger logger = AppEventsLogger.newLogger(this);

        Bundle params = new Bundle();
        params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, "USD");
        params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, "product");
        params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, "HDFU-8452");

        logger.logEvent(AppEventsConstants.EVENT_NAME_ADDED_TO_CART,
                54.23,
                params);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_main;
    }

    @Override
    protected void onResume() {
        super.onResume();
//        addAppBar(null, false, false, false,
//                getResources().getString(R.string.help), true);
        mMainPresenter.getProfile(getCountryCode(), getLocale());
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mMainPresenter != null) {
            mMainPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mMainPresenter != null) {
            mMainPresenter.destroy();
        }
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @Override
    public void configViews() {
        Typeface face = ResourcesCompat.getFont(this, R.font.hay_roboto_regular);
        bottomNavigationViewEx.enableItemShiftingMode(false);
        bottomNavigationViewEx.enableShiftingMode(false);
        bottomNavigationViewEx.enableAnimation(false);
        bottomNavigationViewEx.setupWithViewPager(viewPager);
        bottomNavigationViewEx.setTextSize(getResources().getDimensionPixelOffset(R.dimen._3ssp));
        bottomNavigationViewEx.setTypeface(face);
        if (Objects.equals(getCountryCode(), "geo") || Objects.equals(getLocale(), "ka")) {
            fab.setImageDrawable(Utils.textToDrawable(this, "SOS"));
        } else {
            fab.setImageDrawable(Utils.textToDrawable(this, getResources().getString(R.string.help)));
        }

        View menuItem = findViewById(R.id.menuForum);
        menuItem.post(() -> {
            bottomNotificationIcon.setX(((menuItem.getLeft() + menuItem.getRight()) / 2f)
                    - (bottomNotificationIcon.getWidth() / 2f));
            bottomNotificationIcon.setY(bottomNavigationViewEx.getBottom()
                    - (bottomNavigationViewEx.getHeight() + bottomNotificationIcon.getHeight() + 15));
        });
    }

    @Override
    public void configViewPager(int pos) {
        viewPager.setAdapter(new MainViewPager(getSupportFragmentManager()));
        viewPager.setCurrentItem(pos);
        viewPager.setOffscreenPageLimit(4);
        mMainPresenter.setViewPagerPosition(viewPager);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                mMainPresenter.setViewPagerPosition(viewPager);
                if (fragment != null) {
                    if (fragment instanceof FragmentNetwork && position != 3) {
                        fragmentNetwork.setSendSms(false);
                    }
                }
            }

            @Override
            public void onPageSelected(int position) {
                mMainPresenter.configPagesAppBar(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    @Override
    public void openForum() {
        if (viewPager != null) viewPager.setCurrentItem(1);
    }

    @Override
    public void setSearchVisibility(int visibility) {
        networkSearch.setVisibility(visibility);
        containerNetworkSearch.setVisibility(visibility);
    }

    @OnClick(R.id.fab)
    void onClickFab() {
        viewPager.setCurrentItem(2, false);
    }

    @OnClick(R.id.screenDimmer)
    void onClickScreenDimmer() {
        screenDimmer.setVisibility(View.GONE);
    }

    @OnClick(R.id.networkSearch)
    void onClickOpenSearch() {
        searchView.setVisibility(View.VISIBLE);
        searchView.showSearch(false);
    }

    @Override
    public void goPinActivity(Bundle bundle) {
        nextActivity(this, PassKeypadActivity.class, bundle);
        finish();
    }

    @Override
    public void setToolbarTitle(String title) {
        setBaseTitle(title);
    }

    @Override
    public void onBackPressed() {
        if (viewPager.getCurrentItem() != 2) {
            viewPager.setCurrentItem(2, false);
        } else if (searchView.isSearchOpen()) {
            searchView.closeSearch();
            networkSearch.setVisibility(View.VISIBLE);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void onDataReceived(List<ServicesSearchResponse> responses) {
        String[] s = new String[responses.size()];
        for (int i = 0; i < responses.size(); i++) {
            s[i] = responses.get(i).getName();
        }
        if (s.length == 0) {
            searchView.dismissSuggestions();
        } else {
            searchView.setSuggestions(s);
        }
        searchView.setOnItemClickListener((parent, view, position, id) -> {
            Bundle bundle = new Bundle();
            bundle.putString(KEY_SERVICE_TYPE, responses.get(position).getType());
            bundle.putLong(KEY_SERVICE_ID, responses.get(position).getId());
            nextActivity(MainActivity.this, NgoMapDetailActivity.class, bundle);
        });
    }

    /**
     * Changing app bar text in {@link FragmentHelp}
     *
     * @param text app bar text.
     */
    @Override
    public void onAppBarTextChange(String text) {
        setBaseTitle(text);
    }

    /**
     * Changing screen dimmer visibility in {@link FragmentHelp}
     *
     * @param visibility screen dimmer visibility.
     */
    @Override
    public void onScreenDimmer(int visibility) {
        screenDimmer.setVisibility(visibility);
    }

    @Override
    public void onPageChange(int page, long serviceId, boolean isSendSms) {
        viewPager.setCurrentItem(page, false);
        // get fragment by view pager id and position.
        fragment =
                getSupportFragmentManager()
                        .findFragmentByTag("android:switcher:" + R.id.viewPager + ":" + page);
        if (fragment instanceof FragmentNetwork) {
            fragmentNetwork = (FragmentNetwork) fragment;
            fragmentNetwork.setServiceId(serviceId, true, true);
        }
    }
}
