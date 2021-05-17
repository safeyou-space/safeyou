package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;
import com.hbb20.CountryCodePicker;
import com.tsongkha.spinnerdatepicker.SpinnerDatePickerDialogBuilder;

import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.presenter.RegistrationPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.TimeUtil;
import fambox.pro.utils.Utils;

public class RegistrationActivity extends BaseActivity implements RegistrationContract.View {

    private RegistrationPresenter mRegistrationPresenter;
    private int marred = -1;

    @BindView(R.id.edtFirstName)
    TextInputEditText edtFirstName;
    @BindView(R.id.edtLastName)
    TextInputEditText edtLastName;
    @BindView(R.id.edtNickname)
    TextInputEditText edtNickname;
    @BindView(R.id.edtDateOfBirth)
    TextInputEditText edtDateOfBirth;
    @BindView(R.id.edtMobile)
    TextInputEditText edtMobile;
    @BindView(R.id.edtMarital)
    TextView edtMarital;
    @BindView(R.id.edtPass)
    TextInputEditText edtPass;
    @BindView(R.id.edtConfirmPass)
    TextInputEditText edtConfirmPass;
    @BindView(R.id.countryPicker)
    CountryCodePicker countryPicker;
//    @BindView(R.id.spinner)
//    Spinner spinner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE);
        ButterKnife.bind(this);
        mRegistrationPresenter = new RegistrationPresenter();
        mRegistrationPresenter.attachView(this);
        mRegistrationPresenter.viewIsReady();
//        edtDateOfBirth.addTextChangedListener(new DateTextWatcher());
        addAppBar(null,true, true,
                false,null,false);
        countryPicker.setCcpClickable(false);
        countryPicker.setCountryForNameCode(Objects.equals(getCountryCode(), "geo") ? "GE" : "AM");
        countryPicker.showArrow(false);
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

    @OnClick(R.id.containerMarital)
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
        new SpinnerDatePickerDialogBuilder()
                .context(RegistrationActivity.this)
                .spinnerTheme(R.style.NumberPickerStyle)
                .callback((view, year, monthOfYear, dayOfMonth) -> {
                    String stringBuilder = dayOfMonth + "/" + (monthOfYear + 1) + "/" + year;
                    edtDateOfBirth.setText(TimeUtil.convertDate(stringBuilder));
                })
                .showDaySpinner(true)
                .defaultDate(2000, 0, 1)
                .maxDate(2020, 0, 1)
                .minDate(1920, 0, 1)
                .build()
                .show();
    }

    @OnClick(R.id.btnSubmit)
    void submitClick() {
        mRegistrationPresenter.submitRegistration(getLocale(), getCountryCode(),
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
            countryPicker.registerCarrierNumberEditText(edtMobile);
            return countryPicker.getFullNumberWithPlus();
        }
    }

    @Override
    public void goVerifyRegistration() {
        nextActivity(this, VerificationActivity.class);
    }
}
