package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;
import static fambox.pro.Constants.Key.KEY_SERVICE_ID;
import static fambox.pro.Constants.Key.KEY_SERVICE_TYPE;

import android.content.Context;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.util.List;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.enums.Types;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.presenter.MainPresenter;
import fambox.pro.utils.ContinuousLongClick;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.SwipeDisabledViewPager;
import fambox.pro.utils.Utils;
import fambox.pro.view.fragment.FragmentHelp;
import fambox.pro.view.fragment.FragmentNetwork;
import fambox.pro.view.fragment.FragmentProfile;
import fambox.pro.view.viewpager.MainViewPager;
import pro.fambox.materialsearchview.MaterialSearchView;

public class MainActivity extends BaseActivity implements MainContract.View,
        FragmentHelp.PassData, FragmentNetwork.TransferDataListener,
        FragmentProfile.ChangeMainPageListener {

    private MainPresenter mMainPresenter;
    private FragmentNetwork.TransferSearchTextListener mTransferSearchTextListener;
    private Fragment fragment;
    private FragmentNetwork fragmentNetwork;
    private FragmentHelp fragmentHelp;
    private boolean isLongClickEnable = true;

    private final ContinuousLongClick.ContinuousLongClickListener mContinuousLongClickListener
            = new ContinuousLongClick.ContinuousLongClickListener() {
        @Override
        public void onStartLongClick(View view) {
            if (isLongClickEnable) {
                viewPager.setCurrentItem(2, false);
                bottomNavigationViewEx.setSelectedItemId(R.id.menuHelp);
                fragment = getSupportFragmentManager().findFragmentByTag("android:switcher:" + R.id.viewPager + ":" + 2);
                if (fragment instanceof FragmentHelp) {
                    fragmentHelp = (FragmentHelp) fragment;
                    fragmentHelp.onStartRecordWithMainActivity();
                }
            }
        }

        @Override
        public void onEndLongClick(View view) {
            if (isLongClickEnable) {
                fragment = getSupportFragmentManager().findFragmentByTag("android:switcher:" + R.id.viewPager + ":" + 2);
                if (fragment instanceof FragmentHelp) {
                    fragmentHelp = (FragmentHelp) fragment;
                    fragmentHelp.onStopRecordWithMainActivity();
                }
            }
        }
    };

    @BindView(R.id.bottomNavigationViewEx)
    BottomNavigationView bottomNavigationViewEx;
    @BindView(R.id.fab)
    Button fab;
    @BindView(R.id.viewPager)
    SwipeDisabledViewPager viewPager;
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
    @BindView(R.id.bottomPrivateNotificationIcon)
    ImageView bottomPrivateNotificationIcon;

    public ImageView getBottomPrivateNotificationIcon() {
        return bottomPrivateNotificationIcon;
    }

    public void setTransferSearchTextListener(FragmentNetwork.TransferSearchTextListener mTransferSearchTextListener) {
        this.mTransferSearchTextListener = mTransferSearchTextListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addAppBar(null, false, false, false,
                "", true);
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

        // TODO: chang
        SafeYouApp.getPreference().setValue(KEY_LOG_IN_FIRST_TIME, true);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        viewPager.setCurrentItem(1);
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_main;
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
        fab.setText(getResources().getString(R.string.help_title_key));
        bottomNavigationViewEx.setSelectedItemId(R.id.menuHelp);
        bottomNavigationViewEx.setAnimation(null);
        bottomNavigationViewEx.setOnItemSelectedListener(
                item -> {
                    switch (item.getItemId()) {
                        case R.id.menuForum:
                            viewPager.setCurrentItem(0);
                            break;
                        case R.id.menuNetwork:
                            viewPager.setCurrentItem(1);
                            break;
                        case R.id.menuHelp:
                            viewPager.setCurrentItem(2);
                            break;
                        case R.id.menuProfile:
                            viewPager.setCurrentItem(3);
                            break;
                        case R.id.menuOther:
                            viewPager.setCurrentItem(4);
                            break;
                    }
                    return true;
                });
        View menuItem = findViewById(R.id.menuForum);
        menuItem.post(() -> {
            float x = ((menuItem.getLeft() + menuItem.getRight()) / 2f) + 10;
            float y = bottomNavigationViewEx.getBottom() - (bottomNavigationViewEx.getHeight()) + 15;
            bottomNotificationIcon.setX(x);
            bottomNotificationIcon.setY(y);
        });

        View menuPrivatItem = findViewById(R.id.menuProfile);
        menuPrivatItem.post(() -> {
            float x = ((menuPrivatItem.getLeft() + menuPrivatItem.getRight()) / 2f) + 10;
            float y = bottomNavigationViewEx.getBottom() - (bottomNavigationViewEx.getHeight()) + 15;
            bottomPrivateNotificationIcon.setX(x);
            bottomPrivateNotificationIcon.setY(y);
        });
        new ContinuousLongClick(fab, mContinuousLongClickListener);
    }

    @Override
    public void configViewPager(int pos) {
        viewPager.setAdapter(new MainViewPager(getSupportFragmentManager()));
        viewPager.setCurrentItem(pos);
        viewPager.setOffscreenPageLimit(4);
        viewPager.setPagingEnabled(false);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                if (fragment != null) {
                    if (fragment instanceof FragmentNetwork && position != 3) {
                        fragmentNetwork.setSendSms(false);
                    }
                }
            }

            @Override
            public void onPageSelected(int position) {
                if (position != 2 && position != 1) {
                    openSurveyDialog(true);
                }
                mMainPresenter.configPagesAppBar(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    @Override
    public void openForum() {
        if (viewPager != null) viewPager.setCurrentItem(0);
    }

    @Override
    public void setSearchVisibility(int visibility) {
        networkSearch.setVisibility(visibility);
        containerNetworkSearch.setVisibility(visibility);
    }

    @OnClick(R.id.fab)
    void onClickFab() {
        bottomNavigationViewEx.setSelectedItemId(R.id.menuHelp);
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
        if (Objects.equals(getResources().getString(R.string.help_title_key), title)) {
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_HELP_FRAGMENT_COLOR);
            setToolbarColor(getResources().getColor(R.color.helpScreenBackground));
        } else {
            setToolbarColor(getResources().getColor(R.color.toolbar_background));
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        }
    }

    @Override
    public void onBackPressed() {
        if (searchView.isSearchOpen()) {
            searchView.closeSearch();
            networkSearch.setVisibility(View.VISIBLE);
        } else if (viewPager.getCurrentItem() != 2) {
            viewPager.setCurrentItem(2, false);
            bottomNavigationViewEx.setSelectedItemId(R.id.menuHelp);
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

    @Override
    public void onLongClickEnable(boolean isEnable) {
        this.isLongClickEnable = isEnable;
    }
}
