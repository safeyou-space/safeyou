package fambox.pro.view;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.view.fragment.FragmentProfile;

public class EmergencyContactActivity extends BaseActivity implements FragmentProfile.ChangeMainPageListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addAppBar(null, false,
                true, false, getResources().getString(R.string.emergency_contacts_title_key), true);

        getSupportFragmentManager().beginTransaction()
                .setReorderingAllowed(true)
                .add(R.id.container, FragmentProfile.class, null)
                .commit();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_emergency_contact;
    }


    @Override
    public void onPageChange(int page, long serviceId, boolean isSendSms) {
        Intent intent = new Intent();
        intent.putExtra("page", page);
        intent.putExtra("serviceId", serviceId);
        intent.putExtra("isSendSms", isSendSms);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }
}