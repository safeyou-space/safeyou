package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CHANGED;

import android.os.Bundle;
import android.view.View;

import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.EditProfileModel;
import fambox.pro.model.MainModel;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.MainContract;

public class MainPresenter extends BasePresenter<MainContract.View> implements MainContract.Presenter {

    private MainModel mMainModel;
    private EditProfileModel mEditProfileModel;

    @Override
    public void viewIsReady() {
        mMainModel = new MainModel();
        mEditProfileModel = new EditProfileModel();
        SafeYouApp.getPreference(getView().getContext())
                .setValue(KEY_COUNTRY_CHANGED, false);
        getView().configViews();
        getView().configViewPager(2);
        getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.help_title_key));
    }

    @Override
    public void configPagesAppBar(int type) {
        switch (type) {
            case 0:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.forums_title_key));
                break;
            case 1:
                getView().setSearchVisibility(View.VISIBLE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.network_title));
                break;
            case 2:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.help_title_key));
                break;
            case 3:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.messages));
                break;
            case 4:
                getView().setSearchVisibility(View.GONE);
                getView().setToolbarTitle(getView().getContext().getResources().getString(R.string.title_menu));
                break;
        }
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
