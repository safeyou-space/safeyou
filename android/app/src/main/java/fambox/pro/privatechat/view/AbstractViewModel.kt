package fambox.pro.privatechat.view

import android.app.Application
import androidx.lifecycle.ViewModel

abstract class AbstractViewModel : ViewModel() {
    abstract fun attach(application: Application)
    abstract fun detach()
}