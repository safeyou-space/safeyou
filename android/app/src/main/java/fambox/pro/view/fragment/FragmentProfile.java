package fambox.pro.view.fragment;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.Switch;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.nabinbhandari.android.permissions.PermissionHandler;
import com.nabinbhandari.android.permissions.Permissions;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.presenter.fragment.FragmentProfilePresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.WebViewActivity;
import fambox.pro.view.adapter.EmergencyContactAdapter;
import fambox.pro.view.adapter.EmergencyServiceAdapter;
import fambox.pro.view.dialog.EnablePoliceDialog;

public class FragmentProfile extends BaseFragment implements FragmentProfileContract.View {

    private FragmentProfilePresenter mFragmentProfilePresenter;
    private FragmentActivity mContext;
    private ChangeMainPageListener mChangeMainPageListener;
    private String countryCode = "arm";
    private String language = "en";

    @BindView(R.id.txtPolice)
    TextView txtPolice;
    @BindView(R.id.txtMassage)
    TextView txtMassage;
    @BindView(R.id.policeSwitch)
    Switch policeSwitch;
    @BindView(R.id.recViewMyContacts)
    RecyclerView recViewMyContacts;
    @BindView(R.id.recViewEmergencyServices)
    RecyclerView recViewEmergencyServices;
    @BindView(R.id.profileLoading)
    LinearLayout profileLoading;

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_profile, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentProfilePresenter = new FragmentProfilePresenter();
        mFragmentProfilePresenter.attachView(this);
        mFragmentProfilePresenter.viewIsReady();
        if (getActivity() != null) {
            mContext = getActivity();
            countryCode = SafeYouApp.getPreference(mContext)
                    .getStringValue(KEY_COUNTRY_CODE, "arm");
        }
        language = LocaleHelper.getLanguage(getContext());
        if (Objects.equals(countryCode, "geo")) {
            txtPolice.setText(getResources().getString(R.string.this_is_inform_the_police));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mFragmentProfilePresenter.getContactInPhone(countryCode, LocaleHelper.getLanguage(getContext()),
                requestCode, resultCode, data);
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof ChangeMainPageListener) {
            mChangeMainPageListener = (ChangeMainPageListener) context;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mFragmentProfilePresenter.getProfile(countryCode, language);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentProfilePresenter != null) {
            mFragmentProfilePresenter.detachView();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mFragmentProfilePresenter != null) {
            mFragmentProfilePresenter.destroy();
        }
    }

    @OnCheckedChanged(R.id.policeSwitch)
    void onGenderSelected(CompoundButton buttonView, boolean checked) {
        if (buttonView.isPressed()) {
            if (!Connectivity.isConnected(mContext)) {
                buttonView.setChecked(!checked);
                showErrorMessage(getResources().getString(R.string.check_internet_connection_text_key));
                return;
            }
        }

        boolean checkedFromUser = buttonView.isPressed() && checked;
        if (Objects.equals(SafeYouApp.getPreference(mContext)
                .getStringValue(KEY_COUNTRY_CODE, ""), "geo")) {
            mFragmentProfilePresenter.editProfile(countryCode,
                    LocaleHelper.getLanguage(getContext()),
                    "check_police", checked ? 1 : 0);
            return;
        }

        mFragmentProfilePresenter.getPolice(buttonView, checked, checkedFromUser);
        if (buttonView.isPressed() && !checked) {
            mFragmentProfilePresenter.editProfile(countryCode,
                    LocaleHelper.getLanguage(getContext()),
                    "check_police", 0);
        }
    }

    @Override
    public void configCheckPoliceSwitch(CompoundButton buttonView, boolean checked,
                                        boolean checkedFromUser, String title, String description) {
        if (checkedFromUser) {
            EnablePoliceDialog enablePoliceDialog = new EnablePoliceDialog(mContext, title, description);
            enablePoliceDialog.setDialogClickListener((dialog, which) -> {
                switch (which) {
                    case EnablePoliceDialog.ENABLE:
                        mFragmentProfilePresenter.editProfile(countryCode,
                                LocaleHelper.getLanguage(getContext()),
                                "check_police", 1);
                        dialog.dismiss();
                        break;
                    case EnablePoliceDialog.DISABLE:
                        mFragmentProfilePresenter.editProfile(countryCode,
                                LocaleHelper.getLanguage(getContext()),
                                "check_police", 0);
                        policeSwitch.setChecked(false);
                        dialog.dismiss();
                        break;
                }
            });
            enablePoliceDialog.show();
        }
    }

    @Override
    public void setUpEmergencyRecView(List<EmergencyContactsResponse> list) {
        EmergencyContactAdapter mEmergencyContactAdapter = new EmergencyContactAdapter(mContext);
        for (int i = 0; i < list.size(); i++)
            if (list.size() <= 3)
                mEmergencyContactAdapter.addItem(list.get(i), i);

        mEmergencyContactAdapter.setEmergencyContactEditClick((emergencyContactsResponse, position)
                -> mFragmentProfilePresenter.deleteEmergency(countryCode, LocaleHelper.getLanguage(getContext()),
                emergencyContactsResponse.getId()));

        mEmergencyContactAdapter.setEmergencyContactItemClick((emergencyContactsResponse, position) ->
                Permissions.check(mContext,
                        Manifest.permission.READ_CONTACTS,
                        null, new PermissionHandler() {
                            @Override
                            public void onGranted() {

                                mFragmentProfilePresenter.onPickContact(emergencyContactsResponse);
                            }

                            @Override
                            public void onDenied(Context context, ArrayList<String> deniedPermissions) {

                            }
                        }));
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewMyContacts.setLayoutManager(verticalLayoutManager);
        recViewMyContacts.setAdapter(mEmergencyContactAdapter);
    }

    @Override
    public void setUpServiceRecView(List<ServicesResponseBody> list) {
        EmergencyServiceAdapter mEmergencyServiceAdapter = new EmergencyServiceAdapter(mContext);
        for (int i = 0; i < list.size(); i++)
            if (list.size() <= 3)
                mEmergencyServiceAdapter.addItem(list.get(i), i);
        mEmergencyServiceAdapter.setEmergencyServiceEditClick((emergencyContactsResponse, position)
                -> mFragmentProfilePresenter.deleteEmergencyService(countryCode, LocaleHelper.getLanguage(getContext()), emergencyContactsResponse));

        mEmergencyServiceAdapter.setEmergencyServiceItemClick((emergencyContactsResponse, position) -> {
            if (mChangeMainPageListener != null) {
                mChangeMainPageListener.onPageChange(1, emergencyContactsResponse.getUser_emergency_service_id(), true);
            }
        });
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewEmergencyServices.setLayoutManager(verticalLayoutManager);
        recViewEmergencyServices.setAdapter(mEmergencyServiceAdapter);
    }

    @Override
    public void pickContact(Intent data, int requestCode) {
        startActivityForResult(data, requestCode);
    }

    @Override
    public void setEmergencyMessage(String message) {
        txtMassage.setText(message);
    }

    @Override
    public void setPoliceCheck(boolean isCheck) {
        policeSwitch.setChecked(isCheck);
    }


    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @Override
    public void showProgress() {
        profileLoading.setVisibility(View.VISIBLE);
    }

    @Override
    public void dismissProgress() {
        profileLoading.setVisibility(View.GONE);
    }

    public interface ChangeMainPageListener {
        void onPageChange(int page, long serviceId, boolean isSendSms);
    }
}
