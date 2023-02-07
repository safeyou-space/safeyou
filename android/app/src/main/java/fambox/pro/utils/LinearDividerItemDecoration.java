package fambox.pro.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.View;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import fambox.pro.R;

public class LinearDividerItemDecoration extends RecyclerView.ItemDecoration {

    public static final int SIZE_THIN = 2;
    private final Paint paint;
    private final int dividerHeight;

    private int layoutOrientation = -1;

    public LinearDividerItemDecoration(Context context, int dHeight) {
        paint = new Paint();
        paint.setColor(context.getResources().getColor(R.color.dividerColor));
        paint.setStrokeWidth(dHeight);
        dividerHeight = dHeight;
    }

    @SuppressLint("WrongConstant")
    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        super.getItemOffsets(outRect, view, parent, state);

        if (parent.getLayoutManager() instanceof LinearLayoutManager && layoutOrientation == -1) {
            layoutOrientation = ((LinearLayoutManager) parent.getLayoutManager()).getOrientation();
        }

        if (layoutOrientation == LinearLayoutManager.HORIZONTAL) {
            outRect.set(0, 0, dividerHeight, 0);
        } else {
            outRect.set(0, 0, 0, dividerHeight);
        }
    }

    @Override
    public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state) {
        super.onDraw(c, parent, state);

        if (layoutOrientation == LinearLayoutManager.HORIZONTAL) {
            horizontalDivider(c, parent);
        } else {
            verticalDivider(c, parent);
        }
    }

    private void horizontalDivider(Canvas c, RecyclerView parent) {
        int top = parent.getPaddingTop() + parent.getHeight();
        int bottom = parent.getHeight() - parent.getPaddingBottom() - parent.getHeight();

        int itemCount = parent.getChildCount();
        for (int i = 0; i < itemCount; i++) {
            View child = parent.getChildAt(i);
            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) child
                    .getLayoutParams();
            int left = child.getRight() + params.rightMargin;
            c.drawLine(left, top, left, bottom, paint);
        }
    }

    private void verticalDivider(Canvas c, RecyclerView parent) {
        int left = parent.getPaddingLeft() + parent.getWidth() / 14;
        int right = parent.getWidth() - parent.getPaddingRight() - parent.getWidth() / 14;

        int childCount = parent.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View child = parent.getChildAt(i);
            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) child
                    .getLayoutParams();
            int top = child.getBottom() + params.bottomMargin;
            c.drawLine(left, top, right, top, paint);
        }
    }
}
 