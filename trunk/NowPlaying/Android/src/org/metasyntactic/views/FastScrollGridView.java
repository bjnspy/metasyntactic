package org.metasyntactic.views;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.SystemClock;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.OnHierarchyChangeListener;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.Adapter;
import android.widget.BaseAdapter;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.HeaderViewListAdapter;
import android.widget.WrapperListAdapter;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.activities.R;

/**
 * FastScrollView is meant for embedding {@link GridView}s that contain a large
 * number of items that can be indexed in some fashion. It displays a special
 * scroll bar that allows jumping quickly to indexed sections of the list in
 * touch-mode. Only one child can be added to this view group and it must be a
 * {@link GridView}, with an adapter that is derived from {@link BaseAdapter}.
 */
public class FastScrollGridView extends FrameLayout implements OnScrollListener, OnHierarchyChangeListener {
  private Drawable currentThumb;
  private Drawable overlayDrawable;
  private int thumbHeight;
  private int thumbWidth;
  private int thumbY;
  private RectF overlayPosition;
  // Hard coding these for now
  private static final int overlaySize = 104;
  private boolean dragging;
  private static GridView grid;
  private boolean scrollCompleted;
  private boolean thumbVisible;
  private int visibleItem;
  private Paint paint;
  private static int gridOffset;
  private static Object[] sections;
  private String sectionText;
  private boolean drawOverlay;
  private ScrollFade scrollFade;
  private final Handler handler = new Handler();
  private static BaseAdapter gridAdapter;
  private boolean changedBounds;
  private Context context;

  public interface SectionIndexer {
    Object[] getSections();

    int getPositionForSection(int section);

    int getSectionForPosition(int position);
  }

  public FastScrollGridView(final Context context) {
    super(context);
    init(context);
  }

  public FastScrollGridView(final Context context, final AttributeSet attrs) {
    super(context, attrs);
    init(context);
  }

  public FastScrollGridView(final Context context, final AttributeSet attrs, final int defStyle) {
    super(context, attrs, defStyle);
    init(context);
  }

  private void useThumbDrawable(final Drawable drawable) {
    currentThumb = drawable;
    thumbWidth = 64; // currentThumb.getIntrinsicWidth();
    thumbHeight = 52; // currentThumb.getIntrinsicHeight();
    changedBounds = true;
  }

  private void init(final Context context) {
    // Get both the scrollbar states drawables
    this.context = context;
    final Resources res = context.getResources();
    useThumbDrawable(res.getDrawable(R.drawable.scrollbar_handle_accelerated_anim2));
    overlayDrawable = res.getDrawable(R.drawable.dialog_full_dark);
    scrollCompleted = true;
    setWillNotDraw(false);
    // Need to know when the GridView is added
    setOnHierarchyChangeListener(this);
    overlayPosition = new RectF();
    scrollFade = new ScrollFade();
    paint = new Paint();
    paint.setAntiAlias(true);
    paint.setTextAlign(Paint.Align.CENTER);
    paint.setTextSize(overlaySize / 3);
    paint.setColor(0xFFFFFFFF);
    paint.setStyle(Paint.Style.FILL_AND_STROKE);
  }

  private void removeThumb() {
    thumbVisible = false;
    // Draw one last time to remove thumb
    invalidate();
  }

  @Override
  public void draw(final Canvas canvas) {
    super.draw(canvas);
    if (!thumbVisible) {
      // No need to draw the rest
      return;
    }
    final int y = thumbY;
    final int viewWidth = getWidth();
    final ScrollFade localScrollFade = scrollFade;
    int alpha = -1;
    if (localScrollFade.started) {
      alpha = localScrollFade.getAlpha();
      if (alpha < ScrollFade.ALPHA_MAX / 2) {
        currentThumb.setAlpha(alpha * 2);
      }
      final int left = viewWidth - thumbWidth * alpha / ScrollFade.ALPHA_MAX;
      currentThumb.setBounds(left, 0, viewWidth, thumbHeight);
      changedBounds = true;
    }
    canvas.translate(0, y);
    currentThumb.draw(canvas);
    canvas.translate(0, -y);
    // If user is dragging the scroll bar, draw the alphabet overlay
    if (dragging && drawOverlay) {
      overlayDrawable.draw(canvas);
      final Paint localPaint = paint;
      final float descent = localPaint.descent();
      final RectF rectF = overlayPosition;
      canvas.drawText(sectionText, (int)(rectF.left + rectF.right) / 2, (int)(rectF.bottom + rectF.top) / 2 + overlaySize / 6 - descent, localPaint);
    } else if (alpha == 0) {
      localScrollFade.started = false;
      removeThumb();
    } else {
      invalidate(viewWidth - thumbWidth, y, viewWidth, y + thumbHeight);
    }
  }

