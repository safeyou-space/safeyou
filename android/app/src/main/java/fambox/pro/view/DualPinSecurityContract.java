package fambox.pro.view;

import android.os.Bundle;
import android.text.Editable;

import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface DualPinSecurityContract {

    interface View extends MvpView {
        void showPopup();

        void onSubmit(boolean save);

        void goBack();

        void finishCamouflageActivity();
    }

    interface Presenter extends MvpPresenter<DualPinSecurityContract.View> {
        void initBundle(Bundle bundle);

        void checkRealFakePin(boolean save,
                              boolean isDualPinEnabled,
                              Editable realPin,
                              Editable confirmRealPin,
                              Editable fakePin,
                              Editable confirmFakePin);

        boolean checkFields(StringBuilder message,
                            Editable realPin,
                            Editable confirmRealPin,
                            Editable fakePin,
                            Editable confirmFakePin);

        boolean isSaveCamouflageIcon();
    }
}
