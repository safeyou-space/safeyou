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

package com.fambox.mention.suggestions;

import androidx.annotation.NonNull;

import com.fambox.mention.suggestions.interfaces.Suggestible;
import com.fambox.mention.tokenization.QueryToken;

import java.util.List;

/**
 * Class representing the results of a query for suggestions.
 */
public class SuggestionsResult {

    private final QueryToken mQueryToken;
    private final List<? extends Suggestible> mSuggestions;

    public SuggestionsResult(@NonNull QueryToken queryToken,
                             @NonNull List<? extends Suggestible> suggestions) {
        mQueryToken = queryToken;
        mSuggestions = suggestions;
    }

    /**
     * Get the {@link QueryToken} used to generate the mention suggestions.
     *
     * @return a {@link QueryToken}
     */
    @NonNull
    public QueryToken getQueryToken() {
        return mQueryToken;
    }

    /**
     * Get the list of mention suggestions corresponding to the {@link QueryToken}.
     *
     * @return a List of {@link Suggestible} representing mention suggestions
     */
    @NonNull
    public List<? extends Suggestible> getSuggestions() {
        return mSuggestions;
    }
}
