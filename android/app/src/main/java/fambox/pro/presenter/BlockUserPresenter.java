package fambox.pro.presenter;

import android.view.View;

import androidx.annotation.NonNull;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.SafeYouApp;
import fambox.pro.network.model.BlockUserPostBody;
import fambox.pro.network.model.chat.BlockUserResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.privatechat.network.model.BlockedUsers;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.BlockUserContract;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class BlockUserPresenter extends BasePresenter<BlockUserContract.View>
        implements BlockUserContract.Presenter {

    @Override
    public void viewIsReady() {
        getBlackList();
    }

    @Override
    public void destroy() {
        super.destroy();
    }

    @Override
    public void onDeleteBlockedUser(long userId) {
        if (SafeYouApp.getChatApiService() != null) {
            getView().setProgressVisibility(View.VISIBLE);
            BlockUserPostBody blockUserPostBody = new BlockUserPostBody();
            blockUserPostBody.setUserId(userId);
            if (SafeYouApp.getChatApiService() != null) {
                SafeYouApp.getChatApiService().postUnBlockUser(blockUserPostBody)
                        .enqueue(new Callback<BlockUserResponse>() {
                            @Override
                            public void onResponse(@NonNull Call<BlockUserResponse> call, @NonNull Response<BlockUserResponse> response) {
                                getView().setProgressVisibility(View.INVISIBLE);
                                getView().deleteUnblockedUser(userId);
                            }

                            @Override
                            public void onFailure(@NonNull Call<BlockUserResponse> call, @NonNull Throwable t) {
                                getView().setProgressVisibility(View.INVISIBLE);

                            }
                        });
            }
        }
    }

    private void getBlackList() {
        if (SafeYouApp.getChatApiService() != null) {
            getView().setProgressVisibility(View.VISIBLE);
            SafeYouApp.getChatApiService().getBlockedUsers().enqueue(new Callback<BlockedUsers>() {
                @Override
                public void onResponse(@NonNull Call<BlockedUsers> call,
                                       @NonNull Response<BlockedUsers> response) {
                    if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                        if (response.body() != null) {
                            List<? extends BlockedUsers> blockedUsers = response.body().getData();
                            if (blockedUsers != null) {

                                getView().initRecView(blockedUsers);
                            }
                        }
                    }
                    if (getView() != null) {
                        getView().setProgressVisibility(View.GONE);
                    }
                }

                @Override
                public void onFailure(@NonNull Call<BlockedUsers> call, @NonNull Throwable t) {
                    if (getView() != null) {
                        getView().setProgressVisibility(View.GONE);
                    }
                }
            });
        }
    }
}
