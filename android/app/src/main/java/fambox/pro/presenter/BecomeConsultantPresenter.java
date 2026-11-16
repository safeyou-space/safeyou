package fambox.pro.presenter;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

import android.text.TextUtils;
import android.util.Patterns;

import java.net.HttpURLConnection;
import java.util.List;

import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.model.BecomeConsultantModel;
import fambox.pro.model.fragment.FragmentProfileModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.ConsultantRequest;
import fambox.pro.network.model.ConsultantRequestResponse;
import fambox.pro.network.model.OtherConsultantRequest;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.TimeUtil;
import fambox.pro.view.BecomeConsultantContract;
import okhttp3.ResponseBody;
import retrofit2.Response;

public class BecomeConsultantPresenter extends BasePresenter<BecomeConsultantContract.View> implements BecomeConsultantContract.Presenter {
    public static final int CATEGORY_NOT_SELECTED = -1;
    private static final int SELECTED_OTHER_CATEGORY = -2;
    private BecomeConsultantModel mBecomeConsultantModel;
    private FragmentProfileModel mFragmentProfileModel;
    private boolean mIsPending;
    private boolean mIsApproved;
    private boolean mIsDeclined;
    private String mLocale;

    @Override
    public void viewIsReady() {
        mBecomeConsultantModel = new BecomeConsultantModel();
        mFragmentProfileModel = new FragmentProfileModel();
        mLocale = LocaleHelper.getLanguage(getView().getContext());
        getConsultantRequest();
    }

