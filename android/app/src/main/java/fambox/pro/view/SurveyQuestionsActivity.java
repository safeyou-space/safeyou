package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_RATING_SMILE_FACE_TYPE;
import static fambox.pro.Constants.Key.KEY_RATING_STAR_TYPE;
import static fambox.pro.Constants.Key.KEY_RATING_TYPE;
import static fambox.pro.Constants.Key.KEY_TEXT_ANSWER_TYPE;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatEditText;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.cardview.widget.CardView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.Types;
import fambox.pro.network.model.SurveyOptions;
import fambox.pro.network.model.SurveyQuestion;
import fambox.pro.network.model.Surveys;
import fambox.pro.presenter.SurveyQuestionsPresenter;
import fambox.pro.utils.KeyboardUtils;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.SurveyMultipleChoiceListAdapter;
import fambox.pro.view.dialog.CloseSurveyDialog;
import fambox.pro.view.dialog.DeleteAccountDialog;

public class SurveyQuestionsActivity extends BaseActivity implements SurveyQuestionsContract.View {

    public static final String SURVEY_ID = "SURVEY_ID";

    private SurveyQuestionsPresenter surveyQuestionsPresenter;

    @BindView(R.id.rvMultipleChoice)
    RecyclerView rvMultipleChoice;

    @BindView(R.id.surveyQuestionTv)
    AppCompatTextView surveyQuestionTv;

    @BindView(R.id.shortAnswerTv)
    AppCompatEditText shortAnswerTv;

    @BindView(R.id.longAnswerTv)
    AppCompatEditText longAnswerTv;
    @BindView(R.id.longAnswerContainer)
    ConstraintLayout longAnswerContainer;

    @BindView(R.id.rateAnswerContainer)
    LinearLayout rateAnswerContainer;
    @BindView(R.id.oneStar)
    AppCompatImageView oneStar;
    @BindView(R.id.twoStars)
    AppCompatImageView twoStars;
    @BindView(R.id.threeStars)
    AppCompatImageView threeStars;
    @BindView(R.id.fourStars)
    AppCompatImageView fourStars;
    @BindView(R.id.fiveStars)
    AppCompatImageView fiveStars;

    private List<AppCompatImageView> ratingButtons;
    private int rate = 0;

    @BindView(R.id.surveyQuestionDescriptionTv)
    AppCompatTextView surveyQuestionDescriptionTv;

    @BindView(R.id.surveyProgressTv)
    AppCompatTextView surveyProgressTv;

    @BindView(R.id.surveyProgress)
    ProgressBar surveyProgress;

    @BindView(R.id.btnPrevious)
    AppCompatTextView btnPrevious;

    @BindView(R.id.btnContinue)
    AppCompatButton btnContinue;

    @BindView(R.id.btnBackToSurvey)
    AppCompatButton btnBackToSurvey;
    @BindView(R.id.thanks_text_tv)
    AppCompatTextView thanksTextTv;

    @BindView(R.id.successContainer)
    ConstraintLayout successContainer;
    @BindView(R.id.progressContainer)
    ConstraintLayout progressContainer;
    @BindView(R.id.progressTv)
    AppCompatTextView progressTv;
    @BindView(R.id.quizProgress)
    ProgressBar quizProgress;

    @BindView(R.id.questionsContainer)
    ConstraintLayout questionsContainer;
    @BindView(R.id.progressBarContainerCardView)
    CardView progressBarContainerCardView;

    @BindView(R.id.successImageView)
    AppCompatImageView successImageView;

    @BindView(R.id.closeButton)
    AppCompatImageView closeButton;

    private int currentIndex = 0;

    private List<SurveyQuestion> surveyQuestionsResponses;
    private SurveyMultipleChoiceListAdapter surveyMultipleChoiceListAdapter;
    private String currentType;
    private SurveyQuestion currentQuestion;

    private final Map<Object, Object> selectedMap = new HashMap<>();
    private boolean isNeedToShowAnimation = false;
    private Surveys survey;
    private boolean isSurveyCompleted;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        surveyQuestionsPresenter = new SurveyQuestionsPresenter();
        surveyQuestionsPresenter.attachView(this);
        surveyQuestionsPresenter.viewIsReady();

