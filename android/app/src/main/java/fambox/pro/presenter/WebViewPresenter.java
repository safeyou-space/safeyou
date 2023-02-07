package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_BIRTHDAY;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_IS_ABOUT_US;
import static fambox.pro.Constants.Key.KEY_IS_CONSULTANT_CONDITION;
import static fambox.pro.Constants.Key.KEY_IS_PRIVACY_POLICY;
import static fambox.pro.Constants.Key.KEY_IS_TERM;
import static fambox.pro.Constants.Key.KEY_PASSWORD;
import static fambox.pro.Constants.Key.KEY_USER_PHONE;

import android.os.Bundle;

import java.net.HttpURLConnection;
import java.util.Calendar;

import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.RegistrationModel;
import fambox.pro.model.WebViewModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ContentResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.view.WebViewContract;
import retrofit2.Response;

public class WebViewPresenter extends BasePresenter<WebViewContract.View>
        implements WebViewContract.Presenter {

    private WebViewModel mWebViewModel;
    private String title;
    private RegistrationBody mRegistrationBody;
    private RegistrationModel mRegistrationModel;
    private boolean isTerm;
    private boolean isPrivacyPolice;


    @Override
    public void viewIsReady() {
        mWebViewModel = new WebViewModel();
        mRegistrationModel = new RegistrationModel();
    }

    @Override
    public void setBundle(Bundle bundle, String countryCode, String locale, RegistrationBody registrationBody) {
        mRegistrationBody = registrationBody;
        if (bundle != null) {
            isTerm = bundle.getBoolean(KEY_IS_TERM);
            boolean isConsultantCondition = bundle.getBoolean(KEY_IS_CONSULTANT_CONDITION);
            boolean isAboutUs = bundle.getBoolean(KEY_IS_ABOUT_US);
            isPrivacyPolice = bundle.getBoolean(KEY_IS_PRIVACY_POLICY);

            if (isTerm) {
                title = "terms_conditions";
                getView().setIsTermsAndCondition(getView().getContext().getResources().getString(R.string.terms_and_conditions));
            } else if (isConsultantCondition) {
                title = "terms_conditions_consultant";
                getView().setIsTermsAndCondition(getView().getContext().getResources().getString(R.string.legal_consultant_terms_and_conditions));
            } else if (isAboutUs) {
                title = "about_us";
                getView().setIsTermsAndCondition(getView().getContext().getResources().getString(R.string.about_us_title_key));
            } else if (isPrivacyPolice) {
                title = "privacy_policy";
                getView().setIsTermsAndCondition(getView().getContext().getResources().getString(R.string.privacy_policy));
            }
            content(countryCode, locale);
        }
    }

    @Override
    public void content(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        String age = "";
        String birthday = SafeYouApp.getPreference(getView().getContext()).getStringValue(KEY_BIRTHDAY, "");
        if (mRegistrationBody != null && !mRegistrationBody.getBirthday().isEmpty()
                || ((isTerm || isPrivacyPolice) && !birthday.isEmpty())) {
            String[] birthDay = mRegistrationBody != null ? mRegistrationBody.getBirthday().split("/") : birthday.split("/");
            if (birthDay.length == 3) {
                int ageInt = getAge(Integer.parseInt(birthDay[2]),
                        Integer.parseInt(birthDay[1]), Integer.parseInt(birthDay[0]));
                if (ageInt < 18) {
                    age = "-18";
                }
            }
        }
        mWebViewModel.getContent(getView().getContext(), countryCode, locale, title, age,
                new NetworkCallback<Response<ContentResponse>>() {
                    @Override
                    public void onSuccess(Response<ContentResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    if (response.body().getContent() != null) {
                                        getView().configWebView(response.body().getContent());
                                    }
                                }
                            } else {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void registerUser() {
        mRegistrationModel.registrationRequest(getView().getContext(), getCountryCode(),
                getLocale(), mRegistrationBody, new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                if (response.body() != null) {
                                    SafeYouApp.getPreference(getView().getContext()).setValue(KEY_USER_PHONE, mRegistrationBody.getPhone());
                                    SafeYouApp.getPreference(getView().getContext()).setValue(KEY_BIRTHDAY, mRegistrationBody.getBirthday());
                                    SafeYouApp.getPreference(getView().getContext()).setValue(KEY_PASSWORD, mRegistrationBody.getPassword());
                                    getView().goVerifyRegistration();
                                }
                            } else {
                                getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    private String getLocale() {
        return LocaleHelper.getLanguage(getView().getContext());
    }

    private String getCountryCode() {
        return SafeYouApp.getPreference(getView().getContext())
                .getStringValue(KEY_COUNTRY_CODE, "");
    }

    private int getAge(int year, int month, int day) {
        Calendar c = Calendar.getInstance();
        c.set(Calendar.YEAR, year);
        c.set(Calendar.MONTH, month);
        c.set(Calendar.DAY_OF_MONTH, day);

        Calendar dob = Calendar.getInstance();
        dob.setTimeInMillis(c.getTimeInMillis());
        Calendar today = Calendar.getInstance();
        int age = today.get(Calendar.YEAR) - dob.get(Calendar.YEAR);
        if (today.get(Calendar.DAY_OF_MONTH) < dob.get(Calendar.DAY_OF_MONTH)) {
            age--;
        }
        return age;
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mWebViewModel != null) {
            mWebViewModel.onDestroy();
        }
        if (mRegistrationModel != null) {
            mRegistrationModel.onDestroy();
        }
    }

    public boolean isTerms() {
        return isTerm;
    }
}
