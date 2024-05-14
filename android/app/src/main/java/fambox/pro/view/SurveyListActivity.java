package fambox.pro.view;

import static fambox.pro.view.SurveyQuestionsActivity.SURVEY_ID;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.Constants;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.model.SurveyListResponse;
import fambox.pro.presenter.SurveyListPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.adapter.SurveyListAdapter;

public class SurveyListActivity extends BaseActivity implements SurveyListContract.View {

    private SurveyListPresenter mSurveyListPresenter;

    @BindView(R.id.rvSurveyList)
    RecyclerView rvSurveyList;
    @BindView(R.id.emptySurveysTv)
    AppCompatTextView emptySurveysTv;

    private int currentPage = 1;
    private SurveyListAdapter surveyListAdapter;
    private boolean isOpening = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SafeYouApp.getPreference()
                .setValue(Constants.Key.KEY_IS_SURVEY_NOTIFICATION_POPUP_OPENED, true);
        addAppBar(null, false,
                true, false, getString(R.string.open_surveys_key), true);

        ButterKnife.bind(this);
        mSurveyListPresenter = new SurveyListPresenter();
        mSurveyListPresenter.attachView(this);
        mSurveyListPresenter.viewIsReady();
        mSurveyListPresenter.getSurveyList(getCountryCode(), LocaleHelper.getLanguage(getContext()), currentPage);

    }

    @Override
    protected int getLayout() {
        return R.layout.activity_survey_list;
    }


    @Override
    public void initView(SurveyListResponse surveyListResponse) {
        if (surveyListResponse.getSurveys().size() == 0) {
            emptySurveysTv.setVisibility(View.VISIBLE);
            return;
        }
        GridLayoutManager gridLayoutManager = new GridLayoutManager(this, 2);
        surveyListAdapter = new SurveyListAdapter(this, surveyListResponse.getSurveys());
        rvSurveyList.setLayoutManager(gridLayoutManager);
        rvSurveyList.setHasFixedSize(true);
        rvSurveyList.setAdapter(surveyListAdapter);
        rvSurveyList.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                int totalItemCount = gridLayoutManager.getItemCount();
                int lastVisiblePosition = gridLayoutManager.findLastVisibleItemPosition();
                if (totalItemCount <= (lastVisiblePosition + 1) && surveyListResponse.getTotal() > surveyListResponse.getPerPage() * currentPage) {
                    loadNextPage();
                }
            }
        });
        surveyListAdapter.setClickListener(surveyId -> {
            if (isOpening) {
                return;
            }
            isOpening = true;
            Bundle bundle = new Bundle();
            bundle.putLong(SURVEY_ID, surveyId);
            Intent intent = new Intent(SurveyListActivity.this, SurveyQuestionsActivity.class);
            intent.putExtras(bundle);
            nextActivity(intent, 1050);
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        isOpening = false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1050 && resultCode == Activity.RESULT_OK) {
            currentPage = 1;
            mSurveyListPresenter.getSurveyList(getCountryCode(), LocaleHelper.getLanguage(getContext()), currentPage);
        }
    }

    private void loadNextPage() {
        mSurveyListPresenter.getSurveyList(getCountryCode(), LocaleHelper.getLanguage(getContext()), ++currentPage);
    }

    @Override
    public void updateAdapter(SurveyListResponse surveyListResponse) {
        surveyListAdapter.addSurveys(surveyListResponse.getSurveys());
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mSurveyListPresenter != null) {
            mSurveyListPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mSurveyListPresenter != null) {
            mSurveyListPresenter.destroy();
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
    public void onSuccess() {

    }
}
