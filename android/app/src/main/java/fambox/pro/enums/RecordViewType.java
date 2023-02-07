package fambox.pro.enums;

import androidx.annotation.IntRange;

public enum RecordViewType {

    All(0), SAVED(1), SENT(2);

    private int mType;

    RecordViewType(int type) {
        this.mType = type;
    }

    public int getType() {
        return mType;
    }

    public void setType(@IntRange(from = 0, to = 2) int mType) {
        this.mType = mType;
    }
}
