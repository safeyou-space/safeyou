package fambox.pro.presenter;

import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.PackageManagerUtil;
import fambox.pro.view.ChangeAppIconContract;

public class ChangeAppIconPresenter extends BasePresenter<ChangeAppIconContract.View> implements ChangeAppIconContract.Presenter {

    @Override
    public void viewIsReady() {
        getView().roundButtonConfig();
    }

    @Override
    public void checkRealFakePin(boolean save,
                                 boolean isCamouflageIconEnabled,
                                 boolean isArtGallerySelected,
                                 boolean isGalleryEditSelected,
                                 boolean isPhotoEditorSelected) {
        PackageManagerUtil.changeAppIcon(getView().getPackageContext(),
                isCamouflageIconEnabled,
                isArtGallerySelected,
                isGalleryEditSelected,
                isPhotoEditorSelected);
        if (save) {
            getView().goBack();
        }
    }

    @Override
    public void destroy() {
        super.destroy();
    }
}
