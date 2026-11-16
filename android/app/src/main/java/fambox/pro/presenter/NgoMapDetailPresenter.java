package fambox.pro.presenter;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_SERVICE_ID;

import android.os.Bundle;
import android.view.View;

import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.List;

import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.model.AddToHelplineModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.SocialMediaBody;
import fambox.pro.network.model.IconsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.SocialLinks;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.NgoMapDetailContract;
import retrofit2.Response;

public class NgoMapDetailPresenter extends BasePresenter<NgoMapDetailContract.View>
        implements NgoMapDetailContract.Presenter {

    private ServicesResponseBody mServicesResponseBody;
    private AddToHelplineModel mAddToHelplineModel;
    private boolean add = false;
    private boolean isAddedFromProfile = false;
    private long serviceId;
    private long oldServiceId;
    private String countryCode;

    @Override
    public void viewIsReady() {
        mAddToHelplineModel = new AddToHelplineModel();
    }

    @Override
    public void initBundle(Bundle bundle, String countryCode, String locale) {
        if (bundle != null) {
            isAddedFromProfile = bundle.getBoolean("is_added_from_profile", false);
            oldServiceId = bundle.getLong("service_old_id");
            serviceId = bundle.getLong(KEY_SERVICE_ID);
            this.countryCode = countryCode;
            getServiceByServiceId(serviceId);
        }
    }

    @Override
    public void getServiceByServiceId(long serviceId) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        mAddToHelplineModel.getServiceByServiceId(getView().getContext(), countryCode, LocaleHelper.getLanguage(getView().getContext()), this.serviceId,
                new NetworkCallback<Response<ServicesResponseBody>>() {
                    @Override
                    public void onSuccess(Response<ServicesResponseBody> response) {
                        if (RetrofitUtil.isResponseSuccess(response, HttpURLConnection.HTTP_OK)) {
                            if (response.body() != null) {

                                List<SocialMediaBody> socialMediaBodyList = new ArrayList<>();

                                if (response.body().getDescription() != null) {
                                    SocialMediaBody socialMediaBodyInfo = new SocialMediaBody();
                                    socialMediaBodyInfo.setName(getView().getContext().getResources().getString(R.string.info));
                                    socialMediaBodyInfo.setSocialMediaTitle(response.body().getDescription());
                                    socialMediaBodyInfo.setHtml(true);
                                    socialMediaBodyInfo.setSocialMediaIconPath(response.body().getIcons().getInfo());
                                    socialMediaBodyList.add(socialMediaBodyInfo);
                                }

                                if (response.body().getAddress() != null) {
                                    SocialMediaBody socialMediaBodyAddress = new SocialMediaBody();
                                    socialMediaBodyAddress.setName(getView().getContext().getResources().getString(R.string.address));
                                    socialMediaBodyAddress.setSocialMediaTitle(response.body().getAddress());
                                    socialMediaBodyAddress.setSocialMediaIconPath(response.body().getIcons().getAddress());
                                    socialMediaBodyList.add(socialMediaBodyAddress);
                                }

                                if (response.body().getPhone() != null) {
                                    SocialMediaBody socialMediaBodyPhone = new SocialMediaBody();
                                    socialMediaBodyPhone.setName(getView().getContext().getResources().getString(R.string.mobile_text_key));
                                    socialMediaBodyPhone.setSocialMediaTitle(response.body().getPhone());
                                    socialMediaBodyPhone.setSocialMediaIconPath(response.body().getIcons().getPhone());
                                    socialMediaBodyList.add(socialMediaBodyPhone);
                                }
                                if (response.body().getEmail() != null) {
                                    SocialMediaBody socialMediaBodyEmail = new SocialMediaBody();
                                    socialMediaBodyEmail.setName(getView().getContext().getResources().getString(R.string.email_text_key));
                                    socialMediaBodyEmail.setSocialMediaTitle(response.body().getEmail());
                                    socialMediaBodyEmail.setSocialMediaIconPath(response.body().getIcons().getEmail());
                                    socialMediaBodyList.add(socialMediaBodyEmail);
                                }
                                if (response.body().getWeb_address() != null) {
                                    SocialMediaBody socialMediaBodyWebAddress = new SocialMediaBody();
                                    socialMediaBodyWebAddress.setName(getView().getContext().getResources().getString(R.string.web_address_text_key));
                                    socialMediaBodyWebAddress.setSocialMediaTitle(response.body().getWeb_address());
                                    socialMediaBodyWebAddress.setSocialMediaIconPath(response.body().getIcons().getWeb_address());
                                    socialMediaBodyList.add(socialMediaBodyWebAddress);
                                }
                                if (response.body().getSocialLinks() != null) {
                                    for (SocialLinks i : response.body().getSocialLinks()) {
                                        SocialMediaBody socialMediaBodySocialList = new SocialMediaBody();
                                        socialMediaBodySocialList.setName(i.getName());
                                        socialMediaBodySocialList.setSocialMediaTitle(i.getTitle());
                                        socialMediaBodySocialList.setSocialMediaLink(i.getUrl());
                                        socialMediaBodySocialList.setSocialMediaIconPath(getImagePath(i.getIcon(),
                                                response.body().getIcons()));
                                        socialMediaBodyList.add(socialMediaBodySocialList);
                                    }
                                }

                                onMapReady(response.body());
                                String imagePath = BASE_URL.concat(response.body().getUser_detail().getImage().getUrl());

                                getView().configUserData(getConcatedFulName(response.body()),
                                        response.body().getUser_detail().getLocation(), socialMediaBodyList, imagePath,
                                        response.body().getUserRate(), response.body().getRatesCount(), serviceId);

                                configDetailActivity(response.body());
                                getView().configAddToHelplineButtonVisibility(response.body().getIs_send_sms() == 0 ? View.GONE : View.VISIBLE);
                                if (response.body().getUser_service() != null) {
                                    configAddToHelplineButton(response.body().getUser_service().size() != 0
                                            && response.body().getIs_send_sms() != 0);
                                }
                            }
                        } else {
                            getView().showErrorMessage(getView().getContext().getString(R.string.detail_not_ready));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {

                    }
                });
    }

    @Override
    public void addToHelpline(String countryCode, String locale) {
        mAddToHelplineModel.addEmergencyService(getView().getContext(), countryCode, locale, serviceId,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        addEditHelpline(response);
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage("error");
                    }
                });
    }

    @Override
    public void editHelpline(String countryCode, String locale, long oldId) {
        mAddToHelplineModel.editEmergencyService(getView().getContext(), countryCode, locale, oldId, serviceId,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        addEditHelpline(response);
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage("error");
                    }
                });
    }

    @Override
    public void deleteFromHelpline(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext().getResources().getString(R.string.check_internet_connection_text_key));
            return;
        }
        if (mServicesResponseBody.getUser_service() != null && mServicesResponseBody.getUser_service().size() >= 1) {
            mAddToHelplineModel.deleteEmergencyService(getView().getContext(), countryCode, locale,
                    mServicesResponseBody.getUser_service().get(0).getUser_service_id(),
                    new NetworkCallback<Response<Message>>() {
                        @Override
                        public void onSuccess(Response<Message> response) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (isAddedFromProfile) {
                                    getView().goToProfile();
                                } else {
                                    if (response.body() != null) {
                                        getView().showSuccessMessage(response.body().getMessage());
                                    }
                                    configAddToHelplineButton(false);
                                    getServiceByServiceId(serviceId);
                                }
                            }
                        }

                        @Override
                        public void onError(Throwable error) {
                            getView().showErrorMessage(error.getMessage());
                        }
                    });
        }
    }

    @Override
    public void configDetailActivity(ServicesResponseBody servicesResponseBody) {
        if (servicesResponseBody != null) {
            mServicesResponseBody = servicesResponseBody;
        } else {
            getView().showErrorMessage(getView().getContext().getString(R.string.detail_not_ready));
        }
    }

    @Override
    public void onMapReady(ServicesResponseBody servicesResponseBody) {
        if (servicesResponseBody != null) {
            getView().configMapPosition(getConcatedFulName(servicesResponseBody),
                    servicesResponseBody.getUser_detail().getLocation(),
                    Utils.convertStringToDuple(servicesResponseBody.getLatitude()),
                    Utils.convertStringToDuple(servicesResponseBody.getLongitude()));
        } else {
            getView().showErrorMessage(getView().getContext().getString(R.string.map_detail_not_ready));
        }
    }

    @Override
    public void navigateAddOrDeleteService(String countryCode, String locale) {
        if (add) {
            deleteFromHelpline(countryCode, locale);
        } else {
            if (oldServiceId == 0) {
                addToHelpline(countryCode, locale);
            } else {
                editHelpline(countryCode, locale, oldServiceId);
            }
        }
    }

    private String getConcatedFulName(ServicesResponseBody servicesResponseBody) {
        return servicesResponseBody.getTitle();
    }

    @Override
    public void configAddToHelplineButton(boolean added) {
        add = added;
        String btnText = added ? getView().getContext().getResources().getString(R.string.remove_from_helpline_title_key)
                : getView().getContext().getResources().getString(R.string.add_to_helpline_title_key);
        int color = added ? getView().getContext().getResources().getColor(R.color.red)
                : getView().getContext().getResources().getColor(R.color.white);
        getView().configHelplineButton(btnText, color);
    }


    private void addEditHelpline(Response<Message> response) {
        if (response.code() == HttpURLConnection.HTTP_OK) {
            if (isAddedFromProfile) {
                getView().goToProfile();
            } else {
                if (response.body() != null) {
                    getView().showSuccessMessage(response.body().getMessage());
                }
                configAddToHelplineButton(true);
                getServiceByServiceId(serviceId);
            }
        }
    }

    @Override
    public void goToPrivateMessage() {
        Bundle bundle = new Bundle();
        if (mServicesResponseBody == null) {
            getView().goToPrivateChat(bundle);
            return;
        }
        bundle.putBoolean("opened_from_network", true);
        bundle.putString("user_id", mServicesResponseBody.getUser_id());
        bundle.putString("user_name", mServicesResponseBody.getTitle());
        bundle.putString("user_image", mServicesResponseBody.getUser_detail().getImage().getUrl());
        bundle.putString("user_profession", mServicesResponseBody.getCategory());
        getView().goToPrivateChat(bundle);
    }

    private String getImagePath(String key, IconsResponse icons) {
        if (icons != null) {
            switch (key) {
                case "facebook":
                    return icons.getFacebook();
                case "instagram":
                    return icons.getInstagram();
                case "address":
                    return icons.getAddress();
                case "phone":
                    return icons.getPhone();
                case "email":
                    return icons.getEmail();
                case "web_address":
                    return icons.getWeb_address();
                case "info":
                    return icons.getInfo();
                default:
                    return "";
            }
        }
        return "";
    }
}
