package fambox.pro.presenter;

import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.HelpContract;

public class HelpPresenter extends BasePresenter<HelpContract.View> implements HelpContract.Presenter {

    @Override
    public void viewIsReady() {

    }

    @Override
    public void configToggleButton(int viewId, boolean isChecked) {
        switch (viewId) {
            case R.id.btnDualPin:
                if (getView().button(R.id.btnDualPin).isChecked()) {
                    getView().configToggle(true, false, false, false, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_DUAL_PIN);
                }
                break;
            case R.id.btnInfo:
                if (getView().button(R.id.btnInfo).isChecked()) {
                    getView().configToggle(false, true, false, false, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_INFO_NETWORK);
                }
                break;
            case R.id.btnHelp:
                if (getView().button(R.id.btnHelp).isChecked()) {
                    getView().configToggle(false, false, true, false, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_HELP);
                }
                break;
            case R.id.btnForums:
                if (getView().button(R.id.btnForums).isChecked()) {
                    getView().configToggle(false, false, false, true, false, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_FORUMS);
                }
                break;
            case R.id.btnNGO:
                if (getView().button(R.id.btnNGO).isChecked()) {
                    getView().configToggle(false, false, false, false, true, false);
                    getView().openDialog(Types.InfoDialogText.TEXT_NGO_S);
                }
                break;
            case R.id.btnPrrivateMessage:
                if (getView().button(R.id.btnPrrivateMessage).isChecked()) {
                    getView().configToggle(false, false, false, false, false, true);
                    getView().openDialog(Types.InfoDialogText.TEXT_PRIVATE_MESSAGE);
                }
                break;
        }
    }

    @Override
    public float getElevation(boolean isActive) {
        return isActive ? 0f : 10f;
    }
}
