package fambox.pro.view.fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;

import org.jetbrains.annotations.NotNull;

import fambox.pro.utils.SnackBar;
import fambox.pro.view.dialog.LoadingDialog;

public abstract class BaseFragment extends Fragment {

    private FragmentActivity mContext;
    private LoadingDialog mLoadingDialog;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public View onCreateView(@NotNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanseState) {
        return fragmentView(inflater, container, savedInstanseState);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (getActivity() != null) {
            mContext = getActivity();
        }
        viewCrated(view);
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    protected abstract View fragmentView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState);

    protected abstract void viewCrated(View view);

    public void nextActivity(Context context, Class<?> clazz) {
        Intent intent = new Intent(context, clazz);
        startActivity(intent);
    }

    public void nextActivity(Context context, Class<?> clazz, Bundle extra) {
        Intent intent = new Intent(context, clazz);
        intent.putExtras(extra);
        startActivity(intent);
    }

    protected void message(String message, SnackBar.SBType type) {
        SnackBar.make(mContext,
                mContext.findViewById(android.R.id.content),
                type,
                message).show();
    }

    public void showProgressBase() {
        if (mLoadingDialog != null) {
            mLoadingDialog.dismiss();
            mLoadingDialog = null;
        }
        mLoadingDialog = new LoadingDialog(mContext);
        mLoadingDialog.setOnKeyListener((arg0, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                mContext.onBackPressed();
                dismissProgressBase();
            }
            return true;
        });
        if (!mLoadingDialog.isShowing()) {
            mLoadingDialog.show();
        }
    }

    public void dismissProgressBase() {
        if (mLoadingDialog != null) {
            if (mLoadingDialog.isShowing()) {
                mLoadingDialog.dismiss();
            }
        }
    }
}