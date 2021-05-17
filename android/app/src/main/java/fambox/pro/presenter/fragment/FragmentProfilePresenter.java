package fambox.pro.presenter.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import androidx.fragment.app.FragmentActivity;

import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import fambox.pro.R;
import fambox.pro.model.AddToHelplineModel;
import fambox.pro.model.fragment.FragmentOtherModel;
import fambox.pro.model.fragment.FragmentProfileModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.EmergencyContactBody;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.ProfileResponse;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.presenter.basepresenter.BasePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.RetrofitUtil;
import fambox.pro.utils.Utils;
import fambox.pro.view.fragment.FragmentProfileContract;
import io.michaelrocks.libphonenumber.android.NumberParseException;
import io.michaelrocks.libphonenumber.android.PhoneNumberUtil;
import io.michaelrocks.libphonenumber.android.Phonenumber;
import retrofit2.Response;

import static android.app.Activity.RESULT_OK;
import static fambox.pro.Constants.Key.KEY_IS_TERM;

public class FragmentProfilePresenter extends BasePresenter<FragmentProfileContract.View> implements
        FragmentProfileContract.Presenter {

    private static final int REQUEST_CODE = 111;
    private FragmentProfileModel mFragmentProfileModel;
    private FragmentOtherModel mFragmentOtherModel;
    private boolean isEditable;
    private long emergencyId;
    private AddToHelplineModel mAddToHelplineModel;
    private boolean isTextChanged = false;

    @Override
    public void viewIsReady() {
        mFragmentProfileModel = new FragmentProfileModel();
        mAddToHelplineModel = new AddToHelplineModel();
        mFragmentOtherModel = new FragmentOtherModel();
    }

    @Override
    public void clickTermAndCondition() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_IS_TERM, false);
        getView().goTermAndCondition(bundle);
    }

    @Override
    public void getProfile(String countryCode, String locale) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        getView().showProgress();
        mFragmentProfileModel.getProfile(getView().getContext(), countryCode, locale,
                new NetworkCallback<Response<ProfileResponse>>() {
                    @Override
                    public void onSuccess(Response<ProfileResponse> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                if (response.body() != null) {
                                    getView().setUpServiceRecView(response.body().getEmergencyServices());
//                                     set Emergency Service
                                    getView().setUpEmergencyRecView(response.body().getEmergency_contacts());
//                                     set Emergency Message
                                    getView().setEmergencyMessage(response.body().getHelp_message().getTranslation());
                                    if (response.body().getCheck_police() == 0) {
                                        getView().setPoliceCheck(false);
                                    } else {
                                        getView().setPoliceCheck(true);
                                    }
                                    getView().dismissProgress();
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void editProfile(String countryCode, String locale, String key, int value) {
        getView().showProgress();
        mFragmentProfileModel.editProfileServer(getView().getContext(), countryCode, locale, key, value,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                getProfile(countryCode, locale);
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                        getView().dismissProgress();
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void addEmergency(String countryCode, String locale, String name, String number) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        EmergencyContactBody emergencyContactBody = new EmergencyContactBody();
        emergencyContactBody.setName(name);
        emergencyContactBody.setPhone(number);
        mFragmentProfileModel.addEmergencyContact(getView().getContext(), countryCode, locale, emergencyContactBody,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                getProfile(countryCode, locale);
                            }
                        } else {
                            if (response.code() == HttpURLConnection.HTTP_BAD_REQUEST) {
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
    public void editEmergency(String countryCode, String locale, long id, String name, String number) {
        EmergencyContactBody emergencyContactBody = new EmergencyContactBody();
        emergencyContactBody.setName(name);
        emergencyContactBody.setPhone(number);
        mFragmentProfileModel.editEmergencyContact(getView().getContext(), countryCode, locale, id, emergencyContactBody,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                getProfile(countryCode, locale);
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void deleteEmergency(String countryCode, String locale, long id) {
        mFragmentProfileModel.deleteEmergencyContact(getView().getContext(), countryCode, locale, id,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_OK) {
                                getProfile(countryCode, locale);
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void getContactInPhone(String countryCode, String locale, int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                if (data != null) {
                    Uri uri = data.getData();
                    String[] projection = {ContactsContract.CommonDataKinds.Phone.NUMBER,
                            ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME};

                    Cursor cursor = null;
                    if (uri != null) {
                        cursor = getView().getContext().getContentResolver().query(uri, projection,
                                null, null, null);
                    }
                    if (cursor != null) {
                        cursor.moveToFirst();
                        int numberColumnIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER);
                        String number = cursor.getString(numberColumnIndex);

                        int nameColumnIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME);
                        String name = cursor.getString(nameColumnIndex);


                        PhoneNumberUtil util = PhoneNumberUtil.createInstance(getView().getContext());

                        try {
                            Phonenumber.PhoneNumber phoneNumber =
                                    util.parse(number, Objects.equals(countryCode, "arm") ? "AM" : "GE");
                            String validatePhoneNumber = util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164);
                            // server request...
                            if (isEditable) {
                                addEmergency(countryCode, locale, name, validatePhoneNumber);
                            } else {
                                editEmergency(countryCode, locale, emergencyId, name, validatePhoneNumber);
                            }
                        } catch (NumberParseException e) {
                            e.printStackTrace();
                        }
                        cursor.close();
                    }
                }
            }
        }
    }

    @SuppressLint("IntentReset")
    @Override
    public void onPickContact(EmergencyContactsResponse emergencyContactsResponse) {
        Uri uri = Uri.parse("content://contacts");
        Intent intent = new Intent(Intent.ACTION_PICK, uri);
        intent.setType(ContactsContract.CommonDataKinds.Phone.CONTENT_TYPE);
        isEditable = emergencyContactsResponse.getId() == 0;
        if (!isEditable) {
            emergencyId = emergencyContactsResponse.getId();
        }
        getView().pickContact(intent, REQUEST_CODE);
    }

    @Override
    public void deleteEmergencyService(String countryCode, String locale, ServicesResponseBody servicesResponseBody) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }
        mAddToHelplineModel.deleteEmergencyService(getView().getContext(), countryCode, locale,
                servicesResponseBody.getUser_emergency_service_id(),
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.body() != null) {
                                if (response.code() == HttpURLConnection.HTTP_OK) {
                                    getView().showSuccessMessage(response.body().getMessage());
                                    getProfile(countryCode, locale);
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                    }
                });
    }

    @Override
    public void configEditText(String countryCode, String locale, FragmentActivity context, EditText editText,
                               boolean isChecked) {
        editText.setEnabled(isChecked);
        editText.requestFocus();
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (isChecked) {
            if (imm != null) imm.showSoftInput(editText, InputMethodManager.SHOW_IMPLICIT);
        } else {
            if (imm != null) imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
        }
        if (editText.getText() != null) {
            editText.setSelection(editText.getText().length());
        }
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                isTextChanged = true;
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                isTextChanged = true;
            }

            @Override
            public void afterTextChanged(Editable s) {
                isTextChanged = true;
            }
        });

        if (!isChecked && isTextChanged) {
            editProfile(countryCode, locale, Utils.getEditableToString(editText.getText()));
        }
        isTextChanged = false;
    }

    private void editProfile(String countryCode, String locale, String value) {
        if (!Connectivity.isConnected(getView().getContext())) {
            getView().showErrorMessage(getView().getContext()
                    .getResources().getString(R.string.internet_connection));
            return;
        }

        getView().showProgress();
        mFragmentOtherModel.editProfile(getView().getContext(), countryCode, locale, "emergency_message", value,
                new NetworkCallback<Response<Message>>() {
                    @Override
                    public void onSuccess(Response<Message> response) {
                        if (response.isSuccessful()) {
                            if (response.code() == HttpURLConnection.HTTP_CREATED) {
                                if (response.body() != null) {
                                    getProfile(countryCode, locale);
                                }
                            }
                        } else {
                            getView().showErrorMessage(RetrofitUtil.getErrorMessage(response.errorBody()));
                            getView().dismissProgress();
                        }
                    }

                    @Override
                    public void onError(Throwable error) {
                        getView().showErrorMessage(error.getMessage());
                        getView().dismissProgress();
                    }
                });
    }

    @Override
    public void destroy() {
        super.destroy();
        if (mFragmentProfileModel != null) {
            mFragmentProfileModel.onDestroy();
        }
        getView().dismissProgress();
    }
}
