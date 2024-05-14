package fambox.pro.view.fragment;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_CHANGE_LANGUAGE;
import static fambox.pro.Constants.Key.KEY_IS_DARK_MODE_ENABLED;

import android.annotation.SuppressLint;
import android.app.Activity;
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

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.FragmentActivity;

import com.bumptech.glide.Glide;

import org.jetbrains.annotations.NotNull;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.presenter.fragment.FragmentOtherPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.BecomeConsultantActivity;
import fambox.pro.view.BlockUserActivity;
import fambox.pro.view.ChooseAppLanguageActivity;
import fambox.pro.view.ChooseCountryActivity;
import fambox.pro.view.EditProfileActivity;
import fambox.pro.view.EmergencyContactActivity;
import fambox.pro.view.HelpActivity;
import fambox.pro.view.LegalActivity;
import fambox.pro.view.LoginWithBackActivity;
import fambox.pro.view.MainActivity;
import fambox.pro.view.RecordActivity;
import fambox.pro.view.SecurityLoginActivity;
import fambox.pro.view.SurveyListActivity;
import fambox.pro.view.WebViewActivity;
import fambox.pro.view.dialog.DeleteAccountDialog;

public class FragmentOther extends BaseFragment implements FragmentOtherContract.View {

    private FragmentOtherPresenter mFragmentOtherPresenter;
    private FragmentActivity mContext;
    private FragmentProfile.ChangeMainPageListener mChangeMainPageListener;

    @SuppressLint("UseSwitchCompatOrMaterialCode")
    @BindView(R.id.pinSwitchNotification)
    Switch pinSwitchNotification;
    @SuppressLint("UseSwitchCompatOrMaterialCode")
    @BindView(R.id.switchDarkMode)
    Switch switchDarkMode;

