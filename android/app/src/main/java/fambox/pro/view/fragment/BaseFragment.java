package fambox.pro.view.fragment;

import static fambox.pro.Constants.CLOSED_ERROR_MESSAGE;
import static fambox.pro.Constants.UNABLE_TO_RESOLVE_HOST_MESSAGE;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;

import org.jetbrains.annotations.NotNull;

import fambox.pro.R;
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

    public void nextActivity(Context context, Class<?> clazz, int resultCode) {
        Intent intent = new Intent(context, clazz);
        startActivityForResult(intent, resultCode);
    }

    public void nextActivity(Context context, Class<?> clazz, Bundle extra) {
        Intent intent = new Intent(context, clazz);
        intent.putExtras(extra);
        startActivity(intent);
    }

    protected void message(String message, SnackBar.SBType type) {
        if (message.contains(UNABLE_TO_RESOLVE_HOST_MESSAGE)) {
            message = getString(R.string.check_internet_connection_text_key);
        } else if (message.contains(CLOSED_ERROR_MESSAGE)) {
            return;
        }
        SnackBar.make(mContext,
                mContext.findViewById(android.R.id.content),
                type,
                message).show();
    }
}