package fambox.pro.view.viewpager;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import org.jetbrains.annotations.NotNull;

import fambox.pro.view.fragment.FragmentForum;
import fambox.pro.view.fragment.FragmentHelp;
import fambox.pro.view.fragment.FragmentNetwork;
import fambox.pro.view.fragment.FragmentOther;
import fambox.pro.view.fragment.FragmentPrivateMessage;

public class MainViewPager extends FragmentPagerAdapter {

    public MainViewPager(FragmentManager fm) {
        super(fm);
    }

    @NotNull
    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                return new FragmentForum();
            case 1:
                return new FragmentNetwork();
            case 2:
                return new FragmentHelp();
            case 3:
                return new FragmentPrivateMessage();
            case 4:
                return new FragmentOther();
        }
        return new FragmentHelp();
    }

    @Override
    public int getCount() {
        return 5;
    }


}