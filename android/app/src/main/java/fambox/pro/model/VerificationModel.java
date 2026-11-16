package fambox.pro.model;

import android.content.Context;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ForgotVerifySmsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.VerifyPhoneBody;
import fambox.pro.network.model.VerifyPhoneResendBody;
import fambox.pro.view.VerificationContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class VerificationModel implements VerificationContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void verificationRequest(Context context, String countryCode, String locale,
                                    VerifyPhoneBody verifyPhoneBody,
                                    NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).verifyPhone(countryCode, locale, verifyPhoneBody)
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
    public void verificationRequestResend(Context context, String countryCode, String locale,
                                          VerifyPhoneResendBody verifyPhoneResendBody,
                                          NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).verifyPhoneResend(countryCode, locale, verifyPhoneResendBody)
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
    public void resendVerificationCode(Context context, String countryCode, String locale,
                                       VerifyPhoneResendBody verifyPhoneResendBody,
                                       NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).resendVerificationCode(countryCode, locale, verifyPhoneResendBody)
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
    public void verificationForgotRequest(Context context,
                                          String countryCode,
                                          String locale,
                                          VerifyPhoneBody verifyPhoneBody,
                                          NetworkCallback<Response<ForgotVerifySmsResponse>> response) {

        mCompositeDisposable.add(SafeYouApp.getApiService(context).verifyForgotPhone(countryCode, locale, verifyPhoneBody)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ForgotVerifySmsResponse>>() {
                    @Override
                    public void onSuccess(Response<ForgotVerifySmsResponse> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }

    @Override
    public void verificationChangedPhone(Context context,
                                         String countryCode,
                                         String locale,
                                         VerifyPhoneBody verifyPhoneBody,
                                         NetworkCallback<Response<Message>> response) {
        mCompositeDisposable.add(SafeYouApp.getApiService(context).verifyChangedPhoneNumber(countryCode, locale, verifyPhoneBody)
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
