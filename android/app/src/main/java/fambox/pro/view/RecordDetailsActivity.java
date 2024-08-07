package fambox.pro.view;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.ToggleButton;

import androidx.appcompat.app.AlertDialog;
import androidx.core.content.ContextCompat;

import org.osmdroid.config.Configuration;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.Marker;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.BuildConfig;
import fambox.pro.LocaleHelper;
import fambox.pro.R;
import fambox.pro.audiowaveview.AudioWaveView;
import fambox.pro.audiowaveview.OnProgressListener;
import fambox.pro.enums.Types;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.presenter.RecordDetailsPresenter;
import fambox.pro.utils.SnackBar;
import fambox.pro.utils.Utils;
import fambox.pro.view.dialog.RecordInfoDialog;

public class RecordDetailsActivity extends BaseActivity implements RecordDetailsContract.View {

    @BindView(R.id.audioWaveView)
    AudioWaveView waveView;
    @BindView(R.id.recDurationStart)
    TextView recDurationStart;
    @BindView(R.id.recDurationEnd)
    TextView recDurationEnd;
    @BindView(R.id.delete)
    TextView delete;
    @BindView(R.id.shareRecord)
    ImageView shareRecord;
    @BindView(R.id.seekBarVolume)
    SeekBar seekBarVolume;
    @BindView(R.id.prev)
    ImageView prev;
    @BindView(R.id.play)
    ToggleButton play;
    @BindView(R.id.next)
    ImageView next;
    @BindView(R.id.recTitle)
    TextView recTitle;
    @BindView(R.id.recTime)
    TextView recTime;
    @BindView(R.id.recData)
    TextView recData;
    @BindView(R.id.recDuration)
    TextView recDuration;
    @BindView(R.id.map)
    MapView map;