        surveyQuestionsPresenter.getSurveyById(getCountryCode(), LocaleHelper.getLanguage(getContext()), getIntent().getExtras().getLong(SURVEY_ID));
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
            Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_BLACK_STATUS_BAR_WHITE_OTHER);
        }
        ratingButtons = new ArrayList<>(5);
        ratingButtons.add(oneStar);
        ratingButtons.add(twoStars);
        ratingButtons.add(threeStars);
        ratingButtons.add(fourStars);
        ratingButtons.add(fiveStars);
        for (AppCompatImageView imageView : ratingButtons) {
            imageView.setOnClickListener(clickedView -> {
                rate = ratingButtons.indexOf((AppCompatImageView) clickedView) + 1;
                setRatingStyles();
            });
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_survey_questions;
    }


    @Override
    public void initView(Surveys survey) {
        this.survey = survey;
        this.surveyQuestionsResponses = survey.getQuestions();
        initRecView();
        questionsContainer.setOnClickListener(view -> KeyboardUtils.hideKeyboard(SurveyQuestionsActivity.this));
        btnPrevious.setOnClickListener(view -> {
            currentIndex--;
            initRecView();
        });

        btnContinue.setOnClickListener(view -> {
            Object answer;
            boolean isRequired = currentQuestion.getRequired() == 1;
            if (currentType.startsWith(KEY_RATING_TYPE)) {
                if (rate == 0) {
                    if (isRequired) {
                        return;
                    }
                    skipQuestion();
                    return;
                }
                answer = rate;
                rate = 0;
            } else if (currentType.equals(KEY_TEXT_ANSWER_TYPE)) {
                if (currentQuestion.getLongAnswer() == 1) {
                    if (longAnswerTv.getText() == null || longAnswerTv.getText().length() == 0) {
                        if (isRequired) {
                            return;
                        }
                        skipQuestion();
                        return;
                    }
                    answer = longAnswerTv.getText().toString();
                    longAnswerTv.setText("");
                } else {
                    if (shortAnswerTv.getText() == null || shortAnswerTv.getText().length() == 0) {
                        if (isRequired) {
                            return;
                        }
                        skipQuestion();
                        return;
                    }
                    answer = shortAnswerTv.getText().toString();
                    shortAnswerTv.setText("");
                }
            } else {
                if (surveyMultipleChoiceListAdapter.getSelectedOptionIds().size() == 0) {
                    if (!survey.isQuiz() || !survey.isAnswered()) {
                        if (isRequired) {
                            return;
                        }
                    }
                    skipQuestion();
                    return;
                }
                answer = surveyMultipleChoiceListAdapter.getSelectedOptionIds();
            }
            selectedMap.put(currentQuestion.getId(), answer);
            isNeedToShowAnimation = true;
            skipQuestion();

        });

        btnBackToSurvey.setOnClickListener(view -> {
            setResult(RESULT_OK);
            finish();
        });

        closeButton.setOnClickListener(view -> {
            KeyboardUtils.hideKeyboard(this);
            onBackPressed();
        });

    }

    private void initRecView() {
        KeyboardUtils.hideKeyboard(this);
        if (currentIndex >= surveyQuestionsResponses.size()) {
            return;
        }
        if ((currentIndex + 4) % 4 == 0) {
            questionsContainer.setBackground(ContextCompat.getDrawable(this, R.drawable.survey_bg_1));
        } else if ((currentIndex + 4) % 4 == 1) {
            questionsContainer.setBackground(ContextCompat.getDrawable(this, R.drawable.survey_bg_2));
        } else if ((currentIndex + 4) % 4 == 2) {
            questionsContainer.setBackground(ContextCompat.getDrawable(this, R.drawable.survey_bg_3));
        } else {
            questionsContainer.setBackground(ContextCompat.getDrawable(this, R.drawable.survey_bg_4));
        }

        currentQuestion = surveyQuestionsResponses.get(currentIndex);
        currentType = currentQuestion.getType();
        String questionTitle = currentQuestion.getTranslation().getTitle();
        boolean isRequired = currentQuestion.getRequired() == 1;
        if (isRequired) {
            questionTitle += " *";
        }
        surveyQuestionDescriptionTv.setText(questionTitle);

        Object answer = selectedMap.get(currentQuestion.getId());

        if (currentType.equals(KEY_TEXT_ANSWER_TYPE)) {
            if (currentQuestion.getLongAnswer() == 1) {
                if (answer != null) {
                    longAnswerTv.setText(answer.toString());
                }
                updateUIContainers(false, true, false, false);
            } else {
                if (answer != null) {
                    shortAnswerTv.setText(answer.toString());
                }
                updateUIContainers(true, false, false, false);
            }
        } else if (currentType.startsWith(KEY_RATING_TYPE)) {
            if (answer != null) {
                rate = (int) answer;
            }
            setRatingStyles();
            updateUIContainers(false, false, true, false);
        } else {
            setMultipleChoice();

            if (answer != null) {
                surveyMultipleChoiceListAdapter.setSelectedOptionIds(answer);
            }
            updateUIContainers(false, false, false, true);
        }
        surveyQuestionTv.setText(survey.getTranslation().getTitle());
        surveyProgress.setProgress(currentIndex + 1);
        surveyProgress.setMax(surveyQuestionsResponses.size());
        surveyProgressTv.setText(String.format(Locale.getDefault(), "%d of %d", currentIndex + 1, surveyQuestionsResponses.size()));
        updateButtons();
    }

    private void setMultipleChoice() {
        surveyMultipleChoiceListAdapter = new SurveyMultipleChoiceListAdapter(this, currentQuestion.getOptions(),
                currentType, survey.isAnswered(), survey.getUserAnswer() == null ? null : survey.getUserAnswer().getUserAnswerDetailsList());
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        rvMultipleChoice.setLayoutManager(verticalLayoutManager);
        rvMultipleChoice.setAdapter(surveyMultipleChoiceListAdapter);
    }

    private void updateUIContainers(boolean isNeedToShowShortAnswer, boolean isNeedToShowLongAnswer,
                                    boolean isNeedToShowRateAnswer, boolean isNeedToShowMultipleChoiceAnswer) {
        shortAnswerTv.setVisibility(isNeedToShowShortAnswer ? View.VISIBLE : View.GONE);
        longAnswerContainer.setVisibility(isNeedToShowLongAnswer ? View.VISIBLE : View.GONE);
        rateAnswerContainer.setVisibility(isNeedToShowRateAnswer ? View.VISIBLE : View.GONE);
        rvMultipleChoice.setVisibility(isNeedToShowMultipleChoiceAnswer ? View.VISIBLE : View.GONE);
    }

    private void updateButtons() {
        btnPrevious.setVisibility(currentIndex == 0 ? View.GONE : View.VISIBLE);
        btnContinue.setText(currentIndex + 1 == surveyQuestionsResponses.size() ?
                (survey.isQuiz() && survey.isAnswered()) ? getString(R.string.close_key)
                        : getString(R.string.complete_key) :
                getString(R.string.next_key));
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (surveyQuestionsPresenter != null) {
            surveyQuestionsPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (surveyQuestionsPresenter != null) {
            surveyQuestionsPresenter.destroy();
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
        isSurveyCompleted = true;
        KeyboardUtils.hideKeyboard(this);
        if (!isNeedToShowAnimation) {
            onBackPressed();
            return;
        }

        if (survey.isQuiz()) {
            int correctAnswersCount = 0;
            for (SurveyQuestion question : survey.getQuestions()) {
                List<Long> answer = (List<Long>) selectedMap.get(question.getId());
                if (answer == null) {
                    continue;
                }
                List<Long> correctAnswer = new ArrayList<>();
                for (SurveyOptions options : question.getOptions()) {
                    if (options.isCorrectAnswer()) {
                        correctAnswer.add(options.getId());
                    }
                }
                if (listEqualsIgnoreOrder(correctAnswer, answer)) {
                    correctAnswersCount++;
                }
            }
            int perc = correctAnswersCount * 100 / survey.getQuestions().size();
            progressContainer.setVisibility(View.VISIBLE);
            successImageView.setVisibility(View.INVISIBLE);
            quizProgress.setProgress(perc);
            progressTv.setText(String.format(Locale.getDefault(), "%d%s", perc, "%"));
            btnBackToSurvey.setText(R.string.see_result_key);

            btnBackToSurvey.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    startActivity(getIntent());
                    finish();
                }
            });

        }
        successContainer.setVisibility(View.VISIBLE);
        questionsContainer.setVisibility(View.GONE);
        progressBarContainerCardView.setVisibility(View.GONE);
        Glide.with(this)
                .load(R.drawable.questions_success)
                .into(successImageView);
        setResult(RESULT_OK);
    }
    public static <T> boolean listEqualsIgnoreOrder(List<T> list1, List<T> list2) {
        return new HashSet<>(list1).equals(new HashSet<>(list2));
    }
    private void skipQuestion() {
        KeyboardUtils.hideKeyboard(this);
        if (++currentIndex >= this.surveyQuestionsResponses.size()) {
            showSuccess();
            return;
        }
        initRecView();
    }

    private void showSuccess() {
        if (selectedMap.isEmpty()) {
            isNeedToShowAnimation = false;
            onSuccess();
            return;
        }
        currentIndex--;
        surveyQuestionsPresenter.answerQuestion(getCountryCode(), LocaleHelper.getLanguage(getContext()),
                currentQuestion.getSurveyId(), currentQuestion.getId(), selectedMap);


    }

    private void setRatingStyles() {
        for (int i = 0; i < ratingButtons.size(); i++) {
            if (i < rate) {
                ratingButtons.get(i).setContentDescription(String.format(getString(R.string.rated_icon_description), i + 1));
                if (currentType.equals(KEY_RATING_STAR_TYPE)) {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_reate_star_full);
                } else if (currentType.equals(KEY_RATING_SMILE_FACE_TYPE)) {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_reate_smile_full);
                } else {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_rate_heart_full);
                }
            } else {
                ratingButtons.get(i).setContentDescription(String.format(getString(R.string.rate_icon_description), i + 1));
                if (currentType.equals(KEY_RATING_STAR_TYPE)) {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_reate_star_outline);

                } else if (currentType.equals(KEY_RATING_SMILE_FACE_TYPE)) {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_reate_smile_outline);
                } else {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_rate_heart_outline);
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (isSurveyCompleted || (survey.isQuiz() && survey.isAnswered())) {
            super.onBackPressed();
        } else {
            CloseSurveyDialog closeSurveyDialog = new CloseSurveyDialog(this);
            closeSurveyDialog.setDialogClickListener((dialog, which) -> {
                switch (which) {
                    case DeleteAccountDialog.CLICK_CLOSE:
                    case DeleteAccountDialog.CLICK_CANCEL:
                        dialog.dismiss();
                        break;
                    case DeleteAccountDialog.CLICK_DELETE:
                        isSurveyCompleted = true;
                        onBackPressed();
                        dialog.dismiss();
                        break;
                }
            });
            closeSurveyDialog.show();
        }
    }
}
