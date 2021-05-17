package fambox.pro.presenter;

import android.os.Bundle;
import android.text.Editable;

import java.util.Objects;

import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.PackageManagerUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.DualPinSecurityContract;

public class DualPinSecurityPresenter extends BasePresenter<DualPinSecurityContract.View> implements DualPinSecurityContract.Presenter {

    private boolean mIsSaveCamouflageIcon;
    private boolean mIsArtGallerySelected;
    private boolean mIsGalleryEditSelected;
    private boolean mIsPhotoEditorSelected;

    @Override
    public void viewIsReady() {
    }

    @Override
    public void initBundle(Bundle bundle) {
        if (bundle != null) {
            this.mIsArtGallerySelected = bundle.getBoolean("is_art_gallery_selected");
            this.mIsGalleryEditSelected = bundle.getBoolean("is_gallery_edit_selected");
            this.mIsPhotoEditorSelected = bundle.getBoolean("is_photo_editor_selected");
            this.mIsSaveCamouflageIcon = mIsArtGallerySelected
                    || mIsGalleryEditSelected || mIsPhotoEditorSelected;
        }
    }

    @Override
    public void checkRealFakePin(boolean save,
                                 boolean isDualPinEnabled,
                                 Editable realPin,
                                 Editable confirmRealPin,
                                 Editable fakePin,
                                 Editable confirmFakePin) {
        if (isDualPinEnabled) {
            StringBuilder message = new StringBuilder();
            if (checkFields(message, realPin, confirmRealPin, fakePin, confirmFakePin)) {
                SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_REAL_PIN, Utils.getEditableToString(realPin));
                SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_FAKE_PIN, Utils.getEditableToString(fakePin));
                SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_WITHOUT_PIN, true);
            } else {
                getView().showErrorMessage(message.toString());
                return;
            }
        } else {
            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_WITHOUT_PIN, false);
            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_REAL_PIN, "");
            SafeYouApp.getPreference(getView().getContext()).setValue(Constants.Key.KEY_SHARED_FAKE_PIN, "");
        }

        if (mIsSaveCamouflageIcon) {
            PackageManagerUtil.changeAppIcon(getView().getContext(),
                    mIsSaveCamouflageIcon,
                    mIsArtGallerySelected,
                    mIsGalleryEditSelected,
                    mIsPhotoEditorSelected);
            getView().finishCamouflageActivity();
        }

        if (save) {
            getView().goBack();
        }
    }

    @Override
    public boolean checkFields(StringBuilder message,
                               Editable realPin,
                               Editable confirmRealPin,
                               Editable fakePin,
                               Editable confirmFakePin) {
        String realPinToString = Utils.getEditableToString(realPin);
        String confirmRealPinToString = Utils.getEditableToString(confirmRealPin);
        String fakePinToString = Utils.getEditableToString(fakePin);
        String confirmFakePinToString = Utils.getEditableToString(confirmFakePin);
        if (realPinToString.equals("")
                || confirmRealPinToString.equals("")
                || fakePinToString.equals("")
                || confirmFakePinToString.equals("")) {
            if (message != null) {
                message.append(getView().getContext().getResources().getString(R.string.please_fill_in_all_fields));
            }
            return false;
        } else if (Objects.equals(confirmRealPinToString, confirmFakePinToString)) {
            if (message != null) {
                message.append(getView().getContext().getResources().getString(R.string.real_and_fake_dublicated));
            }
            return false;
        } else if (!Objects.equals(realPinToString, confirmRealPinToString)) {
            if (message != null) {
                message.append(getView().getContext().getResources().getString(R.string.real_pin_and_conform_real_not_match));
            }
            return false;
        } else if (checkLength(realPinToString, confirmRealPinToString,
                fakePinToString, confirmFakePinToString)) {
            if (message != null) {
                message.append(getView().getContext().getResources().getString(R.string.pin_min_length));
            }
            return false;
        } else if (!Objects.equals(fakePinToString, confirmFakePinToString)) {
            if (message != null) {
                message.append(getView().getContext().getResources().getString(R.string.fake_and_fake_confirm_not_match));
            }
            return false;
        }
        return true;
    }

    @Override
    public boolean isSaveCamouflageIcon() {
        return mIsSaveCamouflageIcon;
    }

    @Override
    public void destroy() {
        super.destroy();
    }

    private boolean checkLength(String realPinToString,
                                String confirmRealPinToString,
                                String fakePinToString,
                                String confirmFakePinToString) {
        return realPinToString.length() < 4 || confirmRealPinToString.length() < 4
                || fakePinToString.length() < 4 || confirmFakePinToString.length() < 4;
    }
}
