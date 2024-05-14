package fambox.pro.utils;

import android.text.Editable;

public class EditableUtils {
    public static int getCharacterCountWithoutSpaces(Editable editable) {
        int count = 0;
        for (int i = 0; i < editable.length(); i++) {
            char c = editable.charAt(i);
            if (!Character.isWhitespace(c)) {
                count++;
            }
        }
        return count;
    }
}