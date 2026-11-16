package fambox.pro.view.fragment;

import android.content.Context;

import java.util.List;

import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.chat.BasePrivateMessageModel;
import fambox.pro.network.model.chat.PrivateMessageUnreadListResponse;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface FragmentPrivateMessageContract {

    interface View extends MvpView {
        Context getAppContext();

        void setupPrivateMessageList(List<PrivateMessageUserListResponse> listResponses);

        void setupUnreadMessageStyles();
    }

    interface Presenter extends MvpPresenter<FragmentPrivateMessageContract.View> {
        void onResume();
    }

    interface Model extends BaseModel {
        void privateMessageUserList(Context context, NetworkCallback<Response<BasePrivateMessageModel<List<PrivateMessageUserListResponse>>>> responseNetworkCallback);

        void getUnreadMessages(String roomKey, NetworkCallback<Response<PrivateMessageUnreadListResponse>> responseNetworkCallback);
    }
}
