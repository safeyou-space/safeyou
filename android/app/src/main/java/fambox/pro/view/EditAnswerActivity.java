package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_ANSWER_ID;
import static fambox.pro.Constants.Key.KEY_BASIC_TYPE;
import static fambox.pro.Constants.Key.KEY_CITY_VILLAGE_TYPE;
import static fambox.pro.Constants.Key.KEY_QUESTION_ID;
import static fambox.pro.Constants.Key.KEY_QUESTION_TITLE;
import static fambox.pro.Constants.Key.KEY_QUESTION_TYPE;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;

import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.network.model.ProfileQuestionOption;
import fambox.pro.network.model.ProfileQuestionsResponse;
import fambox.pro.presenter.EditAnswerPresenter;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.adapter.QuestionOptionsAdapter;

public class EditAnswerActivity extends BaseActivity implements EditAnswerContract.View {

    private EditAnswerPresenter editAnswerPresenter;
    @BindView(R.id.recAnswerList)
    RecyclerView recAnswerList;
    @BindView(R.id.btnContinue)
    AppCompatButton btnContinue;
    @BindView(R.id.btnSkip)
    AppCompatTextView btnSkip;
    @BindView(R.id.containerSearch)
    ConstraintLayout containerSearch;
    @BindView(R.id.questionSearch)
    AppCompatEditText questionSearch;
    private long questionId;
    private long answerId;
    private String questionType;
    private long currentAnswerId;
    private QuestionOptionsAdapter questionOptionsAdapter;
    private List<ProfileQuestionOption> currentOptions;
    private String currentSelectedOptionType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        editAnswerPresenter = new EditAnswerPresenter();
        editAnswerPresenter.attachView(this);
        editAnswerPresenter.viewIsReady();
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            questionId = bundle.getLong(KEY_QUESTION_ID, 0);
            answerId = bundle.getLong(KEY_ANSWER_ID, 0);
            questionType = bundle.getString(KEY_QUESTION_TYPE, "");
            addAppBar(null, false, true,
                    false, bundle.getString(KEY_QUESTION_TITLE, ""), false);
        }
        if (questionType.equals(KEY_BASIC_TYPE)) {
            containerSearch.setVisibility(View.GONE);
        }
        editAnswerPresenter.getQuestionOptions(getCountryCode(), LocaleHelper.getLanguage(getContext()), questionId);
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
                if (questionType.equals(KEY_CITY_VILLAGE_TYPE)) {
                    if (keyword.length() < 2) {
                        questionOptionsAdapter.addData(currentOptions);
                        return;
                    }
                    editAnswerPresenter.findTownOrCity(getCountryCode(), LocaleHelper.getLanguage(getContext()), keyword);

                } else {
                    questionOptionsAdapter.search(keyword);
                }
            }
        });

        btnSkip.setOnClickListener(view -> {
            KeyboardUtils.hideKeyboard(this);
            onBackPressed();
        });


        btnContinue.setOnClickListener(view -> {
            btnContinue.setEnabled(false);
            editAnswerPresenter.answerQuestion(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                    questionId, currentSelectedOptionType == null ? questionType : currentSelectedOptionType, currentAnswerId);

        });


    }

    @Override
    protected int getLayout() {
        return R.layout.activity_edit_answer;
    }


    @Override
    public void initRecyclerView(List<ProfileQuestionsResponse> questionsResponses) {
        currentOptions = questionsResponses.get(0).getOptions();
        questionOptionsAdapter = new QuestionOptionsAdapter(getApplicationContext(),
                currentOptions, answerId);
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        recAnswerList.setLayoutManager(verticalLayoutManager);
        questionOptionsAdapter.setClickListener((answerId, selectedOptionType) -> {
            currentAnswerId = answerId;
            currentSelectedOptionType = selectedOptionType;
            btnContinue.setEnabled(currentAnswerId != this.answerId);
        });
        recAnswerList.setAdapter(questionOptionsAdapter);
    }

    @Override
    public void updateAdapter(List<ProfileQuestionOption> profileQuestionOption) {
        questionOptionsAdapter.addData(profileQuestionOption);
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (editAnswerPresenter != null) {
            editAnswerPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (editAnswerPresenter != null) {
            editAnswerPresenter.destroy();
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
        KeyboardUtils.hideKeyboard(this);
        onBackPressed();
    }

}
