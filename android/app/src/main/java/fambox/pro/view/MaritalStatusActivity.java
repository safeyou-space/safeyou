package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.network.model.MarriedListResponse;
import fambox.pro.presenter.MaritalStatusPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.adapter.MarriedListAdapter;

import static fambox.pro.Constants.Key.KEY_MARITAL_STATUS;

public class MaritalStatusActivity extends BaseActivity implements MaritalStatusContract.View {

    private MaritalStatusPresenter mMaritalStatusPresenter;
    private String maritalStatus;
    private boolean isRegistration;
    private int registrationMaritalPosition;

    @BindView(R.id.recViewMaritalList)
    RecyclerView recViewMaritalList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        mMaritalStatusPresenter = new MaritalStatusPresenter();
        mMaritalStatusPresenter.attachView(this);
        mMaritalStatusPresenter.viewIsReady();
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            maritalStatus = bundle.getString(KEY_MARITAL_STATUS, "");
            isRegistration = bundle.getBoolean("registration_key");
            registrationMaritalPosition = bundle.getInt("registration_marital_position", -1);
        }
        mMaritalStatusPresenter.getMaritalList(getCountryCode(), getLocale());
        addAppBar(null, false, true,
                false, getResources().getString(R.string.select_marital_status), false);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_marital_status;
    }


    @Override
    public void initRecyclerView(List<MarriedListResponse> marriedListResponses) {
        MarriedListAdapter marriedListAdapter = new MarriedListAdapter(getApplicationContext(),
                marriedListResponses, maritalStatus, registrationMaritalPosition, isRegistration);
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        recViewMaritalList.setLayoutManager(verticalLayoutManager);
        marriedListAdapter.setClickListener((position, type, label) -> {
            if (isRegistration) {
                Intent returnIntent = new Intent();
                returnIntent.putExtra("marital_result", type);
                returnIntent.putExtra("marital_label", label);
                setResult(Activity.RESULT_OK, returnIntent);
                finish();
            } else {
                mMaritalStatusPresenter.setMaritalStatus(getCountryCode(), getLocale(), type);
            }
        });
        recViewMaritalList.setAdapter(marriedListAdapter);
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mMaritalStatusPresenter != null) {
            mMaritalStatusPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mMaritalStatusPresenter != null) {
            mMaritalStatusPresenter.destroy();
        }
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
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
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.VISIBLE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void dismissProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.GONE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void onBack() {
        onBackPressed();
    }

}
