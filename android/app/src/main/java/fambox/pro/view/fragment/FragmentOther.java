package fambox.pro.view.fragment;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
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
import androidx.fragment.app.FragmentActivity;

import com.bumptech.glide.Glide;

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
import fambox.pro.view.ChooseAppLanguageActivity;
import fambox.pro.view.ChooseCountryActivity;
import fambox.pro.view.DualPinActivity;
import fambox.pro.view.EditProfileActivity;
import fambox.pro.view.HelpActivity;
import fambox.pro.view.LoginWithBackActivity;
import fambox.pro.view.MainActivity;
import fambox.pro.view.SecurityLoginActivity;
import fambox.pro.view.TermsAndConditionsActivity;
import fambox.pro.view.dialog.PinDeleteDialog;

import static fambox.pro.Constants.BASE_URL;
import static fambox.pro.Constants.Key.KEY_CHANGE_LANGUAGE;
import static fambox.pro.Constants.Key.KEY_CHANGE_PIN;
import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;

public class FragmentOther extends BaseFragment implements FragmentOtherContract.View {

    private FragmentOtherPresenter mFragmentOtherPresenter;
    private FragmentActivity mContext;
    private boolean isFirst;

    //    @BindView(R.id.containerCreatePin)
    //    ConstraintLayout containerCreatePin;

    @BindView(R.id.pinSwitchNotification)
    Switch pinSwitchNotification;

    @BindView(R.id.txtCountryName)
    TextView txtCountryName;
    @BindView(R.id.txtLanguageName)
    TextView txtLanguageName;
    @BindView(R.id.iconCountry)
    CircleImageView iconCountry;
    @BindView(R.id.otherLoading)
    LinearLayout otherLoading;

    @Override
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
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

    @OnCheckedChanged(R.id.pinSwitchNotification)
    void onRadioButtonCheckChanged(CompoundButton button, boolean checked) {
        if (button.getId() == R.id.pinSwitchNotification) {
            String countryCode = SafeYouApp.getPreference().getStringValue(KEY_COUNTRY_CODE, "");
            mFragmentOtherPresenter.checkNotificationStatus(checked, countryCode,
                    SafeYouApp.getLocale());
        }
    }

    private void openPinDeleteDialog(boolean checked) {
        boolean withPin =
                SafeYouApp.getPreference(mContext).getBooleanValue(Constants.Key.KEY_WITHOUT_PIN, false);
        if (checked && !withPin) {
            goDualPinWithResult(true);
        } else if (!checked && withPin) {
            PinDeleteDialog pinDeleteDialog = new PinDeleteDialog(mContext, true);
            if (pinDeleteDialog.getWindow() != null) {
                pinDeleteDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            }
            pinDeleteDialog.setSwitchStateListener((canceled) -> {
//                containerCreatePin.setVisibility(canceled ? View.VISIBLE : View.GONE);
//                pinSwitch.setChecked(canceled);
            });
            pinDeleteDialog.show();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1010) {
            if (resultCode == Activity.RESULT_OK) {
//                containerCreatePin.setVisibility(View.VISIBLE);
//                pinSwitch.setChecked(true);
            }
            if (resultCode == Activity.RESULT_CANCELED) {
                //Write your code if there's no result
                if (isFirst) {
//                    containerCreatePin.setVisibility(View.GONE);
//                    pinSwitch.setChecked(false);
                }

            }
        }
    }

    private void goDualPinWithResult(boolean isFirst) {
        this.isFirst = isFirst;
        Intent intent = new Intent(getActivity(), DualPinActivity.class);
        intent.putExtra(KEY_CHANGE_PIN, true);
        startActivityForResult(intent, 1010);
    }

//    @OnClick(R.id.containerConsultant)
//    void onClickConsultant() {
//        nextActivity(getActivity(), BecomeConsultantActivity.class);
//    }

    @OnClick(R.id.containerDualPin)
    void onClickPinEdit() {
        nextActivity(getActivity(), SecurityLoginActivity.class);
//        boolean isPinCodeEnabled = SafeYouApp.getPreference(mContext).getBooleanValue(Constants.Key.KEY_WITHOUT_PIN, false);
//        if (isPinCodeEnabled) {
//            PinDeleteDialog pinDeleteDialog = new PinDeleteDialog(mContext);
//            if (pinDeleteDialog.getWindow() != null) {
//                pinDeleteDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
//            }
//            pinDeleteDialog.setSwitchStateListener((canceled) -> {
//                if (canceled) {
//                    nextActivity(getActivity(), ChangeAppIconActivity.class);
//                }
//            });
//            pinDeleteDialog.show();
//        } else {
//            nextActivity(getActivity(), ChangeAppIconActivity.class);
//        }
    }

    @OnClick(R.id.containerTutorial)
    void clickTutorial() {
        Bundle bundle = new Bundle();
        bundle.putBoolean("is_opened_from_menu", true);
        nextActivity(getActivity(), HelpActivity.class, bundle);
    }

    @OnClick(R.id.containerAboutUs)
    void onClickAboutUs() {
        mFragmentOtherPresenter.clickTermAndCondition();
    }

//    @OnClick(R.id.containerChangePassword)
//    void clickEditPassword() {
//        nextActivity(getActivity(), SettingsChangePassActivity.class);
//    }

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
        ad.setTitle(R.string.log_out);
        ad.setMessage(R.string.do_you_log_out);
        ad.setPositiveButton(R.string.yes, (dialogInterface, i) -> {
            mFragmentOtherPresenter.logout(((MainActivity) mContext).getCountryCode(),
                    ((MainActivity) mContext).getLocale());
        });
        ad.setNegativeButton(R.string.no, (dialogInterface, i) -> dialogInterface.dismiss());
        ad.create().show();
    }

    @Override
    public void logout() {
        nextActivity(mContext, LoginWithBackActivity.class);
        mContext.finish();
    }

    @Override
    public void goTermAndCondition(Bundle bundle) {
        nextActivity(mContext, TermsAndConditionsActivity.class, bundle);
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
    public void configSwitchButton(boolean checked) {
//        pinSwitch.setChecked(!checked);
//        containerCreatePin.setVisibility(!checked ? View.VISIBLE : View.GONE);
    }

    @Override
    public void configNotificationSwitch(boolean checked) {
        pinSwitchNotification.setChecked(checked);
    }
}
