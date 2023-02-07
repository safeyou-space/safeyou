package fambox.pro.utils;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;

import fambox.pro.Constants;
import fambox.pro.Four;
import fambox.pro.One;
import fambox.pro.SafeYouApp;
import fambox.pro.Three;
import fambox.pro.Two;

public class PackageManagerUtil {
    public static void changeAppIcon(Context context,
                                     boolean isCamouflageIconEnabled,
                                     boolean isArtGallerySelected,
                                     boolean isGalleryEditSelected,
                                     boolean isPhotoEditorSelected) {
        if (isCamouflageIconEnabled) {
            change(context, false, isArtGallerySelected, isGalleryEditSelected, isPhotoEditorSelected);
            SafeYouApp.getPreference(context).setValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, true);
        } else {
            change(context, true, false, false, false);
            SafeYouApp.getPreference(context).setValue(Constants.Key.KEY_IS_CAMOUFLAGE_ICON_ENABLED, false);
        }
    }

    private static void change(Context context,
                               boolean isDefaultIconSelected,
                               boolean isArtGallerySelected,
                               boolean isGalleryEditSelected,
                               boolean isPhotoEditorSelected) {
        int defaultAppState = isDefaultIconSelected ? PackageManager.COMPONENT_ENABLED_STATE_ENABLED : PackageManager.COMPONENT_ENABLED_STATE_DISABLED;
        int isArtGalleryEnabled = isArtGallerySelected ? PackageManager.COMPONENT_ENABLED_STATE_ENABLED : PackageManager.COMPONENT_ENABLED_STATE_DISABLED;
        int isGalleryEditEnabled = isGalleryEditSelected ? PackageManager.COMPONENT_ENABLED_STATE_ENABLED : PackageManager.COMPONENT_ENABLED_STATE_DISABLED;
        int isPhotoEditorEnabled = isPhotoEditorSelected ? PackageManager.COMPONENT_ENABLED_STATE_ENABLED : PackageManager.COMPONENT_ENABLED_STATE_DISABLED;

        SafeYouApp.getPreference(context).setValue(Constants.Key.KEY_IS_ART_GALLERY_ENABLED, isArtGallerySelected);
        SafeYouApp.getPreference(context).setValue(Constants.Key.KEY_IS_GALLERY_EDIT_ENABLED, isGalleryEditSelected);
        SafeYouApp.getPreference(context).setValue(Constants.Key.KEY_IS_PHOTO_EDITOR_ENABLED, isPhotoEditorSelected);

        componentEnabledSetting(context, defaultAppState, One.class);
        componentEnabledSetting(context, isArtGalleryEnabled, Two.class);
        componentEnabledSetting(context, isGalleryEditEnabled, Three.class);
        componentEnabledSetting(context, isPhotoEditorEnabled, Four.class);
    }

    private static void componentEnabledSetting(Context context, int appState, Class<?> clazz) {
        context.getPackageManager().setComponentEnabledSetting(
                new ComponentName("fambox.pro", "fambox.pro."
                        + clazz.getSimpleName()), appState, PackageManager.DONT_KILL_APP);
    }
}
