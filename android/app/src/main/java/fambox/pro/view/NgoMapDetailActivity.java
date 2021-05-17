package fambox.pro.view;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.SafeYouApp;
import fambox.pro.network.SocialMediaBody;
import fambox.pro.presenter.NgoMapDetailPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.adapter.SocialMediaAdapter;
import fambox.pro.view.fragment.map.MySupportMapFragment;

import static fambox.pro.Constants.Key.KEY_LOG_IN_FIRST_TIME;

public class NgoMapDetailActivity extends BaseActivity implements NgoMapDetailContract.View,
        OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private NgoMapDetailPresenter mNgoMapDetailPresenter;

    @BindView(R.id.txtMapDetailNgoLocation)
    TextView txtMapDetailNgoLocation;
    @BindView(R.id.txtDetailNgoName)
    TextView txtDetailNgoName;

    @BindView(R.id.recViewSocialMedia)
    RecyclerView recViewSocialMedia;
    @BindView(R.id.btnAddToHelpLine)
    Button btnAddToHelpLine;

    private GoogleMap gMap;
    private MySupportMapFragment mMapFragment = null;
    @BindView(R.id.nestedScrollView)
    NestedScrollView scrollView;


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
        mMapFragment = (MySupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        if (mMapFragment != null)
            mMapFragment.setListener(() -> scrollView.requestDisallowInterceptTouchEvent(true));
        if (mMapFragment != null) {
            mMapFragment.getMapAsync(this);
        }

//        SupportMapFragment mMapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
//        if (mMapFragment != null) {
//            mMapFragment.getMapAsync(this);
//        }
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
//        mNgoMapDetailPresenter.onMapReady();
    }

    @Override
    public void configUserData(String name, String location, List<SocialMediaBody> socialMediaBodyList) {
        txtDetailNgoName.setText(name);
        txtMapDetailNgoLocation.setText(location);
        SocialMediaAdapter socialMediaAdapter = new SocialMediaAdapter(getContext(), socialMediaBodyList);
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        recViewSocialMedia.setLayoutManager(verticalLayoutManager);
        recViewSocialMedia.setAdapter(socialMediaAdapter);
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
        mNgoMapDetailPresenter.navigateAddOrDeleteService(getCountryCode(), getLocale());
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
        SafeYouApp.getPreference(this).setValue(KEY_LOG_IN_FIRST_TIME, false);
        nextActivity(this, MainActivity.class);
        finishAffinity();
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
}
