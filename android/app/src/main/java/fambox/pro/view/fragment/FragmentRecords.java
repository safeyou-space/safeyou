package fambox.pro.view.fragment;


import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.BaseActivity;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.enums.RecordViewType;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.network.model.RecordSearchResult;
import fambox.pro.presenter.fragment.FragmentRecordsPresenter;
import fambox.pro.utils.LinearDividerItemDecoration;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.RecordActivity;
import fambox.pro.view.RecordDetailsActivity;
import fambox.pro.view.adapter.RecordsAdapter;

/**
 * A simple {@link Fragment} subclass.
 */
public class FragmentRecords extends BaseFragment implements FragmentRecordsContract.View {

    private static final String KEY_RECORD_TYPE = "key_record_type";
    @BindView(R.id.recViewRecord)
    RecyclerView recViewRecord;
    private FragmentActivity mContext;
    private FragmentRecordsPresenter mFragmentRecordsPresenter;
    private int mRecordType;
    private SearchListener mSearchListener;

    public static FragmentRecords newInstance(RecordViewType recordViewType) {
        FragmentRecords fragmentRecords = new FragmentRecords();

        Bundle args = new Bundle();
        args.putInt(KEY_RECORD_TYPE, recordViewType.getType());
        fragmentRecords.setArguments(args);
        return fragmentRecords;
    }

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_records, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        // init presenter.
        mFragmentRecordsPresenter = new FragmentRecordsPresenter();
        mFragmentRecordsPresenter.attachView(this);
        mFragmentRecordsPresenter.viewIsReady();
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        if (context instanceof SearchListener) {
            mSearchListener = (SearchListener) context;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mFragmentRecordsPresenter != null) {
            initBundle();
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentRecordsPresenter != null) {
            mFragmentRecordsPresenter.detachView();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mFragmentRecordsPresenter != null) {
            mFragmentRecordsPresenter.destroy();
        }
    }

    @Override
    public void initBundle() {
        if (getActivity() != null) {
            mContext = getActivity();
        }

        Bundle bundle = getArguments();
        if (bundle != null) {
            mRecordType = bundle.getInt(KEY_RECORD_TYPE);
            mFragmentRecordsPresenter.getRecordByType(((BaseActivity) mContext).getCountryCode(),
                    LocaleHelper.getLanguage(getContext()), mRecordType);
        }

        ((RecordActivity) mContext).setDataReceivedListener(text ->
                mFragmentRecordsPresenter.startSearch(((BaseActivity) mContext).getCountryCode(),
                        LocaleHelper.getLanguage(getContext()), text));
    }

    @Override
    public void initRecordRecyclerView(List<RecordResponse> mRecordModels) {
        RecordsAdapter recordsAdapter =
                new RecordsAdapter(mRecordType, mContext, mRecordModels);
        recordsAdapter.setRecordHolderClick((recordIds, item) -> {
            Bundle bundle = new Bundle();
            bundle.putLong("record_id", item.getId());
            bundle.putIntegerArrayList("all_record_ids", recordIds);
            ((RecordActivity) mContext).nextActivity(mContext, RecordDetailsActivity.class, bundle);
        });

        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL, false);
        recViewRecord.setLayoutManager(verticalLayoutManager);
        recViewRecord.addItemDecoration(new LinearDividerItemDecoration(mContext, LinearDividerItemDecoration.SIZE_THIN));
        recViewRecord.setAdapter(recordsAdapter);
    }

    @Override
    public void setUpSuggestions(List<RecordSearchResult> recordSearchResults) {
        if (mSearchListener != null) {
            mSearchListener.onSuggestion(recordSearchResults);
        }
    }

    @Override
    public void showProgress() {
        try {
            mContext.runOnUiThread(() -> mContext.findViewById(R.id.progressView).setVisibility(View.VISIBLE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void dismissProgress() {
        try {
            mContext.runOnUiThread(() -> mContext.findViewById(R.id.progressView).setVisibility(View.GONE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void showErrorMessage(String message) {
        message(message, SnackBar.SBType.ERROR);
    }

    @Override
    public void showSuccessMessage(String message) {
        message(message, SnackBar.SBType.SUCCESS);
    }

    public interface DataReceivedListener {
        void onDataReceived(String text);
    }

    public interface SearchListener {
        void onSuggestion(List<RecordSearchResult> recordSearchResults);
    }
}
