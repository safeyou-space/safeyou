package fambox.pro.presenter.basepresenter;


import android.content.Context;

public interface MvpView {

    Context getContext();

    void showErrorMessage(String message);

    void showSuccessMessage(String message);

}
