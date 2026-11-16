/*******************************************************************************
 * Copyright 2016 stfalcon.com
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

package com.fambox.chatkit.messages;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.SystemClock;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.Chronometer;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.view.ViewCompat;

import com.fambox.chatkit.R;
import com.fambox.mention.ui.MentionsEditText;
import com.makeramen.roundedimageview.RoundedImageView;

import java.io.File;
import java.lang.reflect.Field;

/**
 * Component for input outcoming messages
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class MessageInput extends RelativeLayout
        implements View.OnClickListener, TextWatcher, View.OnFocusChangeListener {

    protected MentionsEditText messageInput;
    protected ImageButton messageSendButton;
    protected ImageButton attachmentButton;
    protected ImageButton recordButton;
    protected ImageButton takePictureButton;
    protected ImageButton deleteAudio;
    protected ImageButton removeImage;
    protected ConstraintLayout replyContainer;
    protected ConstraintLayout containerRecordAudio;
    protected ConstraintLayout selectImageContainer;
    protected TextView replyUserName;
    protected TextView replyContent;
    protected TextView recordingDuration;
    protected ImageView replyClose;
    protected RoundedImageView selectedImage;
    protected Chronometer recordChronometer;
    private boolean isAudioRecordButtonVisible = true;
//    protected Space sendButtonSpace, attachmentButtonSpace;

    private CharSequence input;
    private InputListener inputListener;
    private AttachmentsListener attachmentsListener;
    private boolean isTyping;
    private TypingListener typingListener;
    private int delayTypingStatusMillis;
    private final Runnable typingTimerRunnable = new Runnable() {
        @Override
        public void run() {
            if (isTyping) {
                isTyping = false;
                if (typingListener != null) typingListener.onStopTyping();
            }
        }
    };
    private boolean lastFocus;

    public MessageInput(Context context) {
        super(context);
        init(context);
    }

    public MessageInput(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public MessageInput(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context, attrs);
    }

    /**
     * Sets callback for 'submit' button.
     *
     * @param inputListener input callback
     */
    public void setInputListener(InputListener inputListener) {
        this.inputListener = inputListener;
    }

    /**
     * Sets callback for 'add' button.
     *
     * @param attachmentsListener input callback
     */
    public void setAttachmentsListener(AttachmentsListener attachmentsListener) {
        this.attachmentsListener = attachmentsListener;
    }

    /**
     * Returns EditText for messages input
     *
     * @return EditText
     */
    public MentionsEditText getInputEditText() {
        return messageInput;
    }

    /**
     * Returns `submit` button
     *
     * @return ImageButton
     */
    public ImageButton getButton() {
        return messageSendButton;
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.messageSendButton) {
            boolean isSubmitted = onSubmit();
            if (isSubmitted) {
                messageInput.setText("");
                replyContainer.setVisibility(GONE);
                replyUserName.setText("");
                replyContent.setText("");
                containerRecordAudio.setVisibility(GONE);
                messageInput.setVisibility(VISIBLE);
                takePictureButton.setVisibility(VISIBLE);
                attachmentButton.setVisibility(VISIBLE);
                messageSendButton.setVisibility(GONE);
                recordChronometer.stop();
                recordButton.setEnabled(true);
                selectImageContainer.setVisibility(GONE);
            }
            removeCallbacks(typingTimerRunnable);
            post(typingTimerRunnable);
        } else if (id == R.id.attachmentButton) {
            onAddAttachments();
        } else if (id == R.id.takePicture) {
            if (attachmentsListener != null) attachmentsListener.onAddTakePhoto();
        } else if (id == R.id.replyClose) {
            replyContainer.setVisibility(GONE);
            replyUserName.setText("");
            replyContent.setText("");
            if (attachmentsListener != null) attachmentsListener.onClickClose();
        } else if (id == R.id.deleteAudio) {
            containerRecordAudio.setVisibility(GONE);
            messageInput.setVisibility(VISIBLE);
            takePictureButton.setVisibility(VISIBLE);
            attachmentButton.setVisibility(VISIBLE);
            messageSendButton.setVisibility(GONE);
            recordChronometer.stop();
            recordButton.setEnabled(true);
            if (attachmentsListener != null) attachmentsListener.onCancelRecordAudio();
        } else if (id == R.id.removeImage) {
            selectImageContainer.setVisibility(GONE);
            messageSendButton.setEnabled(false);
            messageSendButton.setVisibility(GONE);
            recordButton.setVisibility(isAudioRecordButtonVisible ? VISIBLE : GONE);
            takePictureButton.setVisibility(VISIBLE);
            if (attachmentsListener != null) attachmentsListener.onRemoveImage();
        }
    }

    /**
     * This method is called to notify you that, within s,
     * the count characters beginning at start have just replaced old text that had length before
     */
    @Override
    public void onTextChanged(CharSequence s, int start, int count, int after) {
        input = s;
        if (input.length() > 0) {
            if (typingListener != null) typingListener.onInputFull();
            messageSendButton.setEnabled(true);
            messageSendButton.setVisibility(VISIBLE);
            recordButton.setVisibility(GONE);
            takePictureButton.setVisibility(GONE);
        } else {
            if (typingListener != null) typingListener.onInputEmpty();
            messageSendButton.setEnabled(false);
            messageSendButton.setVisibility(GONE);
            recordButton.setVisibility(isAudioRecordButtonVisible ? VISIBLE : GONE);
            takePictureButton.setVisibility(VISIBLE);
        }
        if (s.length() > 0) {
            if (!isTyping) {
                isTyping = true;
                if (typingListener != null) typingListener.onStartTyping();
            }
            removeCallbacks(typingTimerRunnable);
            postDelayed(typingTimerRunnable, delayTypingStatusMillis);
        }
    }

    /**
     * This method is called to notify you that, within s,
     * the count characters beginning at start are about to be replaced by new text with length after.
     */
    @Override
    public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
        //do nothing
    }

    /**
     * This method is called to notify you that, somewhere within s, the text has been changed.
     */
    @Override
    public void afterTextChanged(Editable editable) {
        //do nothing
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (lastFocus && !hasFocus && typingListener != null) {
            typingListener.onStopTyping();
        }
        lastFocus = hasFocus;
    }

    private boolean onSubmit() {
        return inputListener != null && inputListener.onSubmit(input);
    }

    private void onAddAttachments() {
        if (attachmentsListener != null) attachmentsListener.onAddAttachments();
    }

    public void setReplyMessage(ReplyContent replyMessage) {
        if (replyContainer != null) {
            replyContainer.setVisibility(VISIBLE);
            replyUserName.setText(replyMessage.getReplyName());
            replyContent.setText(replyMessage.getReplyText());
        }
    }

    public void setSelectedImage(SelectImageContent selectedImage) {
        if (selectImageContainer != null) {
            selectImageContainer.setVisibility(VISIBLE);
            BitmapFactory.Options bmOptions = new BitmapFactory.Options();
            Bitmap bitmap = BitmapFactory.decodeFile(selectedImage.getImage().getAbsolutePath(),bmOptions);
            this.selectedImage.setImageBitmap(bitmap);
            messageSendButton.setEnabled(true);
            messageSendButton.setVisibility(VISIBLE);
            recordButton.setVisibility(GONE);
            takePictureButton.setVisibility(GONE);
        }
    }

    private void init(Context context, AttributeSet attrs) {
        init(context);
        MessageInputStyle style = MessageInputStyle.parse(context, attrs);

        this.messageInput.setMaxLines(style.getInputMaxLines());
        this.messageInput.setHint(style.getInputHint());
        this.messageInput.setText(style.getInputText());
        this.messageInput.setTextSize(TypedValue.COMPLEX_UNIT_PX, style.getInputTextSize());
        this.messageInput.setTextColor(style.getInputTextColor());
        this.messageInput.setHintTextColor(style.getInputHintColor());
        ViewCompat.setBackground(this.messageInput, style.getInputBackground());
        setCursor(style.getInputCursorDrawable());

        this.attachmentButton.setVisibility(style.showAttachmentButton() ? VISIBLE : GONE);
        this.attachmentButton.setImageDrawable(style.getAttachmentButtonIcon());
        this.attachmentButton.setContentDescription(style.getAttachmentButtonContentDescription());
//        this.attachmentButton.getLayoutParams().width = style.getAttachmentButtonWidth();
//        this.attachmentButton.getLayoutParams().height = style.getAttachmentButtonHeight();
        ViewCompat.setBackground(this.attachmentButton, style.getAttachmentButtonBackground());

//        this.attachmentButtonSpace.setVisibility(style.showAttachmentButton() ? VISIBLE : GONE);
//        this.attachmentButtonSpace.getLayoutParams().width = style.getAttachmentButtonMargin();

        this.recordButton.setImageDrawable(style.getRecordAudioButtonIcon());
        this.recordButton.setContentDescription(style.getRecordAudioButtonContentDescription());
        this.takePictureButton.setImageDrawable(style.getTakePhotoButtonIcon());
        this.takePictureButton.setContentDescription(style.getTakePhotoButtonContentDescription());

        this.messageSendButton.setImageDrawable(style.getInputButtonIcon());
        this.messageSendButton.setContentDescription(style.getInputButtonContentDescription());
        this.messageSendButton.getLayoutParams().width = style.getInputButtonWidth();
        this.messageSendButton.getLayoutParams().height = style.getInputButtonHeight();
        ViewCompat.setBackground(messageSendButton, style.getInputButtonBackground());
//        this.sendButtonSpace.getLayoutParams().width = style.getInputButtonMargin();

        if (getPaddingLeft() == 0
                && getPaddingRight() == 0
                && getPaddingTop() == 0
                && getPaddingBottom() == 0) {
            setPadding(
                    style.getInputDefaultPaddingLeft(),
                    style.getInputDefaultPaddingTop(),
                    style.getInputDefaultPaddingRight(),
                    style.getInputDefaultPaddingBottom()
            );
        }
        this.delayTypingStatusMillis = style.getDelayTypingStatus();
    }

    private void init(Context context) {
        inflate(context, R.layout.view_message_input, this);

        messageInput = findViewById(R.id.messageInput);
        messageSendButton = findViewById(R.id.messageSendButton);
        messageSendButton.setEnabled(false);
        attachmentButton = findViewById(R.id.attachmentButton);
        recordButton = findViewById(R.id.recordAudio);
        takePictureButton = findViewById(R.id.takePicture);
        deleteAudio = findViewById(R.id.deleteAudio);
        removeImage = findViewById(R.id.removeImage);
        replyContainer = findViewById(R.id.replyContainer);
        containerRecordAudio = findViewById(R.id.containerRecordAudio);
        selectImageContainer = findViewById(R.id.selectImageContainer);
        replyUserName = findViewById(R.id.replyUserName);
        replyContent = findViewById(R.id.replyContent);
        replyClose = findViewById(R.id.replyClose);
        selectedImage = findViewById(R.id.selectedImage);
        recordingDuration = findViewById(R.id.recordingDuration);
        recordChronometer = findViewById(R.id.recordChronometer);
//        sendButtonSpace = (Space) findViewById(R.id.sendButtonSpace);
//        attachmentButtonSpace = (Space) findViewById(R.id.attachmentButtonSpace);

        messageSendButton.setOnClickListener(this);
        recordButton.setOnLongClickListener(view -> {
            if (attachmentsListener != null) attachmentsListener.onAddRecordAudio();
            containerRecordAudio.setVisibility(VISIBLE);
            takePictureButton.setVisibility(GONE);
            attachmentButton.setVisibility(GONE);
            messageSendButton.setVisibility(VISIBLE);
            messageInput.setVisibility(GONE);
            messageSendButton.setEnabled(true);
            recordChronometer.setBase(SystemClock.elapsedRealtime());
            recordChronometer.start();
            recordButton.setEnabled(false);
            return true;
        });
        removeImage.setOnClickListener(this);
        replyClose.setOnClickListener(this);
        takePictureButton.setOnClickListener(this);
        deleteAudio.setOnClickListener(this);
        attachmentButton.setOnClickListener(this);
        messageInput.addTextChangedListener(this);
        messageInput.setText("");
        messageInput.setOnFocusChangeListener(this);
    }

    private void setCursor(Drawable drawable) {
        if (drawable == null) return;

        try {
            final Field drawableResField = TextView.class.getDeclaredField("mCursorDrawableRes");
            drawableResField.setAccessible(true);

            final Object drawableFieldOwner;
            final Class<?> drawableFieldClass;
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN) {
                drawableFieldOwner = this.messageInput;
                drawableFieldClass = TextView.class;
            } else {
                final Field editorField = TextView.class.getDeclaredField("mEditor");
                editorField.setAccessible(true);
                drawableFieldOwner = editorField.get(this.messageInput);
                drawableFieldClass = drawableFieldOwner.getClass();
            }
            final Field drawableField = drawableFieldClass.getDeclaredField("mCursorDrawable");
            drawableField.setAccessible(true);
            drawableField.set(drawableFieldOwner, new Drawable[]{drawable, drawable});
        } catch (Exception ignored) {
        }
    }

    public void setRecordAudioButtonVisibility(boolean visibility) {
        if (recordButton != null) {
            recordButton.setVisibility(visibility ? VISIBLE : GONE);
            isAudioRecordButtonVisible = visibility;
        }
    }

    public void setTypingListener(TypingListener typingListener) {
        this.typingListener = typingListener;
    }

    /**
     * Interface definition for a callback to be invoked when user pressed 'submit' button
     */
    public interface InputListener {

        /**
         * Fires when user presses 'send' button.
         *
         * @param input input entered by user
         * @return if input text is valid, you must return {@code true} and input will be cleared, otherwise return false.
         */
        boolean onSubmit(CharSequence input);
    }

    /**
     * Interface definition for a callback to be invoked when user presses 'add' button
     */
    public interface AttachmentsListener {

        /**
         * Fires when user presses 'add' button.
         */
        void onAddAttachments();

        void onAddRecordAudio();

        void onCancelRecordAudio();

        void onAddTakePhoto();

        void onClickClose();

        void onRemoveImage();
    }

    /**
     * Interface definition for a callback to be invoked when user typing
     */
    public interface TypingListener {

        /**
         * Fires when user presses start typing
         */
        void onStartTyping();

        /**
         * Fires when user presses stop typing
         */
        void onStopTyping();

        /**
         * when edit text is empty
         */
        void onInputEmpty();

        /**
         * when edit text is full
         */
        void onInputFull();
    }

    public static class ReplyContent {
        private final String replyName;
        private final String replyText;

        public ReplyContent(String replyName, String replyText) {
            this.replyName = replyName;
            this.replyText = replyText;
        }

        public String getReplyName() {
            return replyName;
        }

        public String getReplyText() {
            return replyText;
        }
    }

    public static class SelectImageContent {
        private final File image;

        public SelectImageContent(File image) {
            this.image = image;
        }

        public File getImage() {
            return image;
        }
    }
}
