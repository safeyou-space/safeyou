package fambox.pro.view;

import android.widget.Button;
import android.widget.ToggleButton;

import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import fambox.pro.enums.Types;

public interface HelpContract {

    interface View extends MvpView {
        void openDialog(Types.InfoDialogText infoDialogText);

        ToggleButton button(int viewId);

        void configToggle(boolean dualPin, boolean info, boolean help, boolean forum, boolean ngo);
    }

    interface Presenter extends MvpPresenter<HelpContract.View> {
        void configToggleButton(int viewId, boolean isChecked);

        float getElevation(boolean isActive);
    }

    interface Model extends BaseModel {

    }
}
