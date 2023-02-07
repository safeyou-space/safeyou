package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface MainContract {

    interface View extends MvpView {

        void configViews();

        void configViewPager(int position);

        void openForum();

        void setToolbarTitle(String title);

        void setSearchVisibility(int visibility);

        void goPinActivity(Bundle bundle);
    }

    interface Presenter extends MvpPresenter<MainContract.View> {

        void configPagesAppBar(int type);

        void checkPin(Bundle bundle);
    }

    interface Model extends BaseModel {
        void getProfile(Context context, String countryCode, String locale,
                        NetworkCallback<Response<ProfileResponse>> response);
    }
}
