package fambox.pro.view;

import android.widget.ToggleButton;

import fambox.pro.enums.Types;
import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface HelpContract {

    interface View extends MvpView {
        void openDialog(Types.InfoDialogText infoDialogText);

        ToggleButton button(int viewId);

        void configToggle(boolean dualPin, boolean info, boolean help, boolean forum, boolean ngo, boolean prvtMessage);
    }

    interface Presenter extends MvpPresenter<HelpContract.View> {
        void configToggleButton(int viewId, boolean isChecked);

        float getElevation(boolean isActive);
    }

    interface Model extends BaseModel {

    }
}
