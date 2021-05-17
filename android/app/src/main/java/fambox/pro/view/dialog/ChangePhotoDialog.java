package fambox.pro.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import butterknife.ButterKnife;
import butterknife.OnClick;
import fambox.pro.R;

public class ChangePhotoDialog extends Dialog {

    private EditPhotoListener mEditPhotoListener;

    public ChangePhotoDialog(@NonNull Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_change_photo);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.cancelIcon)
    void closeDialog() {
        dismiss();
    }

    @OnClick(R.id.btnTakeNewPhoto)
    void takeNewPhoto() {
        if (mEditPhotoListener != null) {
            mEditPhotoListener.takeNewPhoto();
            dismiss();
        }
    }

    @OnClick(R.id.btnSelectFromGallery)
    void selectFromGallery() {
        if (mEditPhotoListener != null) {
            mEditPhotoListener.selectFromGallery();
            dismiss();
        }
    }

    @OnClick(R.id.btnRemovePhoto)
    void removePhoto() {
        if (mEditPhotoListener != null) {
            mEditPhotoListener.removePhoto();
            dismiss();
        }
    }

    public void setEditPhotoListener(EditPhotoListener editPhotoListener) {
        this.mEditPhotoListener = editPhotoListener;
    }

    public interface EditPhotoListener {
        void takeNewPhoto();

        void selectFromGallery();

        void removePhoto();
    }

}