  @Override
  protected void onSizeChanged(final int w, final int h, final int oldw, final int oldh) {
    super.onSizeChanged(w, h, oldw, oldh);
    if (currentThumb != null) {
      currentThumb.setBounds(w - thumbWidth, 0, w, thumbHeight);
    }
    final RectF pos = overlayPosition;
    pos.left = (w - overlaySize) / 2;
    pos.right = pos.left + overlaySize;
    pos.top = h / 10; // 10% from top
    pos.bottom = pos.top + overlaySize;
    overlayDrawable.setBounds((int)pos.left, (int)pos.top, (int)pos.right, (int)pos.bottom);
  }

  public void onScrollStateChanged(final AbsListView view, final int scrollState) {
    if (scrollState == SCROLL_STATE_IDLE) {
      context.sendBroadcast(new Intent(NowPlayingApplication.NOT_SCROLLING_INTENT));
    } else {
      context.sendBroadcast(new Intent(NowPlayingApplication.SCROLLING_INTENT));
    }
  }

  public void onScroll(final AbsListView view, final int firstVisibleItem, final int visibleItemCount, final int totalItemCount) {
    if (totalItemCount - visibleItemCount > 0 && !dragging) {
      thumbY = (getHeight() - thumbHeight) * firstVisibleItem / (totalItemCount - visibleItemCount);
      if (changedBounds) {
        final int viewWidth = getWidth();
        currentThumb.setBounds(viewWidth - thumbWidth, 0, viewWidth, thumbHeight);
        changedBounds = false;
      }
    }
    scrollCompleted = true;
    if (firstVisibleItem == visibleItem) {
      return;
    }
    visibleItem = firstVisibleItem;
    if (!thumbVisible || scrollFade.started) {
      thumbVisible = true;
      currentThumb.setAlpha(ScrollFade.ALPHA_MAX);
    }
    handler.removeCallbacks(scrollFade);
    scrollFade.started = false;
    if (!dragging) {
      handler.postDelayed(scrollFade, 1500);
    }
  }

  public static void getSections() {
    Adapter adapter = grid.getAdapter();
    if (adapter instanceof HeaderViewListAdapter) {
      gridOffset = ((HeaderViewListAdapter)adapter).getHeadersCount();
      adapter = ((WrapperListAdapter)adapter).getWrappedAdapter();
    }
    if (adapter instanceof SectionIndexer) {
      gridAdapter = (BaseAdapter)adapter;
      sections = ((SectionIndexer)gridAdapter).getSections();
    }
  }

  public void onChildViewAdded(final View parent, final View child) {
    if (child instanceof GridView) {
      grid = (GridView)child;
      grid.setOnScrollListener(this);
      getSections();
    }
  }

  public void onChildViewRemoved(final View parent, final View child) {
    if (child == grid) {
      grid = null;
      gridAdapter = null;
      sections = null;
    }
  }

  @Override
  public boolean onInterceptTouchEvent(final MotionEvent ev) {
    if (thumbVisible && ev.getAction() == MotionEvent.ACTION_DOWN) {
      if (ev.getX() > getWidth() - thumbWidth && ev.getY() >= thumbY && ev.getY() <= thumbY + thumbHeight) {
        dragging = true;
        return true;
      }
    }
    return false;
  }

