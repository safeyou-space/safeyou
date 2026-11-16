package fambox.pro.view.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import fambox.pro.R;
import fambox.pro.network.model.RecordResponse;
import fambox.pro.utils.Utils;
import fambox.pro.view.adapter.holder.RecordsHolder;

public class RecordsAdapter extends RecyclerView.Adapter<RecordsHolder> {
    private final Context mContext;
    private final int mRecordType;
    private final List<RecordResponse> mRecordModels;
    private RecordHolderClick mRecordHolderClick;
    private final ArrayList<Integer> recordIds = new ArrayList<>();

    public RecordsAdapter(@IntRange(from = 0, to = 2) int recordType, Context context, List<RecordResponse> mRecordModels) {
        this.mRecordType = recordType;
        this.mContext = context;
        this.mRecordModels = mRecordModels;
        for (RecordResponse recordResponse : mRecordModels) {
            recordIds.add((int) recordResponse.getId());
        }
    }

    @NonNull
    @Override
    public RecordsHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.adapter_records, parent, false);
        return new RecordsHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull RecordsHolder holder, int position) {
        holder.itemView.setContentDescription(String.format(mContext.getString(R.string.recording_description), position + 1));
        holder.getRecTitle().setText(mRecordModels.get(position).getLocation());
        if (mRecordModels.get(position).getTime() != null) {
            String time = mContext.getResources()
                    .getString(R.string.time_text_key) + mRecordModels.get(position).getTime()
                    .substring(0, mRecordModels.get(position).getTime().lastIndexOf(":"));
            holder.getRecTime().setText(time);
        }
        holder.getRecData().setText(mRecordModels.get(position).getDate());
        holder.getRecDuration().setText(Utils.millisecondsToMinute(mRecordModels.get(position).getDuration() * 1000));
        int isSent = mRecordModels.get(position).getIs_sent();
        switch (mRecordType) {
            case 0:
            case 2:
                holder.getRecShare().setVisibility(View.VISIBLE);
                break;
            case 1:
                holder.getRecShare().setVisibility(View.GONE);
                break;
        }
        switch (isSent) {
            case 0:
                holder.getRecShare().setVisibility(View.GONE);
                break;
            case 1:
                holder.getRecShare().setVisibility(View.VISIBLE);
                break;
        }

        holder.itemView.setOnClickListener(v -> {
            if (mRecordHolderClick != null) {
                mRecordHolderClick.onRecordClick(recordIds, mRecordModels.get(position));
            }
        });
    }

    @Override
    public int getItemCount() {
        return mRecordModels == null ? 0 : mRecordModels.size();
    }

    public void setRecordHolderClick(RecordHolderClick recordHolderClick) {
        this.mRecordHolderClick = recordHolderClick;
    }

    public interface RecordHolderClick {
        void onRecordClick(ArrayList<Integer> recordIds, RecordResponse item);
    }
}