    @BindView(R.id.txtCountryName)
    TextView txtCountryName;
    @BindView(R.id.txtLanguageName)
    TextView txtLanguageName;
    @BindView(R.id.iconCountry)
    CircleImageView iconCountry;
    @BindView(R.id.otherLoading)
    LinearLayout otherLoading;
    @BindView(R.id.becomeConsultantRequest)
    TextView becomeConsultantRequest;
    @BindView(R.id.becomeConsultant)
    TextView becomeConsultant;

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_other, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentOtherPresenter = new FragmentOtherPresenter();
        mFragmentOtherPresenter.attachView(this);
        mFragmentOtherPresenter.viewIsReady();
        if (getActivity() != null) {
            mContext = getActivity();
        }
    }

    @Override
    public void onAttach(@NotNull Context context) {
        super.onAttach(context);
        if (context instanceof FragmentProfile.ChangeMainPageListener) {
            mChangeMainPageListener = (FragmentProfile.ChangeMainPageListener) context;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mFragmentOtherPresenter != null) {
            mFragmentOtherPresenter.getProfile(((BaseActivity) mContext).getCountryCode(),
                    ((BaseActivity) mContext).getLocale());
            mFragmentOtherPresenter.setUpLanguage(((BaseActivity) mContext).getCountryCode(),
                    ((BaseActivity) mContext).getLocale());
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentOtherPresenter != null) {
            mFragmentOtherPresenter.detachView();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mFragmentOtherPresenter != null) {
            mFragmentOtherPresenter.destroy();
        }
    }

    @OnCheckedChanged(R.id.switchDarkMode)
    void onDarkModeChanged(CompoundButton button, boolean checked) {
        if (button.getId() == R.id.switchDarkMode) {
            SafeYouApp.getPreference().setValue(KEY_IS_DARK_MODE_ENABLED, checked);
            if (checked) {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
            } else {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);

            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK && requestCode == 1212) {
            if (data != null) {
                mChangeMainPageListener.onPageChange(data.getIntExtra("page", 1),
                        data.getLongExtra("serviceId", 0), data.getBooleanExtra("isSendSms", false));
            }
        }
    }

    @OnClick(R.id.containerRecords)
    void onClickRecList() {
        nextActivity(getActivity(), RecordActivity.class);
    }

    @OnClick(R.id.containerEmergencyContacts)
    void onClickEmergencyContact() {
        nextActivity(getActivity(), EmergencyContactActivity.class, 1212);
    }
    @OnClick(R.id.containerOpenSurveys)
    void onClickOpenSurveys() {
        nextActivity(getActivity(), SurveyListActivity.class);
    }

    @OnClick(R.id.containerConsultant)
    void onClickConsultant() {
        nextActivity(getActivity(), BecomeConsultantActivity.class);
    }

    @OnClick(R.id.containerLegal)
    void onClickLegal() {
        nextActivity(getActivity(), LegalActivity.class);
    }

    @OnClick(R.id.containerDualPin)
    void onClickPinEdit() {
        nextActivity(getActivity(), SecurityLoginActivity.class);
    }

    @OnClick(R.id.containerBlockUser)
    void onClickBlockUser() {
        nextActivity(getActivity(), BlockUserActivity.class);
    }

    @OnClick(R.id.containerTutorial)
    void clickTutorial() {
        Bundle bundle = new Bundle();
        bundle.putBoolean("is_opened_from_menu", true);
        nextActivity(getActivity(), HelpActivity.class, bundle);
    }

    @OnClick(R.id.containerAboutUs)
    void onClickAboutUs() {
        mFragmentOtherPresenter.clickAboutUs();
    }

    @OnClick(R.id.containerChangeLanguage)
    void onClickChangeLanguage() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(KEY_CHANGE_LANGUAGE, true);
        nextActivity(mContext, ChooseAppLanguageActivity.class, bundle);
    }

    @OnClick(R.id.containerChangeCountry)
    void clickChangeCountry() {
        Bundle bundle = new Bundle();
        bundle.putBoolean(Constants.Key.KEY_CHANGE_COUNTRY, true);
        nextActivity(getActivity(), ChooseCountryActivity.class, bundle);
    }

    @OnClick(R.id.containerEditProfile)
    void onClickEditProfile() {
        nextActivity(getActivity(), EditProfileActivity.class);
    }

    @Override
    public void configConsultantRequest(int status) {
        String text;
        int visibility;
        if (status == 0) {
            text = getString(R.string.pending);
            visibility = View.VISIBLE;
        } else if (status == 1) {
            text = getString(R.string.approved);
            visibility = View.VISIBLE;
        } else if (status == 2) {
            text = getString(R.string.declined);
            visibility = View.VISIBLE;
        } else {
            text = getString(R.string.become_consultant_title);
            visibility = View.GONE;
        }
        becomeConsultant.setVisibility(visibility);
        becomeConsultantRequest.setText(text);
    }

    @Override
    public void setCountry(String countryName, String imageUrl) {
        txtCountryName.setText(countryName);
        if (imageUrl != null) {
            Glide.with(mContext).load(BASE_URL.concat(imageUrl.replaceAll("\"", "")))
                    .into(iconCountry);
        }
    }

    @Override
    public void setLanguage(String text) {
        txtLanguageName.setText(text);
    }

    @OnClick(R.id.containerLogOut)
    void onClickLogout() {
        AlertDialog.Builder ad = new AlertDialog.Builder(mContext);
        ad.setTitle(getString(R.string.log_out_title_key));
        ad.setMessage(getString(R.string.want_logout_text_key));
        ad.setPositiveButton(getString(R.string.yes), (dialogInterface, i) ->
                mFragmentOtherPresenter.logout(((MainActivity) mContext).getCountryCode(),
                        ((MainActivity) mContext).getLocale()));
        ad.setNegativeButton(getString(R.string.no), (dialogInterface, i) -> dialogInterface.dismiss());
        ad.create().show();
    }

    @OnClick(R.id.containerDeleteAccount)
    void onDeleteAccount() {
        if (getContext() == null) {
            return;
        }
        DeleteAccountDialog securityQuestionDialog = new DeleteAccountDialog(getContext());
        securityQuestionDialog.setDialogClickListener((dialog, which) -> {
            switch (which) {
                case DeleteAccountDialog.CLICK_CLOSE:
                case DeleteAccountDialog.CLICK_CANCEL:
                    dialog.dismiss();
                    break;
                case DeleteAccountDialog.CLICK_DELETE:
                    mFragmentOtherPresenter.deleteAccount(((MainActivity) mContext).getCountryCode(),
                            ((MainActivity) mContext).getLocale());
                    dialog.dismiss();
                    break;
            }
        });
        securityQuestionDialog.show();
    }

    @Override
    public void logout() {
        nextActivity(mContext, LoginWithBackActivity.class);
        mContext.finish();
    }

    @Override
    public void goWebViewActivity(Bundle bundle) {
        nextActivity(mContext, WebViewActivity.class, bundle);
    }

    @Override
    public Context getAppContext() {
        return mContext.getApplicationContext();
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
        otherLoading.setVisibility(View.VISIBLE);
    }

    @Override
    public void dismissProgress() {
        otherLoading.setVisibility(View.GONE);
    }

    @Override
    public void configDarkModeSwitch(boolean checked) {
        switchDarkMode.setChecked(checked);
    }
}