    @Override
    public void sendRequest(String email, String message,
                            String newCategoryName, int categoryId) {
        if (mIsPending) {
            getView().openDialogCancelRequest();
        } else if (mIsApproved) {
            getView().openDialogDeactivateRequest();
        } else if (mIsDeclined) {
            newRequest();
        } else {
            boolean isEmailEmpty = TextUtils.isEmpty(email);
            boolean isMessageEmpty = TextUtils.isEmpty(message);
            boolean isValidEmail = Patterns.EMAIL_ADDRESS.matcher(email).matches();
            if (categoryId == CATEGORY_NOT_SELECTED) {
                getView().showErrorMessage("Pleas select profession category");
            } else if (isMessageEmpty) {
                getView().showErrorMessage("Pleas enter message");
            } else if (isEmailEmpty) {
                getView().showErrorMessage("Pleas enter email");
            } else {
                if (isValidEmail) {
                    sendRequestToServer(email, message, newCategoryName, categoryId);
                } else {
                    getView().showErrorMessage("Enter valid email");
                }
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mBecomeConsultantModel != null) {
            mBecomeConsultantModel.onDestroy();
        }
        if (mFragmentProfileModel != null) {
            mFragmentProfileModel.onDestroy();
        }
    }

    private void sendRequestToServer(String email, String message,
                                     String newCategoryName, int categoryId) {
        getView().showProgress();
        OtherConsultantRequest otherConsultantRequest = new OtherConsultantRequest();
        ConsultantRequest consultantRequest = new ConsultantRequest();
        if (categoryId == SELECTED_OTHER_CATEGORY) {
            otherConsultantRequest.setSuggested_category(newCategoryName);
            otherConsultantRequest.setEmail(email);
            otherConsultantRequest.setMessage(message);
            otherConsultantRequest.setMotivation(message);
        } else {
            consultantRequest.setCategoryId(categoryId);
            consultantRequest.setEmail(email);
            consultantRequest.setMessage(message);
            consultantRequest.setMotivation(message);
        }
        mBecomeConsultantModel.consultantRequest(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(KEY_COUNTRY_CODE, ""),
                LocaleHelper.getLanguage(getView().getContext()), categoryId == SELECTED_OTHER_CATEGORY ? otherConsultantRequest
                        : consultantRequest, new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_CREATED)) {
                            if (getView() != null) {
                                if (response.body() != null) {
                                    if (getView() != null) {
                                        getView().openSuccessRequestDialog();
                                        getView().configRequestPending(true);
                                        getView().configRequestMessages(email, message,
                                                TimeUtil.getCurrentDate(mLocale),
                                                newCategoryName);
                                        getView().configRequestStatus(R.string.pending_approval,
                                                R.string.cancel_request,
                                                R.drawable.icon_pending, TimeUtil.getCurrentDate(SafeYouApp.getLocale()),
                                                TimeUtil.getCurrentDate(mLocale));
                                    }

                                    mIsPending = true;
                                }
                            }
                        }
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    private void getConsultantRequest() {
        getView().showProgress();
        mFragmentProfileModel.getProfile(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(KEY_COUNTRY_CODE, ""), SafeYouApp.getLocale(),
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            ProfileResponse profileResponse = response.body();
                            List<ConsultantRequestResponse> consultantRequestResponse
                                    = null;
                            if (profileResponse != null) {
                                consultantRequestResponse = profileResponse.getConsultantRequest();
                            }
                            if (consultantRequestResponse != null && consultantRequestResponse.size() > 0) {
                                ConsultantRequestResponse consultantRequest = consultantRequestResponse.get(0);
                                if (getView() != null) {
                                    String profession;
                                    if (consultantRequest.getCategory() != null) {
                                        profession = consultantRequest.getCategory().getProfession();
                                    } else {
                                        profession = consultantRequest.getSuggestedCategory();
                                    }
                                    getView().configRequestMessages(consultantRequest.getEmail(),
                                            consultantRequest.getMessage(),
                                            consultantRequest.getUpdatedAt(),
                                            profession);
                                    if (consultantRequest.getStatus() == 0) {
                                        mIsPending = true;
                                        getView().configRequestPending(true);
                                        getView().configRequestStatus(R.string.pending_approval,
                                                R.string.cancel_request,
                                                R.drawable.icon_pending, "",
                                                TimeUtil.getCurrentDate(mLocale));
                                    } else if (consultantRequest.getStatus() == 1) {
                                        mIsApproved = true;
                                        getView().configRequestPending(true);
                                        getView().configRequestStatus(R.string.approved_on_date, R.string.deactivate,
                                                R.drawable.iocn_approved, TimeUtil.convertTime(mLocale,
                                                        consultantRequest.getUpdatedAt()),
                                                TimeUtil.convertSubmissionDate(mLocale, consultantRequest.getCreatedAt()));
                                    } else if (consultantRequest.getStatus() == 2) {
                                        mIsDeclined = true;
                                        getView().configRequestPending(true);
                                        getView().configRequestStatus(R.string.declined_on_date, R.string.new_request,
                                                R.drawable.icon_declined, TimeUtil.convertTime(mLocale,
                                                        consultantRequest.getUpdatedAt()),
                                                TimeUtil.convertSubmissionDate(mLocale, consultantRequest.getCreatedAt()));
                                    } else {
                                        mIsDeclined = false;
                                        mIsPending = false;
                                        mIsApproved = false;
                                        getView().configRequestPending(false);
                                    }
                                }
                            } else {
                                if (getView() != null) {
                                    getView().configRequestPending(false);
                                }
                                mIsDeclined = false;
                                mIsPending = false;
                                mIsApproved = false;
                            }
                        }

                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    @Override
    public void cancelRequest() {
        getView().showProgress();
        mBecomeConsultantModel.cancelConsultantRequest(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(KEY_COUNTRY_CODE, ""),
                LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_CREATED)) {
                            if (getView() != null) {
                                getView().dismissProgress();
                                newRequest();
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    @Override
    public void deactivateRequest() {
        getView().showProgress();
        mBecomeConsultantModel.deactivateConsultantRequest(getView().getContext(),
                SafeYouApp.getPreference().getStringValue(KEY_COUNTRY_CODE, ""),
                LocaleHelper.getLanguage(getView().getContext()),
                new NetworkCallback<Response<ResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_CREATED)) {
                            if (getView() != null) {
                                getView().dismissProgress();
                                newRequest();
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        if (getView() != null) {
                            getView().dismissProgress();
                        }
                    }
                });
    }

    private void newRequest() {
        mIsPending = false;
        mIsApproved = false;
        mIsDeclined = false;
        getView().newRequest();
    }
}
