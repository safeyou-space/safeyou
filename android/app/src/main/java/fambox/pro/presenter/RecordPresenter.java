package fambox.pro.presenter;

import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.view.RecordContract;

public class RecordPresenter extends BasePresenter<RecordContract.View> implements RecordContract.Presenter {

    @Override
    public void viewIsReady() {
        // init view pager all records
        getView().initViewPager();
    }

}
