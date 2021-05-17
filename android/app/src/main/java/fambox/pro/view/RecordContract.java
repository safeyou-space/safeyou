package fambox.pro.view;

import fambox.pro.model.BaseModel;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;

public interface RecordContract {
    interface View extends MvpView {
        void initViewPager();
    }

    interface Presenter extends MvpPresenter<View> {

    }

    interface Model extends BaseModel {

    }
}
