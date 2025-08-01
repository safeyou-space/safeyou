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

package com.fambox.mention.suggestions.impl;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.fambox.mention.suggestions.SuggestionsResult;
import com.fambox.mention.suggestions.interfaces.Suggestible;
import com.fambox.mention.suggestions.interfaces.SuggestionsListBuilder;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Basic implementation of the {@link SuggestionsListBuilder} interface.
 */
public class BasicSuggestionsListBuilder implements SuggestionsListBuilder {

    /**
     * {@inheritDoc}
     */
    @Override
    @NonNull
    public List<Suggestible> buildSuggestions(final @NonNull Map<String, SuggestionsResult> latestResults,
                                              final @NonNull String currentTokenString) {
        List<Suggestible> results = new ArrayList<>();
        for (Map.Entry<String, SuggestionsResult> entry : latestResults.entrySet()) {
            SuggestionsResult result = entry.getValue();
            if (currentTokenString.equalsIgnoreCase(result.getQueryToken().getTokenString())) {
                results.addAll(result.getSuggestions());
            }
        }
        return results;
    }

    /**
     * {@inheritDoc}
     */
    @NonNull
    @Override
    public View getView(final @NonNull Suggestible suggestion,
                        @Nullable View convertView,
                        @Nullable ViewGroup parent,
                        final @NonNull Context context,
                        final @NonNull LayoutInflater inflater,
                        final @NonNull Resources resources) {
        View view;
        if (convertView == null) {
            view = inflater.inflate(android.R.layout.simple_list_item_1, parent, false);
        } else {
            view = convertView;
        }

        if (view instanceof TextView) {
            TextView text = (TextView) view;
            text.setText(suggestion.getSuggestiblePrimaryText());
            text.setTextColor(Color.BLACK);
            text.setBackgroundColor(Color.WHITE);
        }

        return view;
    }

}
