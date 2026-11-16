package fambox.pro.view.fragment;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import fambox.pro.R;
import fambox.pro.network.model.chat.PrivateMessageUserListResponse;
import fambox.pro.presenter.fragment.FragmentPrivateMessagePresenter;
import fambox.pro.view.MainActivity;
import fambox.pro.view.adapter.AdapterPrivateMessage;

public class FragmentPrivateMessage extends BaseFragment implements FragmentPrivateMessageContract.View {
    private FragmentPrivateMessagePresenter mFragmentPrivateMessagePresenter;

    @BindView(R.id.prMessageRecyclerView)
    RecyclerView prMessageRecyclerView;
    private AdapterPrivateMessage adapterPrivateMessage;

    @Override
    protected View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_private_message, container, false);
    }

    @Override
    protected void viewCrated(View view) {
        ButterKnife.bind(this, view);
        mFragmentPrivateMessagePresenter = new FragmentPrivateMessagePresenter();
        mFragmentPrivateMessagePresenter.attachView(this);
        mFragmentPrivateMessagePresenter.viewIsReady();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mFragmentPrivateMessagePresenter != null)
            mFragmentPrivateMessagePresenter.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mFragmentPrivateMessagePresenter != null)
            mFragmentPrivateMessagePresenter.destroy();
    }

    @Override
    public void setupPrivateMessageList(List<PrivateMessageUserListResponse> listResponses) {
        adapterPrivateMessage = new AdapterPrivateMessage(getActivity(), listResponses);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity(),
                LinearLayoutManager.VERTICAL, false);
        prMessageRecyclerView.setLayoutManager(linearLayoutManager);
        prMessageRecyclerView.setAdapter(adapterPrivateMessage);
        if (getActivity() == null) {
            return;
        }
        ((MainActivity) getActivity()).getBottomPrivateNotificationIcon().setVisibility(View.INVISIBLE);
        mFragmentPrivateMessagePresenter.getUnreadPrivateMessages(listResponses);
    }

    @Override
    public void setupUnreadMessageStyles() {
        if (getActivity() == null) {
            return;
        }
        adapterPrivateMessage.notifyDataSetChanged();
        ((MainActivity) getActivity()).getBottomPrivateNotificationIcon().setVisibility(View.VISIBLE);
    }

    @Override
    public Context getAppContext() {
        return requireActivity().getApplication();
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }
}