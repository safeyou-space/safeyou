package fambox.pro.model.fragment;

import android.content.Context;

import androidx.annotation.NonNull;

import fambox.pro.SafeYouApp;
import fambox.pro.network.NetworkCallback;
import fambox.pro.network.model.forum.ForumBase;
import fambox.pro.view.fragment.FragmentForumContract;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.observers.DisposableSingleObserver;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class FragmentForumModel implements FragmentForumContract.Model {

    private final CompositeDisposable mCompositeDisposable = new CompositeDisposable();

    @Override
    public void getAllForums(Context context, String countryCode, String locale, int page,
                             String languageFilter, String categoryFilter, String categorySort,
                             NetworkCallback<Response<ForumBase>> response) {

        mCompositeDisposable.add(SafeYouApp.getApiService(context).getAllForums(countryCode, locale, page, languageFilter, categoryFilter, categorySort)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeWith(new DisposableSingleObserver<Response<ForumBase>>() {
                    @Override
                    public void onSuccess(@NonNull Response<ForumBase> listResponse) {
                        response.onSuccess(listResponse);
                    }

                    @Override
                    public void onError(Throwable e) {
                        response.onError(e);
                    }
                }));
    }


    @Override
    public void onDestroy() {
        mCompositeDisposable.clear();
    }
}
