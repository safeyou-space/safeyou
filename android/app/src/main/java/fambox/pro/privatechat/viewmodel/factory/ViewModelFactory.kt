package fambox.pro.privatechat.viewmodel.factory

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

class ViewModelFactory : ViewModelProvider.Factory {
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        return modelClass.getConstructor().newInstance()
    }
}