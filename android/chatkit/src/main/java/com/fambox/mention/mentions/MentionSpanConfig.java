/*
* Copyright 2015 LinkedIn Corp. All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*/

package com.fambox.mention.mentions;

import android.graphics.Color;

import androidx.annotation.ColorInt;
import androidx.annotation.NonNull;

import com.fambox.mention.mentions.MentionSpan;

/**
 * Class used to configure various options for the {@link MentionSpan}. Instantiate using the
 * {@link com.fambox.mention.mentions.MentionSpanConfig.Builder} class.
 */
public class MentionSpanConfig {

    @ColorInt public final int NORMAL_TEXT_COLOR;
    @ColorInt public final int NORMAL_TEXT_BACKGROUND_COLOR;
    @ColorInt public final int SELECTED_TEXT_COLOR;
    @ColorInt public final int SELECTED_TEXT_BACKGROUND_COLOR;

    MentionSpanConfig(@ColorInt final int normalTextColor,
                      @ColorInt final int normalTextBackgroundColor,
                      @ColorInt final int selectedTextColor,
                      @ColorInt final int selectedTextBackgroundColor) {
        this.NORMAL_TEXT_COLOR = normalTextColor;
        this.NORMAL_TEXT_BACKGROUND_COLOR = normalTextBackgroundColor;
        this.SELECTED_TEXT_COLOR = selectedTextColor;
        this.SELECTED_TEXT_BACKGROUND_COLOR = selectedTextBackgroundColor;
    }

    public static class Builder {

        // Default colors
        @ColorInt private int normalTextColor = Color.parseColor("#00a0dc");
        @ColorInt private int normalTextBackgroundColor = Color.TRANSPARENT;
        @ColorInt private int selectedTextColor = Color.WHITE;
        @ColorInt private int selectedTextBackgroundColor = Color.parseColor("#0077b5");

        @NonNull
        public Builder setMentionTextColor(@ColorInt int normalTextColor) {
            if (normalTextColor != -1) {
                this.normalTextColor = normalTextColor;
            }
            return this;
        }

        @NonNull
        public Builder setMentionTextBackgroundColor(@ColorInt int normalTextBackgroundColor) {
            if (normalTextBackgroundColor != -1) {
                this.normalTextBackgroundColor = normalTextBackgroundColor;
            }
            return this;
        }

        @NonNull
        public Builder setSelectedMentionTextColor(@ColorInt int selectedTextColor) {
            if (selectedTextColor != -1) {
                this.selectedTextColor = selectedTextColor;
            }
            return this;
        }

        @NonNull
        public Builder setSelectedMentionTextBackgroundColor(@ColorInt int selectedTextBackgroundColor) {
            if (selectedTextBackgroundColor != -1) {
                this.selectedTextBackgroundColor = selectedTextBackgroundColor;
            }
            return this;
        }

        @NonNull
        public com.fambox.mention.mentions.MentionSpanConfig build() {
            return new com.fambox.mention.mentions.MentionSpanConfig(normalTextColor, normalTextBackgroundColor,
                                         selectedTextColor, selectedTextBackgroundColor);
        }
    }
}
