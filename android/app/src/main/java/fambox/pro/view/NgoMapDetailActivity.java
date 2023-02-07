package fambox.pro.view;

import static fambox.pro.Constants.Key.KEY_COUNTRY_CODE;
import static fambox.pro.Constants.Key.KEY_SERVICE_ID;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.core.content.ContextCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.android.libraries.maps.CameraUpdateFactory;
import com.google.android.libraries.maps.GoogleMap;
import com.google.android.libraries.maps.OnMapReadyCallback;
import com.google.android.libraries.maps.model.CameraPosition;
import com.google.android.libraries.maps.model.LatLng;
import com.google.android.libraries.maps.model.Marker;
import com.google.android.libraries.maps.model.MarkerOptions;

import java.util.List;
import java.util.Locale;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.hdodenhof.circleimageview.CircleImageView;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.SocialMediaBody;
import fambox.pro.network.model.forum.UserRateResponseBody;
import fambox.pro.presenter.NgoMapDetailPresenter;
import fambox.pro.privatechat.view.ChatActivity;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.adapter.SocialMediaAdapter;
import fambox.pro.view.fragment.FragmentRatingBar;
import fambox.pro.view.fragment.map.MySupportMapFragment;

public class NgoMapDetailActivity extends BaseActivity implements NgoMapDetailContract.View,
        OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private NgoMapDetailPresenter mNgoMapDetailPresenter;

    @BindView(R.id.txtMapDetailNgoLocation)
    TextView txtMapDetailNgoLocation;
    @BindView(R.id.txtDetailNgoName)
    TextView txtDetailNgoName;
    @BindView(R.id.ngoImage)
    CircleImageView ngoImage;

    @BindView(R.id.recViewSocialMedia)
    RecyclerView recViewSocialMedia;
    @BindView(R.id.btnAddToHelpLine)
    Button btnAddToHelpLine;
    // TODO: check button visibility for private message
    @BindView(R.id.imgBtnPrivateMessage)
    ImageButton imgBtnPrivateMessage;

    private GoogleMap gMap;
    @BindView(R.id.nestedScrollView)
    NestedScrollView scrollView;
    @BindView(R.id.rate_bar_layout)
    LinearLayoutCompat rateBar;
    @BindView(R.id.rate_bar_layout_container)
    LinearLayoutCompat rateBarContainer;
    @BindView(R.id.rating)
    TextView rating;
    @BindView(R.id.rateCount)
    TextView rateCount;
    @BindView(R.id.rateIcon)
    ImageView rateIcon;
    @BindView(R.id.ratingContainer)
    FrameLayout ratingContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false, true,
                false, null, true);
        mNgoMapDetailPresenter = new NgoMapDetailPresenter();
        mNgoMapDetailPresenter.attachView(this);
        mNgoMapDetailPresenter.viewIsReady();
        mNgoMapDetailPresenter.initBundle(getIntent().getExtras(), getCountryCode(), getLocale());
        scrollView.fullScroll(View.FOCUS_UP);
        MySupportMapFragment mMapFragment = (MySupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        if (mMapFragment != null)
            mMapFragment.setListener(() -> scrollView.requestDisallowInterceptTouchEvent(true));
        if (mMapFragment != null) {
            mMapFragment.getMapAsync(this);
        }
        if (SafeYouApp.isMinorUser() &&
                (getIntent().getLongExtra(KEY_SERVICE_ID, 0) != 4 && getIntent().getLongExtra(KEY_SERVICE_ID, 0) != 2)) {
            imgBtnPrivateMessage.setVisibility(View.GONE);
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_ngo_map_detail;
    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        return false;
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        gMap = googleMap;
        gMap.setOnMarkerClickListener(this);
    }

    @Override
    public void configUserData(String name, String location, List<SocialMediaBody> socialMediaBodyList, String imagePath,
                               UserRateResponseBody userRate, int ratesCount, long serviceId) {
        txtDetailNgoName.setText(name);
        txtMapDetailNgoLocation.setText(location);
        SocialMediaAdapter socialMediaAdapter = new SocialMediaAdapter(getContext(), socialMediaBodyList);
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        recViewSocialMedia.setLayoutManager(verticalLayoutManager);
        recViewSocialMedia.setAdapter(socialMediaAdapter);

        Glide.with(this)
                .asBitmap()
                .load(imagePath)
                .placeholder(R.drawable.profile_bottom_icon)
                .error(R.drawable.profile_bottom_icon)
                .into(ngoImage);
        ngoImage.setContentDescription(String.format(getString(R.string.ngo_image_description), name));
        if (userRate == null) {
            rating.setVisibility(View.GONE);
            rateCount.setText("");
            rateCount.setVisibility(View.INVISIBLE);
            rateIcon.setImageResource(R.drawable.star_border);
            rateIcon.setContentDescription(getString(R.string.not_rated_icon_description));
        } else {
            rating.setVisibility(View.VISIBLE);
            rateCount.setVisibility(View.INVISIBLE);
            rateIcon.setImageResource(R.drawable.star_filled);
            rating.setText(String.format(new Locale(LocaleHelper.getLanguage(getContext())), "%d/5", userRate.getRate()));
            rateCount.setText("");
            rateIcon.setContentDescription(getString(R.string.rated_count_icon_description));
        }
        rateCount.setTextColor(getResources().getColor(R.color.check_icon_color));
        rating.setTextColor(getResources().getColor(R.color.check_icon_color));

        String countryCode = SafeYouApp.getPreference(this)
                .getStringValue(KEY_COUNTRY_CODE, "arm");

        if (Objects.equals(countryCode, "irq")) {
            rateBar.setVisibility(View.GONE);
        } else {
            rateBar.setVisibility(View.VISIBLE);
        }
        rateBar.setOnClickListener(view -> {
            setDefaultTitle(getResources().getString(R.string.my_review));
            FragmentRatingBar mFragmentRatingBar;
            mFragmentRatingBar = FragmentRatingBar.start(this, R.id.ratingContainer);
            mFragmentRatingBar.setupContent(imagePath, name, "", null, userRate, serviceId, true);
            ratingContainer.setVisibility(View.VISIBLE);
            btnAddToHelpLine.setVisibility(View.GONE);
            scrollView.setVisibility(View.GONE);
        });
        rateBarContainer.setBackground(ContextCompat.getDrawable(getContext(), R.drawable.rate_bar_background));

    }

    @Override
    public void onBackPressed() {
        if (ratingContainer.getVisibility() == View.VISIBLE) {
            setDefaultTitle("");
            ratingContainer.setVisibility(View.GONE);
            btnAddToHelpLine.setVisibility(View.VISIBLE);
            scrollView.setVisibility(View.VISIBLE);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void configMapPosition(String name, String description, double latitude, double longitude) {
        if (gMap != null) {
            LatLng position = new LatLng(latitude, longitude);
            gMap.addMarker(new MarkerOptions()
                    .position(position)
                    .snippet(description)
                    .title(name));
            CameraPosition cameraPosition = new CameraPosition.Builder()
                    .target(position)
                    .zoom(15f)
                    .build();
            gMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
        } else {
            showErrorMessage(getResources().getString(R.string.map_not_ready));
        }
    }

    @OnClick(R.id.btnAddToHelpLine)
    void clickAddToHelpLine() {
        mNgoMapDetailPresenter.navigateAddOrDeleteService(getCountryCode(), LocaleHelper.getLanguage(getContext()));
    }

    @OnClick(R.id.imgBtnPrivateMessage)
    void clickPrivateMessage() {
        mNgoMapDetailPresenter.goToPrivateMessage();
    }

    @Override
    public void configHelplineButton(String buttonText, int textColor) {
        btnAddToHelpLine.setText(buttonText);
        btnAddToHelpLine.setTextColor(textColor);
    }

    @Override
    public void configAddToHelplineButtonVisibility(int visibility) {
        btnAddToHelpLine.setVisibility(visibility);
    }

    @Override
    public void goToProfile() {
        nextActivity(this, EmergencyContactActivity.class);
        finish();
    }

    @Override
    public void goToPrivateChat(Bundle bundle) {
        nextActivity(this, ChatActivity.class, bundle);
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mNgoMapDetailPresenter != null) {
            mNgoMapDetailPresenter.detachView();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mNgoMapDetailPresenter != null) {
            mNgoMapDetailPresenter.destroy();
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

    public void setIsRated(boolean b) {
        mNgoMapDetailPresenter.initBundle(getIntent().getExtras(), getCountryCode(), getLocale());
    }
}
