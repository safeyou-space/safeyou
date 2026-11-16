package fambox.pro.view.fragment;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.cardview.widget.CardView;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.Constants;
import fambox.pro.R;
import fambox.pro.network.model.forum.UserRateResponseBody;
import fambox.pro.presenter.fragment.FragmentRatePresenter;
import fambox.pro.utils.TimeUtil;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.NgoMapDetailActivity;

public class FragmentRatingBar extends BaseFragment implements FragmentRateContract.View {

    @BindView(R.id.oneStar)
    ImageView oneStar;
    @BindView(R.id.twoStars)
    ImageView twoStars;
    @BindView(R.id.threeStars)
    ImageView threeStars;
    @BindView(R.id.fourStars)
    ImageView fourStars;
    @BindView(R.id.fiveStars)
    ImageView fiveStars;
    @BindView(R.id.forumImage)
    ImageView forumImage;
    @BindView(R.id.title)
    TextView titleTextView;
    @BindView(R.id.author)
    TextView authorTextView;
    @BindView(R.id.createDate)
    TextView createDate;
    @BindView(R.id.cancelButton)
    TextView cancelButton;
    @BindView(R.id.rateButton)
    Button rateButton;
    @BindView(R.id.rateComment)
    EditText rateComment;
    @BindView(R.id.bottomLayout)
    LinearLayoutCompat bottomLayout;
    @BindView(R.id.commentVisibleText)
    TextView commentVisibleText;
    @BindView(R.id.whatRate)
    TextView whatRate;
    @BindView(R.id.review)
    TextView review;
    @BindView(R.id.editIcon)
    ImageView editIcon;
    @BindView(R.id.forumCard)
    CardView forumCard;
    @BindView(R.id.ngoCard)
    CardView ngoCard;
    @BindView(R.id.ngoImage)
    ImageView ngoImage;
    @BindView(R.id.ngoTitle)
    TextView ngoTitle;


    private FragmentActivity mContext;
    private FragmentRatePresenter mFragmentRatePresenter;
    private View.OnClickListener mOnClickListener;


    private List<ImageView> ratingButtons;
    private int rate = 0;
    private String comment = "";
    private long mForumID;
    private boolean isAlreadyRated;
    private UserRateResponseBody mUserRate;
    private boolean isNGO;
    private Toast toast;
    private String minCharStringFormat;
    private String reviewString = "";

    public static FragmentRatingBar start(FragmentActivity context, int containerId) {
        FragmentRatingBar fragmentForumDetail = new FragmentRatingBar();
        FragmentManager fragmentManager = context.getSupportFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        fragmentTransaction.add(containerId, fragmentForumDetail).commit();
        return fragmentForumDetail;
    }

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        return inflater.inflate(R.layout.fragment_rating_bar, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        ratingButtons = new ArrayList<>(5);
        ratingButtons.add(oneStar);
        ratingButtons.add(twoStars);
        ratingButtons.add(threeStars);
        ratingButtons.add(fourStars);
        ratingButtons.add(fiveStars);
        for (ImageView imageView : ratingButtons) {
            imageView.setOnClickListener(clickedView -> {
                rate = ratingButtons.indexOf((ImageView) clickedView) + 1;
                if (rate != 0 && (!isNGO && comment.length() == 0 || comment.length() >= 25)) {
                    rateButton.setAlpha(1);
                    rateButton.setEnabled(true);
                }
                setRatingStyles();
            });
        }
        mFragmentRatePresenter = new FragmentRatePresenter();
        mFragmentRatePresenter.attachView(this);
        mFragmentRatePresenter.viewIsReady();
        rateButton.setAlpha(0.5f);
        rateButton.setEnabled(false);
        rateButton.setOnClickListener(view1 -> {
            mFragmentRatePresenter.rateForum(rate, rateComment.getText().toString(), mForumID, isNGO);
        });
        cancelButton.setOnClickListener(view12 -> {
            if (isNGO) {
                if (getActivity() != null) {
                    getActivity().onBackPressed();
                }
            } else {
                FragmentRatingBar.this.onClick(view12, 3);
            }
            rateButton.setAlpha(0.5f);
            rateButton.setEnabled(false);
            if (!isAlreadyRated) {
                rateComment.setText("");
                rate = 0;
                setRatingUnchecked();
            } else {
                setAlreadyRatedStyles();
            }
        });
        String minChar = getResources().getString(R.string.min_rate_characters);
        minCharStringFormat = String.format("%s (%s)", reviewString, minChar);
        editIcon.setOnClickListener(view13 -> {
            editIcon.setVisibility(View.GONE);
            commentVisibleText.setVisibility(View.VISIBLE);
            bottomLayout.setVisibility(View.VISIBLE);
            review.setVisibility(View.VISIBLE);
            whatRate.setVisibility(View.VISIBLE);
            rateComment.setVisibility(View.VISIBLE);
            rateComment.setEnabled(true);
            int minCharCount = 25 - comment.length();
            if (minCharCount > 0) {
                review.setText(String.format(minCharStringFormat, minCharCount));
            } else {
                review.setText(reviewString);
            }

            for (ImageView imageView : ratingButtons) {
                imageView.setEnabled(true);
            }
        });

        rateComment.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                comment = charSequence.toString();
                if (rate != 0 && (!isNGO && comment.length() == 0 || comment.length() >= 25)) {
                    rateButton.setAlpha(1);
                    rateButton.setEnabled(true);
                } else {
                    rateButton.setAlpha(0.5f);
                    rateButton.setEnabled(false);
                }
                int minCharCount = 25 - comment.length();
                if (minCharCount > 0) {
                    review.setText(String.format(minCharStringFormat, minCharCount));
                } else {
                    review.setText(reviewString);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        setRatingStyles();
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof View.OnClickListener) {
            mOnClickListener = (View.OnClickListener) context;
        }
    }

