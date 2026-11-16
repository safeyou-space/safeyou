package fambox.pro.privatechat.view

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import fambox.pro.privatechat.viewmodel.factory.ViewModelFactory
import java.lang.reflect.ParameterizedType

abstract class BaseVMActivity<VM : AbstractViewModel, B : ViewBinding> : AppCompatActivity() {

    lateinit var viewModel: VM
    lateinit var binding: B

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewModel = ViewModelProvider(this, ViewModelFactory()).get(getViewModelClass())
        binding = getViewBinding()
        setContentView(binding.root)
    }

    private fun getViewModelClass(): Class<VM> {
        val type = (javaClass.genericSuperclass as ParameterizedType).actualTypeArguments[0]
        return type as Class<VM>
    }

    abstract fun getViewBinding(): B
}