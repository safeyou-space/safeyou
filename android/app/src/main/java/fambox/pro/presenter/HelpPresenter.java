package fambox.pro.presenter;

import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.enums.Types;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.HelpContract;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;

public class HelpPresenter extends BasePresenter<HelpContract.View> implements HelpContract.Presenter {

    @Override
    public void viewIsReady() {

    }

    //    @OnCheckedChanged({R.id.btnDualPin, R.id.btnInfo, R.id.btnForums, R.id.btnNGO,R.id.btnHelp})

    @Override
    public void configToggleButton(int viewId, boolean isChecked) {
        switch (viewId) {
            case R.id.btnDualPin:
                if (getView().button(R.id.btnDualPin).isChecked()) {
                    getView().configToggle(true, false, false, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_DUAL_PIN);
                }
                break;
            case R.id.btnInfo:
                if (getView().button(R.id.btnInfo).isChecked()) {
                    getView().configToggle(false, true, false, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_INFO_NETWORK);
                }
                break;
            case R.id.btnHelp:
                if (getView().button(R.id.btnHelp).isChecked()) {
                    getView().configToggle(false, false, true, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_HELP);
                }
                break;
            case R.id.btnForums:
                if (getView().button(R.id.btnForums).isChecked()) {
                    getView().configToggle(false, false, false, true, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_FORUMS);
                }
                break;
            case R.id.btnNGO:
                if (getView().button(R.id.btnNGO).isChecked()) {
                    getView().configToggle(false, false, false, false, true);
                    getView().openDialog(Types.InfoDialogText.TEXT_NGO_S);
                }
                break;
        }
    }

    @Override
    public float getElevation(boolean isActive) {
        return isActive ? 0f : 10f;
    }
}
