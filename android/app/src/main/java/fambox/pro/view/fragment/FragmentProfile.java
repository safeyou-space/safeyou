package fambox.pro.view.fragment;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
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
import fambox.pro.R;
import fambox.pro.network.model.EmergencyContactsResponse;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.presenter.fragment.FragmentProfilePresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.MainActivity;
import fambox.pro.view.TermsAndConditionsActivity;
import fambox.pro.view.adapter.EmergencyContactAdapter;
import fambox.pro.view.adapter.EmergencyServiceAdapter;

public class FragmentProfile extends BaseFragment implements FragmentProfileContract.View {

    private FragmentProfilePresenter mFragmentProfilePresenter;
    private FragmentActivity mContext;
    private EmergencyContactAdapter mEmergencyContactAdapter;
    private EmergencyServiceAdapter mEmergencyServiceAdapter;
    private ChangeMainPageListener mChangeMainPageListener;

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
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
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
        }
        if (Objects.equals(((MainActivity) mContext).getCountryCode(), "geo")) {
            txtPolice.setText(getResources().getString(R.string.this_is_inform_the_police));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mFragmentProfilePresenter.getContactInPhone(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(),
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
        mFragmentProfilePresenter.getProfile(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale());
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
    void onGenderSelected(boolean checked) {
        mFragmentProfilePresenter.editProfile(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(),
                "check_police", checked ? 1 : 0);
    }

//    @OnClick(R.id.containerAboutUs)
//    void onClickAboutUs() {
//        mFragmentProfilePresenter.clickTermAndCondition();
//    }

    @Override
    public void setUpEmergencyRecView(List<EmergencyContactsResponse> list) {
        mEmergencyContactAdapter = new EmergencyContactAdapter(mContext);
        for (int i = 0; i < list.size(); i++)
            if (list.size() <= 3)
                mEmergencyContactAdapter.addItem(list.get(i), i);

        mEmergencyContactAdapter.setEmergencyContactEditClick((emergencyContactsResponse, position)
                -> mFragmentProfilePresenter.deleteEmergency(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(),
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
        mEmergencyServiceAdapter = new EmergencyServiceAdapter(mContext);
        for (int i = 0; i < list.size(); i++)
            if (list.size() <= 3)
                mEmergencyServiceAdapter.addItem(list.get(i), i);
        mEmergencyServiceAdapter.setEmergencyServiceEditClick((emergencyContactsResponse, position)
                -> mFragmentProfilePresenter.deleteEmergencyService(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(), emergencyContactsResponse));

        mEmergencyServiceAdapter.setEmergencyServiceItemClick((emergencyContactsResponse, position) -> {
            if (mChangeMainPageListener != null) {
                mChangeMainPageListener.onPageChange(3, emergencyContactsResponse.getUser_emergency_service_id(), true);
            }
        });
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewEmergencyServices.setLayoutManager(verticalLayoutManager);
        recViewEmergencyServices.setAdapter(mEmergencyServiceAdapter);
    }

    @Override
    public void goTermAndCondition(Bundle bundle) {
        nextActivity(mContext, TermsAndConditionsActivity.class, bundle);
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
