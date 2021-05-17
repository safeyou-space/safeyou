package fambox.pro.audiowaveview

/**
 * Created by alex
 * Added, change chunk background color by Suren.
 */

interface OnSamplingListener {
    fun onComplete()
}

interface OnProgressListener {
    fun onStartTracking(progress: Float)
    fun onStopTracking(progress: Float)
    fun onProgressChanged(progress: Float, byUser: Boolean)
}