package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.TextView;

import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import in.arjsna.passcodeview.PassCodeView;

public interface PassKeypadContract {
    interface View extends MvpView {
        PassCodeView getPassCodeView();

        void goProfileActivity();

        void goCommentActivity(Bundle bundle);

        void goMainActivity(Bundle bundle);

        void goSystemGalleryActivity();

        void goLoginActivity();

        void showForgotPinButton(int visibility);

        void setProgressVisibility(int visibility);
    }

    interface Presenter extends MvpPresenter<View> {

        void bindEvents();

        boolean isLocked();

        void clearPreference();

        void checkOpenedFromNotification(Bundle bundle);
    }
}
