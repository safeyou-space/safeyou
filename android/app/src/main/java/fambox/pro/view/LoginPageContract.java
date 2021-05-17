package fambox.pro.view;

import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface LoginPageContract {

    interface View extends MvpView {

    }

    interface Presenter extends MvpPresenter<LoginPageContract.View> {
    }

    interface Model extends BaseModel {

    }
}
