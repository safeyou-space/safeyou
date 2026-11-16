package fambox.pro.presenter;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.PassKeypadContract;

public class PassKeypadPresenter extends BasePresenter<PassKeypadContract.View> implements PassKeypadContract.Presenter {

    private String preferenceRealPin;
    private String preferenceFakePin;
    private boolean isLocked = false;
    private int invalidPinCount = 0;
    private Bundle mBundle;

    @Override
    public void viewIsReady() {
        getView().getPassCodeView().setKeyTextColor(Color.argb(255, 255, 255, 255));
        preferenceRealPin = SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
        preferenceFakePin = SafeYouApp.getPreference(getView().getContext())
                .getStringValue(Constants.Key.KEY_SHARED_FAKE_PIN, "");
        bindEvents();
    }

    @Override
    public void bindEvents() {
        isLocked = true;
        getView().getPassCodeView().setOnTextChangeListener(text -> {
            if (text.length() == 4) {
                if (text.equals(preferenceRealPin)) {
                    if (mBundle != null) {
                        boolean isForumNotification = mBundle.getBoolean("is_forum_notification");
                        if (isForumNotification) {
                            getView().goMainActivity(mBundle);
                        } else {
                            getView().goCommentActivity(mBundle);
                        }
                    } else {
                        getView().goProfileActivity();
                    }
                } else if (text.equals(preferenceFakePin)) {
                    getView().goSystemGalleryActivity();
                } else {
                    invalidPinCount++;
                    if (invalidPinCount >= 3) {
                        getView().showForgotPinButton(View.VISIBLE);
                        getView().getPassCodeView().reset();
                    }
                    getView().showErrorMessage(getView().getContext().getResources().getString(R.string.invalid_pin));
                    getView().getPassCodeView().reset();
                }
            }
        });
    }

    @Override
    public void clearPreference() {
        SafeYouApp.getPreference(getView().getContext()).clear();
        getView().goLoginActivity();
    }

    @Override
    public void checkOpenedFromNotification(Bundle bundle) {
        this.mBundle = bundle;
    }

    @Override
    public boolean isLocked() {
        return isLocked;
    }
}


























