package fambox.pro.network;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import io.reactivex.Observable;
import io.reactivex.subjects.PublishSubject;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import okio.BufferedSink;

public class ProgressRequestBodyObservable extends RequestBody {

    public enum RequestBodyMediaType {

        AUDIO("audio/*"), IMAGE("image/*"), TEXT("text/plain");
        private String type;

        RequestBodyMediaType(String type) {
            this.type = type;
        }

        public String getType() {
            return type;
        }
    }

    private File file;
    private int ignoreFirstNumberOfWriteToCalls;
    private int numWriteToCalls;
    private PublishSubject<Float> floatPublishSubject = PublishSubject.create();
    private RequestBodyMediaType mediaType;

    public ProgressRequestBodyObservable(File file, RequestBodyMediaType mediaType) {
        this.file = file;
        this.mediaType = mediaType;
        ignoreFirstNumberOfWriteToCalls = 0;
    }

    public Observable<Float> getProgressSubject() {
        return floatPublishSubject;
    }

    @Override
    public MediaType contentType() {
        return MediaType.parse(mediaType.getType());
    }

    @Override
    public long contentLength() {
        return file.length();
    }


    @Override
    public void writeTo(@NonNull BufferedSink sink) throws IOException {
        numWriteToCalls++;
        float fileLength = file.length();
        byte[] buffer = new byte[2048];

        try (FileInputStream in = new FileInputStream(file)) {
            float uploaded = 0;
            int read;
            read = in.read(buffer);
            float lastProgressPercentUpdate = 0;
            while (read != -1) {

                uploaded += read;
                sink.write(buffer, 0, read);
                read = in.read(buffer);

                // when using HttpLoggingInterceptor it calls writeTo and passes data into a local buffer just for logging purposes.
                // the second call to write to is the progress we actually want to track
                if (numWriteToCalls > ignoreFirstNumberOfWriteToCalls) {
                    float progress = (uploaded / fileLength) * 100;
                    //prevent publishing too many updates, which slows upload, by checking if the upload has progressed by at least 1 percent
                    if (progress - lastProgressPercentUpdate > 1 || progress == 100f) {
                        // publish progress
                        floatPublishSubject.onNext(progress);
                        lastProgressPercentUpdate = progress;
                    }
                }
            }
        }
    }
}
