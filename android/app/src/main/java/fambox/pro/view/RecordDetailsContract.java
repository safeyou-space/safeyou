package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.widget.SeekBar;

import java.util.List;

import fambox.pro.audiowaveview.AudioWaveView;
import fambox.pro.model.BaseModel;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.Message;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.presenter.basepresenter.MvpPresenter;
import fambox.pro.presenter.basepresenter.MvpView;
import retrofit2.Response;

public interface RecordDetailsContract {
    interface View extends MvpView {

        void onVolumeChanged(AudioManager audioManager);

        void onWaveChanged(MediaPlayer mMediaPlayer);

        void setRecDuration(String duration);

        void setRecCurrentPosition(String currentPosition);

        void onPlayButtonChanged(boolean state);

        void setUpRecord(RecordResponse record);

        void showDialogSuccessSent(String name, String time, String date);

        void configMapPosition(String name, double latitude, double longitude);

        void back();

        void showProgress();

        void dismissProgress();

        void configNextPreviewsButtons(boolean isNext, boolean isPreviews);
    }

    interface Presenter extends MvpPresenter<View> {
        void initView();

        void initBundle(Bundle bundle, String countryCode, String locale);

        void onStop();

        void setUpWaveView(AudioWaveView audioWaveView);

        void setUpMediaPlayer(String path);

        void setUpMediaVolume(Activity activity, SeekBar seekBarVolume);

        void play(Activity activity);

        void pause();

        void repeat(Activity activity);

        void googleMapReady();

        void getRecord(String countryCode, String locale, long recordId);

        void sendRecord(String countryCode,String locale);

        void deleteRecord(String countryCode, String locale);

        void onClickPreview(String countryCode, String locale);

        void onClickNext(String countryCode, String locale);
    }

    interface Model extends BaseModel {
        void getSingleRecord(Context context, String countryCode, String locale,
                             long recordId,
                             NetworkCallback<Response<RecordResponse>> response);

        void getRecords(Context context, String countryCode, String locale, NetworkCallback<Response<List<RecordResponse>>> response);

        void sendMailRecord(Context context, String countryCode, String locale, long recordId,
                            String longitude, String latitude,
                            NetworkCallback<Response<Message>> response);

        void deleteRecord(Context context, String countryCode, String locale, long recordId,
                          NetworkCallback<Response<Message>> response);
    }
}
