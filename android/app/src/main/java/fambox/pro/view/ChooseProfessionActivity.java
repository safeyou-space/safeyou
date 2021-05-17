package fambox.pro.view;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.BaseActivity;
import fambox.pro.R;
import fambox.pro.presenter.ChooseProfessionPresenter;
import fambox.pro.view.adapter.AdapterChooseProfession;

public class ChooseProfessionActivity extends BaseActivity implements ChooseProfessionContract.View {

    private ChooseProfessionPresenter mChooseProfessionPresenter;
    private AdapterChooseProfession mAdapterChooseProfession;

    @BindView(R.id.recViewProfessions)
    RecyclerView recViewProfessions;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        addAppBar(null, false,
                true, false,
                getResources().getString(R.string.field_for_expertise), true);
        mChooseProfessionPresenter = new ChooseProfessionPresenter();
        mChooseProfessionPresenter.attachView(this);
        mChooseProfessionPresenter.viewIsReady();
    }

    @Override
    public void configRecViewProfessions(List<Integer> ides, List<String> names) {
        mAdapterChooseProfession = new AdapterChooseProfession(getContext(), ides, names);
        LinearLayoutManager linearLayoutManager =
                new LinearLayoutManager(getContext(), RecyclerView.VERTICAL, false);
        recViewProfessions.setLayoutManager(linearLayoutManager);
        recViewProfessions.setHasFixedSize(true);
        recViewProfessions.setItemViewCacheSize(ides.size() - 1);
        recViewProfessions.setAdapter(mAdapterChooseProfession);
    }

    @OnClick(R.id.btnSubmit)
    void clickSubmit() {
        Intent intent = new Intent();
        intent.putExtra("consultant_id", mAdapterChooseProfession.getCategoryId());
        intent.putExtra("new_category_name", mAdapterChooseProfession.getOtherProfessionName());
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

    @OnClick(R.id.btnCancel)
    void onClickCancel() {
        onBackPressed();
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_choose_profession;
    }

    @Override
    public Context getContext() {
        return getApplicationContext();
    }

    @Override
    public void showErrorMessage(String message) {

    }

    @Override
    public void showSuccessMessage(String message) {

    }
}