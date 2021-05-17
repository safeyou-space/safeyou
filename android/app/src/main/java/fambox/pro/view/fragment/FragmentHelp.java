package fambox.pro.view.fragment;

import android.Manifest;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Chronometer;
import android.widget.ImageButton;
import android.widget.ProgressBar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;

import com.nabinbhandari.android.permissions.PermissionHandler;
import com.nabinbhandari.android.permissions.Permissions;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.audiorecordservice.AudioRecordService;
import fambox.pro.enums.Types;
import fambox.pro.presenter.fragment.FragmentHelpPresenter;
import fambox.pro.utils.ContinuousLongClick;
import fambox.pro.utils.SnackBar;
import fambox.pro.view.MainActivity;
import fambox.pro.view.RecordActivity;
import fambox.pro.view.dialog.RecordInfoDialog;

public class FragmentHelp extends Fragment implements FragmentHelpContract.View,
        AudioRecordService.ServiceCallback {

    private FragmentHelpPresenter mFragmentHelpPresenter;
    private FragmentActivity mContext;
    /**
     * This field for pass data to {@link fambox.pro.view.MainActivity}.
     * For change app bar title.
     */
    private PassData mPassData;

    private AudioRecordService mAudioRecordService;

    private boolean mBound = false;
    /**
     * Callbacks for service binding, passed to bindService()
     */
    private ServiceConnection serviceConnection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className, IBinder service) {
            // cast the IBinder and get MyService instance
            AudioRecordService.LocalBinder binder = (AudioRecordService.LocalBinder) service;
            mAudioRecordService = binder.getService();
            mAudioRecordService.setServiceCallback(FragmentHelp.this);
            mBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            mBound = false;
        }
    };

    private ContinuousLongClick.ContinuousLongClickListener mContinuousLongClickListener
            = new ContinuousLongClick.ContinuousLongClickListener() {
        @Override
        public void onStartLongClick(View view) {

            String[] permissions = {Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.RECORD_AUDIO};
            Permissions.check(mContext, permissions, null, null,
                    new PermissionHandler() {
                        @Override
                        public void onGranted() {
                            if (mFragmentHelpPresenter != null) {
                                mFragmentHelpPresenter.setupGPS();
                            }
                        }

                        @Override
                        public void onDenied(Context context, ArrayList<String> deniedPermissions) {
//                            mFragmentHelpPresenter.sendHelpMessage(mContext.getApplicationContext(),
//                                    ((BaseActivity) mContext).getCountryCode(),
//                                    ((BaseActivity) mContext).getLocale());
                        }
                    });
        }

        @Override
        public void onEndLongClick(View view) {
            mFragmentHelpPresenter.stopTimerCountDown();
        }
    };

    @BindView(R.id.recordProgress)
    ProgressBar recordProgress;
    @BindView(R.id.pushButton)
    Button pushButton;
    @BindView(R.id.chronometer)
    Chronometer chronometer;
    @BindView(R.id.containerCancelSend)
    ConstraintLayout containerCancelSend;
    @BindView(R.id.containerMoreInfoRecList)
    ConstraintLayout containerMoreInfoRecList;
    @BindView(R.id.btnMoreInfo)
    ImageButton btnMoreInfo;
    @BindView(R.id.btnRecList)
    ImageButton btnRecList;
    @BindView(R.id.btnCancel)
    ImageButton btnCancel;
    @BindView(R.id.btnSend)
    ImageButton btnSend;

    @Override
    public View onCreateView(
            @NotNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (getActivity() != null) {
            mContext = getActivity();
        }
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_help, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        // init ButterKnife.
        ButterKnife.bind(this, view);

        mFragmentHelpPresenter = new FragmentHelpPresenter();
        mFragmentHelpPresenter.attachView(this);
        mFragmentHelpPresenter.viewIsReady();
        String locale = getResources().getConfiguration().locale.getLanguage();
        if (Objects.equals(locale, "en")) {
            pushButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimension(R.dimen._27ssp));
        } else {
            pushButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimension(R.dimen._22ssp));
        }
    }

    @Override
    public void setUserVisibleHint(boolean visible) {
        super.setUserVisibleHint(visible);
        if (visible && isResumed()) {
            onResume();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (!getUserVisibleHint()) {
            return;
        }
        mFragmentHelpPresenter.setUpDialogPopup(((MainActivity) mContext).getCountryCode(),
                getResources().getConfiguration().locale.getLanguage());
    }

    @Override
    public void onAttach(@NotNull Context context) {
        super.onAttach(context);
        if (context instanceof PassData) {
            mPassData = (PassData) context;
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        // bind to Service
        Intent intent = new Intent(mContext, AudioRecordService.class);
        mContext.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void onStop() {
        super.onStop();
        if (mBound) {
            mContext.unbindService(serviceConnection);
            mBound = false;
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mPassData = null;
    }

    @Override
    public void setUpPushButton() {
        new ContinuousLongClick(pushButton, mContinuousLongClickListener);
        pushButton.setOnClickListener(v -> mFragmentHelpPresenter.stopRecording());
    }

    @OnClick(R.id.btnMoreInfo)
    void onClickMoreInfo() {
        mFragmentHelpPresenter.getAllServices(((BaseActivity) mContext).getCountryCode(),
                ((BaseActivity) mContext).getLocale());
    }

    @OnClick(R.id.btnRecList)
    void onClickRecList() {
        startActivity(new Intent(getActivity(), RecordActivity.class));
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        chronometer.stop();
        if (mPassData != null) {
            mPassData.onScreenDimmer(View.GONE);
        }
        mFragmentHelpPresenter.configSentCancelButtons();
        mAudioRecordService.cancelRecord();
    }

    @OnClick(R.id.btnSend)
    void onClickSend() {
        mAudioRecordService.sentRecord();
        chronometer.stop();
        if (mPassData != null) {
            mPassData.onScreenDimmer(View.GONE);
        }
        mFragmentHelpPresenter.configSentCancelButtons();
    }

    @Override
    public void setInfoDialogData(String text) {
        RecordInfoDialog recordInfoDialog =
                new RecordInfoDialog(mContext, RecordInfoDialog.DIALOG_TYPE_HELP_INFO);
        if (recordInfoDialog.getWindow() != null) {
            recordInfoDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        if (getActivity() != null)
            recordInfoDialog.setDialogTitle(getActivity().getResources().getString(R.string.the_alert_message));

        recordInfoDialog.setHelpInfoText("",
                getString(R.string.rec_info_dialog_info), text);

        if (!recordInfoDialog.isShowing()) {
            recordInfoDialog.show();
        }
    }

    @Override
    public void setRecordTimeCounterVisibility(int visibility) {
        chronometer.setVisibility(visibility);
    }

    @Override
    public void setContainerMoreInfoRecListVisibility(int visibility) {
        containerMoreInfoRecList.setVisibility(visibility);
    }

    @Override
    public void setContainerCancelSend(int visibility) {
        containerCancelSend.setVisibility(visibility);
    }

    @Override
    public void setAppBarTextChange() {
        if (mPassData != null) {
            if (getActivity() != null)
                mPassData.onAppBarTextChange(getActivity().getResources().getString(R.string.help_lowercase));
        }
    }

    @Override
    public void startRecord() {
        mFragmentHelpPresenter.sendHelpMessage(mContext.getApplicationContext(), ((BaseActivity) mContext).getCountryCode(),
                ((BaseActivity) mContext).getLocale());
        chronometer.setBase(SystemClock.elapsedRealtime());
        chronometer.start();
        if (mPassData != null) {
            mPassData.onAppBarTextChange(mContext.getResources().getString(R.string.help_lowercase));
            mPassData.onScreenDimmer(View.VISIBLE);
        }
        mContext.startService(new Intent(mContext, AudioRecordService.class));
    }

    @Override
    public void onSmsSend() {
        RecordInfoDialog recordInfoDialog = new RecordInfoDialog(mContext, RecordInfoDialog.DIALOG_TYPE_SMS_SEND);
        if (recordInfoDialog.getWindow() != null) {
            recordInfoDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        recordInfoDialog.setDialogTitle(mContext.getResources().getString(R.string.allert_message_successfully_send));
        if (!recordInfoDialog.isShowing()) {
            recordInfoDialog.show();
        }
    }

    @Override
    public void stopRecord() {
        // stop recording into AudioRecordService.class
        mAudioRecordService.stopRecording(false);
        chronometer.stop();
        if (mPassData != null) {
            mPassData.onScreenDimmer(View.GONE);
        }
    }

    @Override
    public void setOnClickPushButton() {
        pushButton.setOnLongClickListener(null);
        new ContinuousLongClick(pushButton, null);
    }

    @Override
    public void setProgressVisibility(int visibility) {
        recordProgress.setVisibility(visibility);
    }

    @Override
    public void changePushButtonBackground(Types.RecordButtonType recordButtonType, int time) {
        pushButton.setBackgroundResource(recordButtonType.getRecId());
        switch (recordButtonType) {
            case PUSH_HOLD:
                pushButton.setText(mContext.getResources().getString(R.string.push_hold));
                break;
            case COUNT_DOWN:
                pushButton.setText(String.valueOf(time));
                break;
            case STOP_RECORD:
                pushButton.setText(mContext.getResources().getString(R.string.stop_record));
                break;
        }
    }

    @Override
    public void onLocationSuccessEnable() {
        mFragmentHelpPresenter.startTimerCountDown(recordProgress);
        if (mPassData != null)
            mPassData.onAppBarTextChange("");
    }

    @Override
    public void onFileSuccessSend() {
        new ContinuousLongClick(pushButton, mContinuousLongClickListener);
    }

    @Override
    public void onRecordSaved() {
        RecordInfoDialog recordInfoDialog = new RecordInfoDialog(mContext, RecordInfoDialog.DIALOG_TYPE_SMS_SEND);
        if (recordInfoDialog.getWindow() != null) {
            recordInfoDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        recordInfoDialog.setDialogTitle(mContext.getResources().getString(R.string.record_was_successful_saved));
        if (!recordInfoDialog.isShowing()) {
            recordInfoDialog.show();
        }
    }

    @Override
    public void onRecordSent(String name, String time, String date) {
        RecordInfoDialog recordInfoDialog = new RecordInfoDialog(mContext, RecordInfoDialog.DIALOG_TYPE_SENT);
        if (recordInfoDialog.getWindow() != null) {
            recordInfoDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        recordInfoDialog.setSentActionMessages(mContext.getResources()
                .getString(R.string.recording_was_sent_successfully), name, time, date);
        if (!recordInfoDialog.isShowing()) {
            recordInfoDialog.show();
        }
    }

    @Override
    public FragmentActivity getActivityContext() {
        return mContext;
    }

    @Override
    public void showErrorMessage(String message) {
        SnackBar.make(mContext,
                mContext.findViewById(android.R.id.content),
                SnackBar.SBType.ERROR,
                message).show();
    }

    @Override
    public void showSuccessMessage(String message) {
        SnackBar.make(mContext,
                mContext.findViewById(android.R.id.content),
                SnackBar.SBType.SUCCESS,
                message).show();
    }

    @Override
    public void endRecord() {
        mFragmentHelpPresenter.stopRecording();
        chronometer.stop();
        if (mPassData != null) {
            mPassData.onScreenDimmer(View.GONE);
        }
    }

    public interface PassData {
        void onAppBarTextChange(String text);

        void onScreenDimmer(int visibility);
    }
}
