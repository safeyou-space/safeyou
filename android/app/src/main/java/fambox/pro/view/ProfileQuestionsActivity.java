package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_BASIC_TYPE;
import static fambox.pro.Constants.Key.KEY_CITY_VILLAGE_TYPE;
import static fambox.pro.Constants.Key.KEY_PROVINCE_TYPE;
import static fambox.pro.Constants.Key.KEY_SETTLEMENT_TYPE;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.presenter.ProfileQuestionsPresenter;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.ProfileQuestionListAdapter;

public class ProfileQuestionsActivity extends BaseActivity implements ProfileQuestionsContract.View {

    private ProfileQuestionsPresenter mProfileQuestionsPresenter;

    @BindView(R.id.rvProfileQuestions)
    RecyclerView rvProfileQuestions;

    @BindView(R.id.profileQuestionTv)
    AppCompatTextView profileQuestionTv;

    @BindView(R.id.profileQuestionDescriptionTv)
    AppCompatTextView profileQuestionDescriptionTv;

    @BindView(R.id.profileProgressTv)
    AppCompatTextView profileProgressTv;

    @BindView(R.id.profileProgress)
    ProgressBar profileProgress;

    @BindView(R.id.btnPrevious)
    AppCompatTextView btnPrevious;

    @BindView(R.id.btnContinue)
    AppCompatButton btnContinue;

    @BindView(R.id.btnBackToSurvey)
    AppCompatButton btnBackToSurvey;

    @BindView(R.id.questionSearch)
    AppCompatEditText questionSearch;

    @BindView(R.id.successContainer)
    ConstraintLayout successContainer;

    @BindView(R.id.questionsContainer)
    ConstraintLayout questionsContainer;

    @BindView(R.id.successImageView)
    AppCompatImageView successImageView;

    @BindView(R.id.closeButton)
    AppCompatImageView closeButton;

    private int currentIndex = 0;
    private long selectedQuestionId = -1;

    private boolean isSettlementAlreadyAsked = false;
    private String selectedOptionType;
    private List<ProfileQuestionsResponse> profileQuestionsResponses;
    private ProfileQuestionListAdapter profileQuestionListAdapter;
    private String currentType;
    private ProfileQuestionsResponse settlement;
    private ProfileQuestionsResponse currentQuestion;

