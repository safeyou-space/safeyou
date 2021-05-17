package fambox.pro.presenter;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import java.net.HttpURLConnection;
import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.EditProfileModel;
import fambox.pro.model.MainModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.MainContract;
import retrofit2.Response;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CHANGED;
import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;

public class MainPresenter extends BasePresenter<MainContract.View> implements MainContract.Presenter {

    private static final float PERCENTAGE_TO_HIDE_TITLE_DETAILS = 0.5f;
    private static final float TITLE_SIZE = 2.5f;
    private MainModel mMainModel;
    private EditProfileModel mEditProfileModel;
    private boolean mIsTheTitleContainerVisible = true;
    private int mCurrentVPPosition;
    private String mName;
    private String mImagePath;
    private boolean isFirst;

    @Override
    public void viewIsReady() {
        mMainModel = new MainModel();
        mEditProfileModel = new EditProfileModel();
        SafeYouApp.getPreference(getView().getContext())
                .setValue(KEY_COUNTRY_CHANGED, false);
        getView().configViews();
        // confirm first time login main activity.
        isFirst = SafeYouApp.getPreference(getView().getContext()).getBooleanValue(KEY_LOG_IN_FIRST_TIME, false);
        if (!isFirst) {
            getView().configViewPager(0);
            SafeYouApp.getPreference(getView().getContext()).setValue(KEY_LOG_IN_FIRST_TIME, true);
        } else {
            getView().configViewPager(2);
            getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.help_lowercase));
        }
    }

    @Override
    public void setViewPagerPosition(ViewPager pager) {
        mCurrentVPPosition = pager.getCurrentItem();
    }

    @Override
    public void configPagesAppBar(int type) {
        switch (type) {
            case 0:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.support));
                break;
            case 1:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.forum));
                break;
            case 2:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.help_lowercase));
                break;
            case 3:
                getView().setSearchVisibility(View.VISIBLE);
                getView().setToolbarTitle("");
                break;
            case 4:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.settings));
                break;
        }
    }

    @Override
    public void getProfile(String countryCode, String locale) {
        mMainModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    mName = response.body().getFirst_name();
                                    if (response.body().getImage() != null) {
                                        mImagePath = response.body().getImage().getUrl();
//                                        getView().setProfileImage(BASE_URL.concat(mImagePath));
                                    }
                                    if (!isFirst && mCurrentVPPosition == 0) {
                                        getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.support));
                                    }
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void checkPin(Bundle bundle) {
        String pin = SafeYouApp.getPreference(getView().getContext()).getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        if (!Objects.equals(pin, "")) {
            if (bundle != null) {
                boolean isOpenedFromNotification = bundle.getBoolean("is_opened_from_notification");
                if (isOpenedFromNotification) {
                    bundle.putBoolean("is_opened_from_notification", false);
                    getView().goPinActivity(bundle);
                } else {
                    getView().openForum();
                }
            }
        }
        if (bundle != null) {
            if (bundle.getBoolean("is_forum_notification")) {
                getView().openForum();
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mMainModel != null) {
            mMainModel.onDestroy();
        }
        if (mEditProfileModel != null) {
            mEditProfileModel.onDestroy();
        }
    }
}
