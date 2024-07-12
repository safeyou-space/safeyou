package fambox.pro.view.fragment;

import static fambox.pro.Constants.Key.KEY_SERVICE_ID;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
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

import org.osmdroid.config.Configuration;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;

import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.BuildConfig;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.network.model.ServicesResponseBody;
import fambox.pro.network.model.ServicesSearchResponse;
import fambox.pro.presenter.fragment.FragmentNetworkPresenter;
import fambox.pro.privatechat.view.ChatActivity;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.MainActivity;
import fambox.pro.view.NgoMapDetailActivity;
import fambox.pro.view.adapter.AdapterCategoryType;
import fambox.pro.view.adapter.MapNGOsAdapter;

public class FragmentNetwork extends BaseFragment implements FragmentNetworkContract.View {

    private FragmentNetworkPresenter mFragmentNetworkPresenter;
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
    @BindView(R.id.map)
    MapView map;

    public void setServiceId(long serviceId, boolean isAddedFromProfile, boolean isSendSms) {
        showProgress();
        this.mOldServiceId = serviceId;
        this.isAddedFromProfile = isAddedFromProfile;
        this.isSendSms = isSendSms;
        refresh();
    }

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
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
        ((MainActivity) mContext).setTransferSearchTextListener(text
                -> mFragmentNetworkPresenter.search(((MainActivity) mContext).getCountryCode(),
                LocaleHelper.getLanguage(getContext()), text));

        mFragmentNetworkPresenter.getServices(((MainActivity) mContext).getCountryCode(),
                LocaleHelper.getLanguage(getContext()), isSendSms);
        mFragmentNetworkPresenter.getServiceCategoryTypes(((MainActivity) mContext).getCountryCode(),
                LocaleHelper.getLanguage(getContext()), isSendSms);

        configMap();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (map != null) {
            map.onResume();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (map != null) {
            map.onPause();
        }
    }

    public void configMap() {
        if (map != null) {
            String countryCode = ((BaseActivity) mContext).getCountryCode();
            GeoPoint point = new GeoPoint(40.0691, 45.0382);
            if (countryCode != null) {
                switch (countryCode) {
                    case "arm":
                        point = new GeoPoint(40.0691, 45.0382);
                        break;
                    case "geo":
                        point = new GeoPoint(42.3154, 43.3569);
                        break;
                    case "irq":
                        point = new GeoPoint(36.2209, 43.6848);
                        break;
                }
            }
            Configuration.getInstance().setUserAgentValue(BuildConfig.APPLICATION_ID);
            map.setTileSource(TileSourceFactory.MAPNIK);
            map.setMultiTouchControls(true);
            map.getController().setZoom(6.5);
            map.getController().setCenter(point);
        }
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof TransferDataListener) {
            mTransferDataListener = (TransferDataListener) context;
        }
    }

    private void refresh() {
        mFragmentNetworkPresenter.getServices(((MainActivity) mContext).getCountryCode(),
                LocaleHelper.getLanguage(getContext()), isSendSms);
        mFragmentNetworkPresenter.getServiceCategoryTypes(((MainActivity) mContext).getCountryCode(),
                LocaleHelper.getLanguage(getContext()), isSendSms);
    }

    public void setSendSms(boolean sendSms) {
        isSendSms = sendSms;
        refresh();
    }

    @Override
    public void addMarkersOnMap(String title, String description, double latitude, double longitude) {
        if (map != null) {
            GeoPoint point = new GeoPoint(latitude, longitude);
            org.osmdroid.views.overlay.Marker marker = new org.osmdroid.views.overlay.Marker(map);
            marker.setPosition(point);
            marker.setTitle(title);
            marker.setSubDescription(description);
            map.getOverlays().add(marker);
        }
    }

    @Override
    public void clearMarkersOnMap() {
        if (map != null) {
            map.getOverlays().clear();
        }
    }

    @Override
    public void initRecyclerView(List<ServicesResponseBody> servicesResponseBodyList) {
        MapNGOsAdapter mapNGOsAdapter = new MapNGOsAdapter(mContext, servicesResponseBodyList);
        mapNGOsAdapter.setItemClick(position -> {
            Bundle bundle = new Bundle();
            bundle.putBoolean("is_added_from_profile", isAddedFromProfile);
            bundle.putLong("service_old_id", mOldServiceId);
            bundle.putLong(KEY_SERVICE_ID, servicesResponseBodyList.get(position).getId());
            nextActivity(mContext, NgoMapDetailActivity.class, bundle);
        });
        mapNGOsAdapter.setItemCallClick(position -> {
            setUpCall(servicesResponseBodyList.get(position).getPhone());
        });

        mapNGOsAdapter.setItemEmailClick(position -> {
            setUpEmailAddress(servicesResponseBodyList.get(position).getEmail());
        });

        mapNGOsAdapter.setItemPrivatMessageClick(position -> {
            Bundle bundle = new Bundle();
            bundle.putBoolean("opened_from_network", true);
            bundle.putString("user_id", servicesResponseBodyList.get(position).getUser_id());
            bundle.putString("user_name", servicesResponseBodyList.get(position).getTitle());
            bundle.putString("user_image", servicesResponseBodyList.get(position).getUser_detail().getImage().getUrl());
            bundle.putString("user_profession", servicesResponseBodyList.get(position).getCategory());
            nextActivity(mContext, ChatActivity.class, bundle);
        });
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(mContext, RecyclerView.VERTICAL, false);
        recViewMap.setLayoutManager(verticalLayoutManager);
        recViewMap.setItemViewCacheSize(mapNGOsAdapter.getItemCount());
        recViewMap.setAdapter(mapNGOsAdapter);
    }

    @Override
    public void initRecViewCategoryButtons(Map<String, String> categoryTypes) {
        AdapterCategoryType adapterCategoryType = new AdapterCategoryType(getContext(), categoryTypes, categoryId -> {
            if (categoryId == -111) {
                mFragmentNetworkPresenter.getServices(((MainActivity) mContext).getCountryCode(),
                        LocaleHelper.getLanguage(getContext()), isSendSms);
            } else {
                mFragmentNetworkPresenter.getServiceByCategoryID(((MainActivity) mContext).getCountryCode(),
                        LocaleHelper.getLanguage(getContext()), categoryId, isSendSms);
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
            Intent i = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:"));
            i.putExtra(Intent.EXTRA_EMAIL, new String[]{emailAddress});
            try {
                startActivity(Intent.createChooser(i, mContext.getResources().getString(R.string.send_mail)));
            } catch (android.content.ActivityNotFoundException ex) {
                if (getActivity() != null)
                    showErrorMessage(getActivity().getResources().getString(R.string.email_is_empty));
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
        final Handler handler = new Handler(Looper.getMainLooper());
        handler.postDelayed(() -> networkLoading.setVisibility(View.GONE), 1000);

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
