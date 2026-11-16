package fambox.pro.view.fragment;

import static android.app.Activity.RESULT_OK;

import android.app.Application;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.fambox.chatkit.messages.RecyclerScrollMoreListener;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;
import fambox.pro.network.model.forum.ForumFilter;
import fambox.pro.network.model.forum.ForumResponseBody;
import fambox.pro.presenter.fragment.FragmentForumPresenter;
import fambox.pro.utils.Connectivity;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.ForumCommentActivity;
import fambox.pro.view.ForumFilterActivity;
import fambox.pro.view.adapter.AdapterForumFilterChips;
import fambox.pro.view.adapter.AdapterForumSort;
import fambox.pro.view.adapter.ForumV2Adapter;

public class FragmentForum extends BaseFragment implements FragmentForumContract.View {

    private FragmentForumPresenter mFragmentForumPresenter;
    private FragmentActivity mContext;
    private HashMap<String, String> mapCategory;
    private HashMap<String, String> mapLanguage;
    private ForumV2Adapter forumAdapter;

    @BindView(R.id.recViewForum)
    RecyclerView recViewForum;
    @BindView(R.id.recViewChooseFilteredCategory)
    RecyclerView recViewChooseFilteredCategory;
    @BindView(R.id.errorMessage)
    TextView errorMessage;
    @BindView(R.id.forumLoading)
    LinearLayout forumLoading;
    @BindView(R.id.btnForumFilter)
    Button btnForumFilter;
    @BindView(R.id.btnForumSort)
    Button btnForumSort;
    private RecyclerView.OnScrollListener scrollMoreListener;
    private AdapterForumSort sortAdapter;
    String currentSortingCategory;

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        return inflater.inflate(R.layout.fragment_forum, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentForumPresenter = new FragmentForumPresenter();
        mFragmentForumPresenter.attachView(this);
        mFragmentForumPresenter.viewIsReady();
        btnForumFilter.setText(getResources().getString(R.string.filter, ""));
    }

