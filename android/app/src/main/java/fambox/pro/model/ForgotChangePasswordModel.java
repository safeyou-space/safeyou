package fambox.pro.model;

import android.content.Context;

import java.util.HashMap;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.CreateNewPasswordBody;
import fambox.pro.network.model.Message;
import fambox.pro.view.ForgotChangePassContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ForgotChangePasswordModel implements ForgotChangePassContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();


    @Override
    public void sendPhoneNumber(Context context,
                                String countryCode,
                                String locale,
                                String phoneNumber,
                                NetworkCallback<Response<Message>> response) {
        HashMap<String, String> phone = new HashMap<>();
        phone.put("phone", phoneNumber);
        mCompositeDisposable.add(SafeYouApp.getApiService(context).forgotPasswordSendPhone(countryCode, locale, phone)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));

    }

    @Override
    public void createNewPassword(Context context, String countryCode, String locale, CreateNewPasswordBody createNewPasswordBody,
                                  NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).createNewPassword(countryCode, locale, createNewPasswordBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
