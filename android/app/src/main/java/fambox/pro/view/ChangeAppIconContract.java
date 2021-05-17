package fambox.pro.view;

import android.content.Context;

import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface ChangeAppIconContract {

    interface View extends MvpView {

        void roundButtonConfig();

        void showPopup();

        void onSubmit(boolean save);

        void goBack();

        Context getPackageContext();
    }

    interface Presenter extends MvpPresenter<ChangeAppIconContract.View> {
        void checkRealFakePin(boolean save,
                              boolean isCamouflageIconEnabled,
                              boolean isArtGallerySelected,
                              boolean isGalleryEditSelected,
                              boolean isPhotoEditorSelected);
    }
}