    @Override
    public void initForumRecyclerView(List<ForumResponseBody> forumDataList) {
        forumAdapter = new ForumV2Adapter(forumDataList, mContext);
        forumAdapter.setForumItemClick(forumData -> {
            if (!Connectivity.isConnected(mContext)) {
                Toast.makeText(mContext, "Please check your internet connection!", Toast.LENGTH_SHORT).show();
                return;
            }
            Intent intent = new Intent(getActivity(), ForumCommentActivity.class);
            intent.putExtra("forum_id", forumData.getId());
            startActivityForResult(intent, 458);
        });
        LinearLayoutManager verticalLayoutManager =
                new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL, false);
        recViewForum.setLayoutManager(verticalLayoutManager);
        recViewForum.setAdapter(forumAdapter);
        scrollMoreListener = new RecyclerScrollMoreListener(verticalLayoutManager,
                new RecyclerScrollMoreListener.OnLoadMoreListener() {
                    @Override
                    public void onLoadMore(int page, int total) {
                        if (mFragmentForumPresenter != null && forumAdapter.getItemCount() > 4) {
                            mFragmentForumPresenter.onNextPage(page, total);
                        }
                    }

                    @Override
                    public int getMessagesCount() {
                        return forumAdapter.getItemCount();
                    }
                });
        recViewForum.addOnScrollListener(scrollMoreListener);

    }

    @Override
    public void addForums(List<ForumResponseBody> forums, boolean forumByFilterEnabled, boolean allChipsRemoved) {
        setForumNotification(forums);
        forumAdapter.addForums(forums, forumByFilterEnabled, allChipsRemoved);
    }

    private void setForumNotification(List<ForumResponseBody> forums) {
    }

    @Override
    public void notifyDataChange(int forumId, int messagesCount) {
        if (forumAdapter != null) {
            mContext.runOnUiThread(() -> {
                forumAdapter.setCommentsCount(forumId, messagesCount);
                forumAdapter.notifyDataSetChanged();
            });
        }
    }

    @Override
    public void initForumFilterChipsRecyclerView(List<ForumFilter> filters) {
        AdapterForumFilterChips adapterForumFilterChips = new AdapterForumFilterChips(filters);
        adapterForumFilterChips.setOnClickChipDeleteListener((category, language, filter) -> {
            mapLanguage.clear();
            mapCategory.clear();
            for (ForumFilter forumFilter : filter) {
                if (forumFilter.getType() == 1) {
                    mapLanguage.put(String.valueOf(forumFilter.getId()), forumFilter.getName());
                } else {
                    mapCategory.put(String.valueOf(forumFilter.getId()), forumFilter.getName());
                }
            }

            btnForumFilter.setText(getResources().getString(R.string.filter, adapterForumFilterChips.getItemCount() == 0 ? ""
                    : String.valueOf(adapterForumFilterChips.getItemCount())));

            resetRecView();
            if (adapterForumFilterChips.getItemCount() == 0) {
                mFragmentForumPresenter.getAllForums(language, category, "",
                        false,
                        true);
            } else {
                mFragmentForumPresenter.getAllForumsByFilter(language, category, "",
                        true,
                        false);
            }

        });
        btnForumFilter.setText(getResources().getString(R.string.filter, adapterForumFilterChips.getItemCount() == 0 ? ""
                : String.valueOf(adapterForumFilterChips.getItemCount())));
        LinearLayoutManager horizontalLayoutManager =
                new LinearLayoutManager(getActivity(), RecyclerView.HORIZONTAL, false);
        recViewChooseFilteredCategory.setLayoutManager(horizontalLayoutManager);
        recViewChooseFilteredCategory.setAdapter(adapterForumFilterChips);

    }

    private void resetRecView() {
        mFragmentForumPresenter.setPage(1);
        LinearLayoutManager layoutManager = (LinearLayoutManager) recViewForum
                .getLayoutManager();

        if (scrollMoreListener != null) {
            ((RecyclerScrollMoreListener) scrollMoreListener).setPreviousTotalItemCount(0);
        }
        if (layoutManager != null) {
            layoutManager.scrollToPositionWithOffset(0, 0);
        }
        mFragmentForumPresenter.setPage(1);
    }

    @OnClick(R.id.btnForumFilter)
    void onClickForumFilter() {
        Intent intent = new Intent(getActivity(), ForumFilterActivity.class);
        intent.putExtra("mapLanguage", mapLanguage);
        intent.putExtra("mapCategory", mapCategory);
        startActivityForResult(intent, 457);
    }

    @OnClick(R.id.btnForumSort)
    void onClickForumSort() {
        final BottomSheetDialog bottomSheetDialog = new BottomSheetDialog(getContext());

        View bottomSheetView = LayoutInflater.from(getContext())

                .inflate(R.layout.layout_bottom_sheet,

                        getView().findViewById(R.id.bottomSheetContainer));
        String newest_to_oldest = mContext.getResources().getString(R.string.newest_to_oldest);
        String oldest_to_newest = mContext.getResources().getString(R.string.oldest_to_newest);
        String relevancy = mContext.getResources().getString(R.string.relevancy);
        List<String> sortingTypes = new ArrayList<>();
        sortingTypes.add(newest_to_oldest);
        sortingTypes.add(oldest_to_newest);
        sortingTypes.add(relevancy);

        bottomSheetDialog.setContentView(bottomSheetView);
        ListView l = bottomSheetDialog.findViewById(R.id.sortListView);
        sortAdapter = new AdapterForumSort(
                getContext(),
                R.layout.adapter_sort_category,
                sortingTypes);
        l.setAdapter(sortAdapter);
        sortAdapter.setSelection(sortingTypes.indexOf(currentSortingCategory));

        l.setOnItemClickListener((adapterView, view, i, l1) -> {
            sortAdapter.setSelection(i);
            currentSortingCategory = sortingTypes.get(i);
            sortAdapter.notifyDataSetChanged();
            btnForumSort.setText(currentSortingCategory);
            bottomSheetDialog.cancel();
            resetRecView();
            Map<String, String> sortingCategory = new HashMap<>();

            if (currentSortingCategory.equals(newest_to_oldest)) {
                sortingCategory.put("published", "DESC");
            } else if (currentSortingCategory.equals(oldest_to_newest)) {
                sortingCategory.put("published", "ASC");
            } else {
                sortingCategory.put("score", "DESC");
            }
            mFragmentForumPresenter.setForumSortCategory(sortingCategory);
        });

        bottomSheetDialog.show();

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == 458 && data != null) {
            if (data.getBooleanExtra("isRated", false)) {
                resetRecView();
                mFragmentForumPresenter.viewIsReady();
            }
        } else if (resultCode == RESULT_OK && requestCode == 457 && data != null) {
            mapCategory = (HashMap<String, String>) data.getSerializableExtra("mapCategory");
            mapLanguage = (HashMap<String, String>) data.getSerializableExtra("mapLanguage");
            resetRecView();
            mFragmentForumPresenter.setForumFilterResult(mapCategory, mapLanguage);
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.onPause();
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.detachView();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mFragmentForumPresenter != null) {
            mFragmentForumPresenter.destroy();
        }
    }

    @Override
    public Application getApplication() {
        return mContext.getApplication();
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
        mContext.runOnUiThread(() -> forumLoading.setVisibility(View.VISIBLE));
    }

    @Override
    public void dismissProgress() {
        mContext.runOnUiThread(() -> forumLoading.setVisibility(View.GONE));
    }
}