  private void scrollTo(final float position) {
    final int count = grid.getCount();
    scrollCompleted = false;
    final Object[] localSections = sections;
    int sectionIndex;
    if (localSections != null && localSections.length > 1) {
      final int nSections = localSections.length;
      int section = (int)(position * nSections);
      if (section >= nSections) {
        section = nSections - 1;
      }
      sectionIndex = section;
      final SectionIndexer baseAdapter = (SectionIndexer)gridAdapter;
      int index = baseAdapter.getPositionForSection(section);
      // Given the expected section and index, the following code will
      // try to account for missing sections (no names starting with..)
      // It will compute the scroll space of surrounding empty sections
      // and interpolate the currently visible letter's range across the
      // available space, so that there is always some list movement while
      // the user moves the thumb.
      int nextIndex = count;
      int prevIndex = index;
      int prevSection = section;
      int nextSection = section + 1;
      // Assume the next section is unique
      if (section < nSections - 1) {
        nextIndex = baseAdapter.getPositionForSection(section + 1);
      }
      // Find the previous index if we're slicing the previous section
      if (nextIndex == index) {
        // Non-existent letter
        while (section > 0) {
          section--;
          prevIndex = baseAdapter.getPositionForSection(section);
          if (prevIndex != index) {
            prevSection = section;
            sectionIndex = section;
            break;
          }
        }
      }
      // Find the next index, in case the assumed next index is not
      // unique. For instance, if there is no P, then request for P's
      // position actually returns Q's. So we need to look ahead to make
      // sure that there is really a Q at Q's position. If not, move
      // further down...
      int nextNextSection = nextSection + 1;
      while (nextNextSection < nSections && baseAdapter.getPositionForSection(nextNextSection) == nextIndex) {
        nextNextSection++;
        nextSection++;
      }
      // Compute the beginning and ending scroll range percentage of the
      // currently visible letter. This could be equal to or greater than
      // (1 / nSections).
      final float fPrev = (float)prevSection / nSections;
      final float fNext = (float)nextSection / nSections;
      index = prevIndex + (int)((nextIndex - prevIndex) * (position - fPrev) / (fNext - fPrev));
      // Don't overflow
      if (index > count - 1) {
        index = count - 1;
      }
      grid.setSelection(index + gridOffset);
    } else {
      final int index = (int)(position * count);
      grid.setSelection(index + gridOffset);
      sectionIndex = -1;
    }
    if (sectionIndex >= 0) {
      final String text = sectionText = localSections[sectionIndex].toString();
      drawOverlay = (text.length() != 1 || text.charAt(0) != ' ') && sectionIndex < localSections.length;
    } else {
      drawOverlay = false;
    }
  }

  private static void cancelFling() {
    // Cancel the list fling
    final MotionEvent cancelFling = MotionEvent.obtain(0, 0, MotionEvent.ACTION_CANCEL, 0, 0, 0);
    grid.onTouchEvent(cancelFling);
    cancelFling.recycle();
  }

  @Override
  public boolean onTouchEvent(final MotionEvent me) {
    if (me.getAction() == MotionEvent.ACTION_DOWN) {
      if (me.getX() > getWidth() - thumbWidth && me.getY() >= thumbY && me.getY() <= thumbY + thumbHeight) {
        dragging = true;
        if (gridAdapter == null && grid != null) {
          getSections();
        }
        cancelFling();
        return true;
      }
    } else if (me.getAction() == MotionEvent.ACTION_UP) {
      if (dragging) {
        dragging = false;
        final Handler localHandler = handler;
        localHandler.removeCallbacks(scrollFade);
        localHandler.postDelayed(scrollFade, 1000);
        return true;
      }
    } else if (me.getAction() == MotionEvent.ACTION_MOVE) {
      if (dragging) {
        final int viewHeight = getHeight();
        thumbY = (int)me.getY() - thumbHeight + 10;
        if (thumbY < 0) {
          thumbY = 0;
        } else if (thumbY + thumbHeight > viewHeight) {
          thumbY = viewHeight - thumbHeight;
        }
        // If the previous scrollTo is still pending
        if (scrollCompleted) {
          scrollTo((float)thumbY / (viewHeight - thumbHeight));
        }
        return true;
      }
    }
    return super.onTouchEvent(me);
  }

  private class ScrollFade implements Runnable {
    private long startTime;
    private long fadeDuration;
    private boolean started;
    static final int ALPHA_MAX = 255;
    static final long FADE_DURATION = 200;

    void startFade() {
      fadeDuration = FADE_DURATION;
      startTime = SystemClock.uptimeMillis();
      started = true;
    }

    int getAlpha() {
      if (!started) {
        return ALPHA_MAX;
      }
      final int alpha;
      final long now = SystemClock.uptimeMillis();
      if (now > startTime + fadeDuration) {
        alpha = 0;
      } else {
        alpha = (int)(ALPHA_MAX - (now - startTime) * ALPHA_MAX / fadeDuration);
      }
      return alpha;
    }

    public void run() {
      if (!started) {
        startFade();
        invalidate();
      }
      if (getAlpha() > 0) {
        final int y = thumbY;
        final int viewWidth = getWidth();
        invalidate(viewWidth - thumbWidth, y, viewWidth, y + thumbHeight);
      } else {
        started = false;
        removeThumb();
      }
    }
  }
}
