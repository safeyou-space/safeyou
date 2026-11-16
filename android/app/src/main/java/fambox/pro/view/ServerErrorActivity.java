package fambox.pro.view;

import android.os.Bundle;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;

public class ServerErrorActivity extends BaseActivity {

    public static final String KEY_SERVER_ERROR = "key_server_error";
    @BindView(R.id.txtErrorText)
    TextView txtErrorText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            txtErrorText.setText(bundle.getString(KEY_SERVER_ERROR));
        }
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_server_error;
    }

    @OnClick(R.id.btnExit)
    void onClickExit() {
        //TODO add exit functional
    }
}