    public void setupContent(String imagePath, String title, String author, Date createdAt,
                             UserRateResponseBody userRate, long forumId, boolean isNGO) {
        new Handler(Looper.getMainLooper()).post(() -> {
            this.isNGO = isNGO;
            if (isNGO) {
                whatRate.setText(getResources().getString(R.string.what_rate_ngo));
                reviewString = getResources().getString(R.string.review_required);
                ngoCard.setVisibility(View.VISIBLE);
                forumCard.setVisibility(View.GONE);
                mUserRate = userRate;
                Glide.with(this)
                        .asBitmap()
                        .load(imagePath)
                        .placeholder(R.drawable.profile_bottom_icon)
                        .error(R.drawable.profile_bottom_icon)
                        .into(ngoImage);
                ngoTitle.setText(title);

            } else {
                whatRate.setText(getResources().getString(R.string.what_rate_forum));
                reviewString = getResources().getString(R.string.review);
                ngoCard.setVisibility(View.GONE);
                forumCard.setVisibility(View.VISIBLE);
                mUserRate = userRate;
                Glide.with(mContext).load(Constants.BASE_URL + imagePath).into(forumImage);
                titleTextView.setText(title);
                authorTextView.setText(author);
                createDate.setText(TimeUtil.convertPrivatChatListDate(getResources().getConfiguration().locale.getLanguage(), createdAt));
            }
            mForumID = forumId;
            if (userRate != null) {
                isAlreadyRated = true;
                setAlreadyRatedStyles();

            }
            String minChar = getResources().getString(R.string.min_rate_characters);
            minCharStringFormat = String.format("%s (%s)", reviewString, minChar);
            this.review.setText(String.format(minCharStringFormat, 25));
            if (isAlreadyRated) {
                setRatingStyles();
            } else {
                setRatingUnchecked();
            }
        });
    }

    private void setAlreadyRatedStyles() {
        if (isNGO) {
            editIcon.setVisibility(View.VISIBLE);
        }
        commentVisibleText.setVisibility(View.INVISIBLE);
        bottomLayout.setVisibility(View.INVISIBLE);
        review.setVisibility(View.INVISIBLE);
        whatRate.setVisibility(View.INVISIBLE);
        rate = mUserRate.getRate();
        rateComment.setEnabled(false);
        if (mUserRate.getComment() == null || mUserRate.getComment().isEmpty()) {
            rateComment.setVisibility(View.GONE);
        } else {
            rateComment.setText(mUserRate.getComment());
        }

        for (ImageView imageView : ratingButtons) {
            imageView.setEnabled(false);
        }
        setRatingStyles();
    }


    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {
        toast = Toast.makeText(getContext(), message, Toast.LENGTH_SHORT);
        toast.show();
        final Handler handler = new Handler(Looper.getMainLooper());
        handler.postDelayed(() -> {
            isAlreadyRated = true;
            mUserRate = new UserRateResponseBody();
            mUserRate.setRate(rate);
            mUserRate.setComment(comment);
            setAlreadyRatedStyles();
            if (!isNGO) {
                ((ForumCommentActivity) getActivity()).setIsRated(true);
            } else {
                ((NgoMapDetailActivity) getActivity()).setIsRated(true);
            }
            toast.cancel();
            getActivity().onBackPressed();
        }, 2000);
    }

    @Override
    public void initBundle() {

    }

    @Override
    public void showProgress() {

    }

    @Override
    public void dismissProgress() {

    }

    private void onClick(View view, int type) {
        if (mOnClickListener != null) {
            view.setTag(type);
            mOnClickListener.onClick(view);
        }
    }

    private void setRatingUnchecked() {
        for (int i = 0; i < ratingButtons.size(); i++) {
            ratingButtons.get(i).setContentDescription(String.format(getString(R.string.rate_icon_description), i + 1));
            if (isNGO) {
                ratingButtons.get(i).getLayoutParams().height = 100;
                ratingButtons.get(i).getLayoutParams().width = 100;
                ratingButtons.get(i).requestLayout();
                ratingButtons.get(i).setImageResource(R.drawable.star_border);
            } else {
                ratingButtons.get(i).setImageResource(R.drawable.icon_like_coment_empty);
            }
        }
    }

    private void setRatingStyles() {
        for (int i = 0; i < ratingButtons.size(); i++) {
            if (i < rate) {
                ratingButtons.get(i).setContentDescription(String.format(getString(R.string.rated_icon_description), i + 1));
                if (isNGO) {
                    ratingButtons.get(i).getLayoutParams().height = 100;
                    ratingButtons.get(i).getLayoutParams().width = 100;
                    ratingButtons.get(i).requestLayout();
                    ratingButtons.get(i).setImageResource(R.drawable.star_filled);
                } else {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_licke_coment_full);
                }
            } else {
                ratingButtons.get(i).setContentDescription(String.format(getString(R.string.rate_icon_description), i + 1));
                if (isNGO) {
                    ratingButtons.get(i).getLayoutParams().height = 100;
                    ratingButtons.get(i).getLayoutParams().width = 100;
                    ratingButtons.get(i).requestLayout();
                    ratingButtons.get(i).setImageResource(R.drawable.star_border);

                } else {
                    ratingButtons.get(i).setImageResource(R.drawable.icon_like_coment_empty);
                }
            }
        }
    }

    public void clearData() {
        setRatingStyles();
        if (rate != 0 && (!isNGO && comment.length() == 0 || comment.length() >= 25)) {
            rateButton.setAlpha(1);
            rateButton.setEnabled(true);
        } else {
            rateButton.setAlpha(0.5f);
            rateButton.setEnabled(false);
        }
    }
}