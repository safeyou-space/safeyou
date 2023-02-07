package com.fambox.chatkit.commons.models;

import java.util.List;

public class Message {
    private String text;
    private List<ISpan> spans;

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public List<ISpan> getSpans() {
        return spans;
    }

    public void setSpans(List<ISpan> spans) {
        this.spans = spans;
    }
}
