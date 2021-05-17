package fambox.pro.view.adapter.holder.model;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

public class RecordModel {

    private String name;
    private String time;
    private String data;
    private String duration;

    public RecordModel(String name, String time, String data, String duration) {
        this.name = name;
        this.time = time;
        this.data = data;
        this.duration = duration;
    }

    public String getName() {
        return name;
    }

    public String getTime() {
        return time;
    }

    public String getData() {
        return data;
    }

    public String getDuration() {
        return duration;
    }

    @NonNull
    @Override
    public String toString() {
        return "RecordModel{" +
                "name='" + name + '\'' +
                ", time='" + time + '\'' +
                ", data='" + data + '\'' +
                ", duration='" + duration + '\'' +
                '}';
    }
}
