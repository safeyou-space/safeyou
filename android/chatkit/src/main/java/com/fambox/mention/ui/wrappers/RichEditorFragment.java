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

package com.fambox.mention.ui.wrappers;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;

import com.fambox.chatkit.R;
import com.fambox.mention.ui.RichEditorView;

/**
 * Convenient fragment wrapper around a {@link RichEditorView}.
 */
public class RichEditorFragment extends Fragment {

    private static final String FRAGMENT_TAG = "fragment_rich_editor";

    private RichEditorView mRichEditor;
    private OnCreateViewListener mOnCreateViewListener;

    public interface OnCreateViewListener {
        void onFragmentCreateView(@NonNull com.fambox.mention.ui.wrappers.RichEditorFragment fragment);
    }

    public RichEditorFragment() {
        // Required empty public constructor
    }

    @NonNull
    public static com.fambox.mention.ui.wrappers.RichEditorFragment newInstance(@Nullable Bundle args) {
        com.fambox.mention.ui.wrappers.RichEditorFragment fragment =
                new com.fambox.mention.ui.wrappers.RichEditorFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @NonNull
    public static com.fambox.mention.ui.wrappers.RichEditorFragment getInstance(@NonNull FragmentManager fragmentManager, @Nullable Bundle args) {
        com.fambox.mention.ui.wrappers.RichEditorFragment instance;
        Fragment fragment = fragmentManager.findFragmentByTag(FRAGMENT_TAG);
        if (fragment == null) {
            instance = com.fambox.mention.ui.wrappers.RichEditorFragment.newInstance(args);
        } else {
            instance = (com.fambox.mention.ui.wrappers.RichEditorFragment) fragment;
        }
        return instance;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.editor_fragment, container, false);
        if (rootView == null) {
            return null;
        }

        mRichEditor = rootView.findViewById(R.id.rich_editor);
        if (mOnCreateViewListener != null) {
            mOnCreateViewListener.onFragmentCreateView(this);
        }

        return rootView;
    }

    @Nullable
    public RichEditorView getRichEditor() {
        return mRichEditor;
    }

    @NonNull
    public String getFragmentTag() {
        return FRAGMENT_TAG;
    }

    public void setOnCreateViewListener(@Nullable OnCreateViewListener listener) {
        mOnCreateViewListener = listener;
    }

}
