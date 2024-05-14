package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_IS_TERM;
import static fambox.pro.Constants.Key.KEY_REGISTRATION_FORM;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.hbb20.CountryCodePicker;
import com.tsongkha.spinnerdatepicker.SpinnerDatePickerDialogBuilder;

import java.util.Calendar;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.RegistrationBody;
import fambox.pro.presenter.RegistrationPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.TimeUtil;
import fambox.pro.utils.Utils;

public class RegistrationActivity extends BaseActivity implements RegistrationContract.View {

    private RegistrationPresenter mRegistrationPresenter;
    private int marred = -10;
    private String countryCode;

    @BindView(R.id.edtFirstName)
    TextInputEditText edtFirstName;
    @BindView(R.id.edtLastName)
    TextInputEditText edtLastName;
    @BindView(R.id.edtNickname)
    TextInputEditText edtNickname;
    @BindView(R.id.txtInputLayoutDateOfBirth)
    TextInputLayout txtInputLayoutDateOfBirth;
    @BindView(R.id.txtInputLayoutMobile)
    TextInputLayout txtInputLayoutMobile;
    @BindView(R.id.txtInputLayoutNickname)
    TextInputLayout txtInputLayoutNickname;
    @BindView(R.id.txtInputTextConfirmPass)
    TextInputLayout txtInputTextConfirmPass;
    @BindView(R.id.txtInputTextPass)
    TextInputLayout txtInputTextPass;
    @BindView(R.id.edtDateOfBirth)
    TextInputEditText edtDateOfBirth;
    @BindView(R.id.edtMobile)
    TextInputEditText edtMobile;
    @BindView(R.id.edtMarital)
    TextInputEditText edtMarital;
    @BindView(R.id.edtPass)
    TextInputEditText edtPass;
    @BindView(R.id.edtConfirmPass)
    TextInputEditText edtConfirmPass;
    @BindView(R.id.countryPicker)
    CountryCodePicker countryPicker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        ButterKnife.bind(this);
        mRegistrationPresenter = new RegistrationPresenter();
        mRegistrationPresenter.attachView(this);
        mRegistrationPresenter.viewIsReady();
        addAppBar(null, true, true,
                false, null, false);
        int maxPhoneNumber = 9;
        switch (getCountryCode()) {
            case "geo":
                countryCode = "GE";
                maxPhoneNumber = 10;
                break;
            case "arm":
                countryCode = "AM";
                maxPhoneNumber = 8;
                break;
            case "irq":
                countryCode = "IQ";
                maxPhoneNumber = 10;
                break;
            case "zwe":
                countryCode = "ZW";
                maxPhoneNumber = 9;
                break;
        }

        countryPicker.setCcpClickable(false);
        countryPicker.setCountryForNameCode(countryCode);
        countryPicker.showArrow(false);

        txtInputLayoutDateOfBirth.setHint(String.format(Locale.getDefault(), "%s %s", txtInputLayoutDateOfBirth.getHint(), "*"));
        txtInputLayoutMobile.setHint(String.format(Locale.getDefault(), "%s %s", txtInputLayoutMobile.getHint(), "*"));
        txtInputTextConfirmPass.setHint(String.format(Locale.getDefault(), "%s %s", txtInputTextConfirmPass.getHint(), "*"));
        txtInputTextPass.setHint(String.format(Locale.getDefault(), "%s %s", txtInputTextPass.getHint(), "*"));
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_registration;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mRegistrationPresenter != null) {
            mRegistrationPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mRegistrationPresenter != null) {
            mRegistrationPresenter.destroy();
        }
    }

    @OnClick(R.id.edtMarital)
    void maritalClick() {
        Intent i = new Intent(this, MaritalStatusActivity.class);
        Bundle bundle = new Bundle();
        bundle.putBoolean("registration_key", true);
        bundle.putInt("registration_marital_position", marred);
        i.putExtras(bundle);
        startActivityForResult(i, 22);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 22) {
            if (resultCode == Activity.RESULT_OK) {
                marred = data.getIntExtra("marital_result", -1);
                edtMarital.setText(data.getStringExtra("marital_label"));
            }
        }
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    @OnClick(R.id.edtDateOfBirth)
    void onClickDate() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.YEAR, -12);

        new SpinnerDatePickerDialogBuilder()
                .context(RegistrationActivity.this)
                .spinnerTheme(R.style.NumberPickerStyle)
                .callback((view, year, monthOfYear, dayOfMonth) -> {
                    String stringBuilder = dayOfMonth + "/" + (monthOfYear + 1) + "/" + year;
                    edtDateOfBirth.setText(TimeUtil.convertDate(stringBuilder));
                })
                .showDaySpinner(true)
                .defaultDate(2000, 0, 1)
                .maxDate(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH))
                .minDate(1920, 0, 1)
                .build()
                .show();
    }

    @Override
    public void goTermsAndConditions(RegistrationBody registrationBody) {
        Intent intent = new Intent(this, WebViewActivity.class);
        intent.putExtra(KEY_IS_TERM, true);
        intent.putExtra(KEY_REGISTRATION_FORM, registrationBody);
        startActivity(intent);
    }

    @OnClick(R.id.btnSubmit)
    void clickTermsAndConditions() {
        mRegistrationPresenter.checkFields(
                edtFirstName.getText(),
                edtLastName.getText(),
                edtNickname.getText(),
                marred,
                getPhoneNumber().trim(),
                edtDateOfBirth.getText(),
                edtPass.getText(),
                edtConfirmPass.getText());
    }

    private String getPhoneNumber() {
        String number = Utils.getEditableToString(edtMobile.getEditableText());
        if (number.isEmpty()) {
            return "";
        } else {
            return countryPicker.getFullNumberWithPlus();
        }
    }
}
