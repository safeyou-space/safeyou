package com.thoughtbot.expandablerecyclerview;

public class ExpandableListUtils {
    public static void notifyGroupDataChanged(MultiTypeExpandableRecyclerViewAdapter adapter) {
        adapter.expandableList.expandedGroupIndexes = new boolean[adapter.getGroups().size()];
        for (int i = 0; i < adapter.getGroups().size(); i++) {
            adapter.expandableList.expandedGroupIndexes[i] = false;
        }
    }
}