    private RecordDetailsPresenter mRecordDetailsPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // change status bar color api level 6.0 and above.
        Utils.setStatusBarColor(this, Types.StatusBarConfigType.CLOCK_WHITE_STATUS_BAR_PURPLE_DARK);
        addAppBar(getResources().getString(R.string.recording_title_key), false, true, false, null, true);
        // initialize ButterKnife for this activity.
        ButterKnife.bind(this);
        mRecordDetailsPresenter = new RecordDetailsPresenter();
        mRecordDetailsPresenter.attachView(this);
        mRecordDetailsPresenter.initView();
        mRecordDetailsPresenter.setUpMediaVolume(this, seekBarVolume);
        mRecordDetailsPresenter.initBundle(getIntent().getExtras(), getCountryCode(), getLocale());

    }

    @Override
    protected int getLayout() {
        return R.layout.activity_record_details;
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (map != null) {
            map.onResume();
        }
        showProgress();
        if (mRecordDetailsPresenter != null) {
            mRecordDetailsPresenter.viewIsReady();
            mRecordDetailsPresenter.setUpWaveView(waveView);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (map != null) {
            map.onPause();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (mRecordDetailsPresenter != null) {
            mRecordDetailsPresenter.onStop();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mRecordDetailsPresenter != null) {
            mRecordDetailsPresenter.destroy();
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mRecordDetailsPresenter != null) {
            mRecordDetailsPresenter.detachView();
        }
    }

    @Override
    public void back() {
        onBackPressed();
    }

    @OnCheckedChanged(R.id.play)
    void playRecord(boolean checked) {
        if (checked) {
            mRecordDetailsPresenter.play(this);
        } else {
            mRecordDetailsPresenter.pause();
        }
    }

    @OnClick(R.id.delete)
    void deleteRecord() {
        AlertDialog.Builder ad = new AlertDialog.Builder(this);
        ad.setTitle(getResources().getString(R.string.delete_record));
        ad.setMessage(getResources().getString(R.string.do_you_wont_delete_record));
        ad.setPositiveButton(R.string.yes, (dialogInterface, i) ->
                mRecordDetailsPresenter.deleteRecord(getCountryCode(), LocaleHelper.getLanguage(getContext())));
        ad.setNegativeButton(R.string.no, (dialogInterface, i) -> dialogInterface.dismiss());
        if (!ad.create().isShowing())
            ad.create().show();
    }

    @OnClick(R.id.shareRecord)
    void shareRecord() {
        mRecordDetailsPresenter.sendRecord(getCountryCode(), LocaleHelper.getLanguage(getContext()));
    }

    @Override
    public Context getContext() {
        return this;
    }

    @Override
    public void onVolumeChanged(AudioManager audioManager) {
        seekBarVolume.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (audioManager != null && fromUser) {
                    audioManager.setStreamVolume(AudioManager.STREAM_MUSIC,
                            progress, 0);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }

    @Override
    public void onWaveChanged(MediaPlayer mMediaPlayer) {
        waveView.setOnProgressListener(new OnProgressListener() {
            @Override
            public void onStartTracking(float progress) {
            }

            @Override
            public void onStopTracking(float progress) {
            }

            @Override
            public void onProgressChanged(float progress, boolean byUser) {
                if (mMediaPlayer != null && byUser) {
                    mMediaPlayer.seekTo((int) Utils.percentageCalculator(
                            (int) progress,
                            mMediaPlayer.getDuration(),
                            Utils.PercentageType.PERCENTAGE_TO_NUMBER));
                }
            }
        });
    }

    @Override
    public void setRecDuration(String duration) {
        recDurationStart.setText(duration);
    }

    @Override
    public void setRecCurrentPosition(String currentPosition) {
        recDurationEnd.setText(currentPosition);
    }

    @Override
    public void setUpRecord(RecordResponse record) {
        recData.setText(record.getDate());
        recDuration.setText(Utils.millisecondsToMinute(record.getDuration() * 1000));
        if (record.getTime() != null) {
            String time = getResources()
                    .getString(R.string.time_text_key) + record.getTime()
                    .substring(0, record.getTime().lastIndexOf(":"));
            recTime.setText(time);
        }
        recTitle.setText(record.getLocation());
    }

    @Override
    public void configMapPosition(String name, double latitude, double longitude) {
        if (map != null) {
            Configuration.getInstance().setUserAgentValue(BuildConfig.APPLICATION_ID);
            map.setTileSource(TileSourceFactory.MAPNIK);
            map.setMultiTouchControls(true);
            Marker marker = new Marker(map);
            GeoPoint point = new GeoPoint(latitude, longitude);
            marker.setPosition(point);
            marker.setTitle(name);
            map.getOverlays().add(marker);
            map.getController().setZoom(18.0);
            map.getController().setCenter(point);
        } else {
            showErrorMessage(getResources().getString(R.string.map_not_ready));
        }
    }

    @Override
    public void showDialogSuccessSent(String name, String time, String date) {
        RecordInfoDialog recordInfoDialog = new RecordInfoDialog(this, RecordInfoDialog.DIALOG_TYPE_SENT);
        if (recordInfoDialog.getWindow() != null) {
            recordInfoDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        }
        recordInfoDialog.setSentActionMessages(getResources().getString(R.string.record_was_successfully_sent_text_key),
                name, time, date);
        if (!recordInfoDialog.isShowing()) {
            recordInfoDialog.show();
        }
    }

    @Override
    public void onPlayButtonChanged(boolean state) {
        play.setChecked(state);
        play.setContentDescription(getString(R.string.play_icon_description));
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
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.VISIBLE));
        } catch (Exception ignore) {
        }
    }

    @Override
    public void dismissProgress() {
        try {
            runOnUiThread(() -> findViewById(R.id.progressView).setVisibility(View.GONE));
        } catch (Exception ignore) {
        }
    }

//    @Override
//    public boolean onMarkerClick(Marker marker) {
//        return false;
//    }
//
//    @Override
//    public void onMapReady(GoogleMap googleMap) {
//        map = googleMap;
//        map.setOnMarkerClickListener(this);
//        mRecordDetailsPresenter.googleMapReady();
//    }

    @OnClick(R.id.prev)
    void onClickPreviews() {
        mRecordDetailsPresenter.onClickPreview(getCountryCode(), getLocale());
    }

    @OnClick(R.id.next)
    void onClickNext() {
        mRecordDetailsPresenter.onClickNext(getCountryCode(), getLocale());
    }

    @Override
    public void configNextPreviewsButtons(boolean isNext, boolean isPreviews) {
        next.setClickable(isNext);
        prev.setClickable(isPreviews);
        next.setColorFilter(ContextCompat.getColor(this, isNext ? R.color.black : R.color.gray),
                android.graphics.PorterDuff.Mode.SRC_IN);
        prev.setColorFilter(ContextCompat.getColor(this, isPreviews ? R.color.black : R.color.gray),
                android.graphics.PorterDuff.Mode.SRC_IN);
    }
}
