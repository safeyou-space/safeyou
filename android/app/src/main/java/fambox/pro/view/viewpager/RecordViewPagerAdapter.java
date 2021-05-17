package fambox.pro.view.viewpager;

import android.content.Context;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import org.jetbrains.annotations.NotNull;

import fambox.pro.R;
import fambox.pro.enums.RecordViewType;
import fambox.pro.view.fragment.FragmentRecords;

public class RecordViewPagerAdapter extends FragmentPagerAdapter {

    private static final Integer[] FRAGMENT_PAGE_TITLES = {R.string.all, R.string.saved, R.string.sent};
    private Context mContext;

    public RecordViewPagerAdapter(Context context, FragmentManager fm) {
        super(fm);
        this.mContext = context;
    }

    @NotNull
    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                return FragmentRecords.newInstance(RecordViewType.All);
            case 1:
                return FragmentRecords.newInstance(RecordViewType.SAVED);
            case 2:
                return FragmentRecords.newInstance(RecordViewType.SENT);
        }
        return FragmentRecords.newInstance(RecordViewType.All);
    }

    @Override
    public int getCount() {
        return 3;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mContext.getResources().getString(FRAGMENT_PAGE_TITLES[position]);
    }
}