    private final Map<Object, Object> selectedMap = new HashMap<>();
    private boolean isNeedToShowAnimation = false;
    private boolean isCitySkipped = false;
    private String cityKeyword = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        mProfileQuestionsPresenter = new ProfileQuestionsPresenter();
        mProfileQuestionsPresenter.attachView(this);
        mProfileQuestionsPresenter.viewIsReady();
        mProfileQuestionsPresenter.getProfileQuestions(getCountryCode(), LocaleHelper.getLanguage(getContext()));
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_BLACK_STATUS_BAR_WHITE_OTHER);
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_profile_questions;
    }


    @Override
    public void initView(List<ProfileQuestionsResponse> profileQuestionsResponses) {
        this.profileQuestionsResponses = new ArrayList<>();
        for (ProfileQuestionsResponse profileQuestionsResponse : profileQuestionsResponses) {
            if (profileQuestionsResponse.getType().equals(KEY_SETTLEMENT_TYPE)) {
                this.settlement = profileQuestionsResponse;
            } else {
                this.profileQuestionsResponses.add(profileQuestionsResponse);
            }
        }
        if (this.profileQuestionsResponses.size() == 0) {
            Toast.makeText(this, "The profile was completed successfully", Toast.LENGTH_LONG).show();
            onBackPressed();
            return;
        }
        initRecView();
        btnPrevious.setOnClickListener(view -> {
            selectedOptionType = null;
            profileQuestionListAdapter.addData(Collections.emptyList(), selectedMap.get(currentQuestion.getId()));
            if (currentType.equals(KEY_SETTLEMENT_TYPE) && currentIndex < this.profileQuestionsResponses.size()) {
                this.profileQuestionsResponses.remove(currentIndex);
                isSettlementAlreadyAsked = false;
            }
            currentIndex--;
            if (isCitySkipped) {
                if (currentIndex > 0 && this.profileQuestionsResponses.get(currentIndex).getType().equals(KEY_CITY_VILLAGE_TYPE)) {
                    currentIndex--;
                }
            }
            initRecView();
        });

        btnContinue.setOnClickListener(view -> {
            if (selectedQuestionId == -1 || (currentType.equals(KEY_CITY_VILLAGE_TYPE) && selectedOptionType == null)) {
                selectedOptionType = null;
                skipQuestion();
                return;
            }
            selectedMap.put(currentQuestion.getId(), selectedQuestionId);
            isNeedToShowAnimation = true;
            mProfileQuestionsPresenter.answerQuestion(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                    currentQuestion.getId(), selectedOptionType == null ? currentQuestion.getType() : selectedOptionType, selectedQuestionId);


        });

        btnBackToSurvey.setOnClickListener(view -> {
            onBackPressed();
        });

        questionSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                String keyword = questionSearch.getText().toString().trim();
                if (currentType.equals(KEY_CITY_VILLAGE_TYPE)) {
                    cityKeyword = keyword;
                    mProfileQuestionsPresenter.findTownOrCity(getCountryCode(), LocaleHelper.getLanguage(getContext()), keyword);

                } else {
                    profileQuestionListAdapter.search(keyword);
                }
            }
        });
        closeButton.setOnClickListener(view -> {
            KeyboardUtils.hideKeyboard(this);
            onBackPressed();
        });

    }

    @Override
    public void updateAdapter(List<ProfileQuestionOption> profileQuestionOption) {
        if (!currentType.equals(KEY_CITY_VILLAGE_TYPE)) {
            return;
        }
        if (questionSearch.getText() == null || questionSearch.getText().length() < 2) {
            profileQuestionListAdapter.addData(Collections.emptyList(), selectedMap.get(currentQuestion.getId()));
            return;
        }
        profileQuestionListAdapter.addData(profileQuestionOption, selectedMap.get(currentQuestion.getId()));
    }

    private void initRecView() {
        if (currentIndex >= profileQuestionsResponses.size()) {
            return;
        }
        currentQuestion = profileQuestionsResponses.get(currentIndex);
        currentType = currentQuestion.getType();
        if (this.profileQuestionsResponses.get(currentIndex).getType().equals(KEY_CITY_VILLAGE_TYPE)) {
            isCitySkipped = false;
        }
        if (currentQuestion.getType().equals(KEY_BASIC_TYPE) || currentType.equals(KEY_SETTLEMENT_TYPE)) {
            questionSearch.setVisibility(View.GONE);
        } else {
            questionSearch.setVisibility(View.VISIBLE);
            questionSearch.clearFocus();
            questionSearch.setText(currentType.equals(KEY_CITY_VILLAGE_TYPE) ? cityKeyword : "");
            KeyboardUtils.hideKeyboard(this);
        }
        profileQuestionTv.setText(currentQuestion.getTitle());
        profileProgress.setProgress(currentIndex + 1);
        profileProgress.setMax(profileQuestionsResponses.size());
        profileProgressTv.setText(String.format(Locale.getDefault(), "%d of %d", currentIndex + 1, profileQuestionsResponses.size()));
        updateButtons();
        selectedQuestionId = selectedMap.get(currentQuestion.getId()) == null ? -1 : (long) selectedMap.get(currentQuestion.getId());
        profileQuestionListAdapter = new ProfileQuestionListAdapter(getApplicationContext(), currentQuestion, selectedMap.get(currentQuestion.getId()));
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        rvProfileQuestions.setLayoutManager(verticalLayoutManager);
        profileQuestionListAdapter.setClickListener(new ProfileQuestionListAdapter.ClickListener() {
            @Override
            public void clickListener(long questionOptionId, String questionOptionType) {
                selectedQuestionId = questionOptionId;
                selectedOptionType = questionOptionType;
            }
        });
        rvProfileQuestions.setAdapter(profileQuestionListAdapter);
    }

    private void updateButtons() {
        btnPrevious.setVisibility(currentIndex == 0 ? View.GONE : View.VISIBLE);
        btnContinue.setText(currentIndex + 1 == profileQuestionsResponses.size() ?
                getString(R.string.complete_key) :
                getString(R.string.next_key));
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mProfileQuestionsPresenter != null) {
            mProfileQuestionsPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mProfileQuestionsPresenter != null) {
            mProfileQuestionsPresenter.destroy();
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
        KeyboardUtils.hideKeyboard(this);
        selectedOptionType = null;
        if (selectedQuestionId == 13) {
            if (++currentIndex < this.profileQuestionsResponses.size()) {
                if (this.profileQuestionsResponses.get(currentIndex).getType().equals(KEY_CITY_VILLAGE_TYPE)) {
                    skipQuestion();
                    return;
                }
            } else {
                showSuccess();
                return;
            }
        } else {
            if (++currentIndex >= this.profileQuestionsResponses.size()) {
                showSuccess();
                return;
            }
        }
        selectedQuestionId = -1;
        selectedOptionType = null;
        initRecView();
    }

    private void skipQuestion() {
        KeyboardUtils.hideKeyboard(this);
        selectedQuestionId = -1;
        selectedOptionType = null;
        if (!isSettlementAlreadyAsked && (currentType.equals(KEY_PROVINCE_TYPE) || currentType.equals(KEY_CITY_VILLAGE_TYPE))) {
            this.profileQuestionsResponses.add(currentIndex + 1, settlement);
            isSettlementAlreadyAsked = true;
        }
        if (currentType.equals(KEY_SETTLEMENT_TYPE) && currentIndex + 1 < this.profileQuestionsResponses.size() && this.profileQuestionsResponses.get(currentIndex + 1).getType().equals(KEY_CITY_VILLAGE_TYPE)) {
            isCitySkipped = true;
            currentIndex++;
        }
        if (++currentIndex >= this.profileQuestionsResponses.size()) {
            showSuccess();
            return;
        }
        initRecView();
    }

    private void showSuccess() {
        if (!isNeedToShowAnimation) {
            onBackPressed();
            return;
        }
        successContainer.setVisibility(View.VISIBLE);
        questionsContainer.setVisibility(View.GONE);
        Glide.with(this)
                .load(R.drawable.questions_success)
                .into(successImageView);
        successImageView.setVisibility(View.VISIBLE);
    }

}
