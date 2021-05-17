package fambox.pro.view.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.core.widget.NestedScrollView;
import androidx.fragment.app.FragmentActivity;
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
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.presenter.fragment.FragmentNetworkPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.MainActivity;
import fambox.pro.view.NgoMapDetailActivity;
import fambox.pro.view.adapter.AdapterCategoryType;
import fambox.pro.view.adapter.MapNGOsAdapter;
import fambox.pro.view.fragment.map.MySupportMapFragment;

import static fambox.pro.Constants.Key.KEY_SERVICE_ID;

public class FragmentNetwork extends BaseFragment implements FragmentNetworkContract.View,
        OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private FragmentNetworkPresenter mFragmentNetworkPresenter;
    private GoogleMap mMap;
    private MySupportMapFragment mMapFragment = null;
    private FragmentActivity mContext;
    private TransferDataListener mTransferDataListener;
    private boolean isAddedFromProfile = false;
    private long mOldServiceId;
    private boolean isSendSms;

    @BindView(R.id.recViewMap)
    RecyclerView recViewMap;
    @BindView(R.id.scrollView)
    NestedScrollView scrollView;
    @BindView(R.id.rvNetworkCategory)
    RecyclerView rvNetworkCategory;
    @BindView(R.id.networkLoading)
    LinearLayout networkLoading;

    public void setServiceId(long serviceId, boolean isAddedFromProfile, boolean isSendSms) {
        this.mOldServiceId = serviceId;
        this.isAddedFromProfile = isAddedFromProfile;
        this.isSendSms = isSendSms;
        onResume();
    }

    @Override
    protected View provideYourFragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_network, container, false);
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        if (getActivity() != null) {
            mContext = getActivity();
        }
        mFragmentNetworkPresenter = new FragmentNetworkPresenter();
        mFragmentNetworkPresenter.attachView(this);
        mFragmentNetworkPresenter.viewIsReady();
        scrollView.fullScroll(View.FOCUS_UP);
        mMapFragment = (MySupportMapFragment) getChildFragmentManager().findFragmentById(R.id.map);
        if (mMapFragment != null)
            mMapFragment.setListener(() -> scrollView.requestDisallowInterceptTouchEvent(true));
        if (mMapFragment != null) {
            mMapFragment.getMapAsync(this);
        }

        ((MainActivity) mContext).setTransferSearchTextListener(text
                -> mFragmentNetworkPresenter.search(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(), text));
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        if (googleMap != null) {
            mMap = googleMap;
            mMap.setOnMarkerClickListener(this);
            // show current location button
//            mMap.setMyLocationEnabled(true);
//            mMap.getUiSettings().setMyLocationButtonEnabled(true);
            String countryCode = ((BaseActivity) mContext).getCountryCode();
            LatLng location = new LatLng(40.0691, 45.0382);
            if (countryCode != null) {
                switch (countryCode) {
                    case "arm":
                        location = new LatLng(40.0691, 45.0382);
                        break;
                    case "geo":
                        location = new LatLng(42.3154, 43.3569);
                        break;
                }
            }
            CameraPosition cameraPosition = new CameraPosition.Builder()
                    .target(location)
                    .zoom(6.5f)
                    .build();
            mMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
//            onResume();
        } else {
            if (getActivity() != null)
                showErrorMessage(getActivity().getResources().getString(R.string.your_map_not_ready));
        }
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof TransferDataListener) {
            mTransferDataListener = (TransferDataListener) context;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mFragmentNetworkPresenter.getServices(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(), isSendSms);
        mFragmentNetworkPresenter.getServiceCategoryTypes(((MainActivity) mContext).getCountryCode(),
                ((MainActivity) mContext).getLocale(), isSendSms);
    }

    public void setSendSms(boolean sendSms) {
        isSendSms = sendSms;
        onResume();
    }

    @Override
    public void addMarkersOnMap(String title, String description, double latitude, double longitude) {
        LatLng position = new LatLng(latitude, longitude);
        if (mMap != null) {
            mMap.addMarker(new MarkerOptions()
                    .position(position)
                    .snippet(description)
                    .title(title));
        } else {
            if (getActivity() != null)
                showErrorMessage(getActivity().getResources().getString(R.string.your_map_not_ready));
        }
    }

    @Override
    public void clearMarkersOnMap() {
        if (mMap != null) {
            mMap.clear();
        } else {
            if (getActivity() != null)
                showErrorMessage(getActivity().getResources().getString(R.string.your_map_not_ready));
        }
    }

    @Override
    public void initRecyclerView(List<ServicesResponseBody> servicesResponseBodyList) {
        MapNGOsAdapter mapNGOsAdapter = new MapNGOsAdapter(servicesResponseBodyList);
        mapNGOsAdapter.setItemClick(position -> {
            Bundle bundle = new Bundle();
            bundle.putBoolean("is_added_from_profile", isAddedFromProfile);
            bundle.putLong("service_old_id", mOldServiceId);
            bundle.putLong(KEY_SERVICE_ID, servicesResponseBodyList.get(position).getId());
            nextActivity(mContext, NgoMapDetailActivity.class, bundle);
        });
        mapNGOsAdapter.setItemCallClick(position -> {
            setUpCall(servicesResponseBodyList.get(position).getUser_detail().getPhone());
        });

        mapNGOsAdapter.setItemEmailClick(position -> {
            setUpEmailAddress(servicesResponseBodyList.get(position).getUser_detail().getEmail());
        });

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewMap.setLayoutManager(verticalLayoutManager);
        recViewMap.setAdapter(mapNGOsAdapter);
    }

    @Override
    public void initRecViewCategoryButtons(Map<String, String> categoryTypes) {
        AdapterCategoryType adapterCategoryType = new AdapterCategoryType(getContext(), categoryTypes, categoryId -> {
            if (categoryId == -111) {
                mFragmentNetworkPresenter.getServices(((MainActivity) mContext).getCountryCode(),
                        ((MainActivity) mContext).getLocale(), isSendSms);
            } else {
                mFragmentNetworkPresenter.getServiceByCategoryID(((MainActivity) mContext).getCountryCode(),
                        ((MainActivity) mContext).getLocale(), categoryId, isSendSms);
            }
        });
        LinearLayoutManager horizontalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.HORIZONTAL, false);
        rvNetworkCategory.setLayoutManager(horizontalLayoutManager);
        rvNetworkCategory.setAdapter(adapterCategoryType);
    }

    @Override
    public void setUpEmailAddress(String emailAddress) {
        if (emailAddress != null) {
            Intent i = new Intent(Intent.ACTION_SEND);
            i.setType("text/plain");
            i.putExtra(Intent.EXTRA_EMAIL, new String[]{emailAddress});
            try {
                startActivity(Intent.createChooser(i, mContext.getResources().getString(R.string.send_mail)));
            } catch (android.content.ActivityNotFoundException ex) {
                if (getActivity() != null)
                    showErrorMessage(getActivity().getResources().getString(R.string.sendet_email_is_emty));
            }
        }

    }

    @Override
    public void setUpCall(String phoneNumber) {
        if (getActivity() != null) {
            if (phoneNumber != null && phoneNumber.length() > 0) {
                startActivity(new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + phoneNumber)));
            } else {
                showErrorMessage(getActivity().getResources().getString(R.string.phone_is_empty));
            }
        }
    }


    @Override
    public boolean onMarkerClick(Marker marker) {
        return false;
    }


    @Override
    public void setSearchResult(List<ServicesSearchResponse> responses) {
        if (mTransferDataListener != null) {
            mTransferDataListener.onDataReceived(responses);
        }
    }

    @Override
    public ToggleButton button(int viewId) {
        return mContext.findViewById(viewId);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentNetworkPresenter != null) {
            mFragmentNetworkPresenter.detachView();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mFragmentNetworkPresenter != null) {
            mFragmentNetworkPresenter.destroy();
        }
    }

    @Override
    public void showProgress() {
        networkLoading.setVisibility(View.VISIBLE);
    }

    @Override
    public void dismissProgress() {
        networkLoading.setVisibility(View.GONE);
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    public interface TransferSearchTextListener {
        void onSendSearch(String text);

    }

    public interface TransferDataListener {
        void onDataReceived(List<ServicesSearchResponse> responses);
    }
}
