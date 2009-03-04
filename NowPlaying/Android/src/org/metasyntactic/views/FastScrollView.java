package org.metasyntactic.views;

import org.metasyntactic.activities.R;

import android.content.Context;
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
import android.widget.Adapter;
import android.widget.BaseAdapter;
import android.widget.FrameLayout;
import android.widget.HeaderViewListAdapter;
import android.widget.ListView;
import android.widget.AbsListView.OnScrollListener;

/**
 * FastScrollView is meant for embedding {@link ListView}s that contain a large
 * number of items that can be indexed in some fashion. It displays a special
 * scroll bar that allows jumping quickly to indexed sections of the list in
 * touch-mode. Only one child can be added to this view group and it must be a
 * {@link ListView}, with an adapter that is derived from {@link BaseAdapter}.
 */
public class FastScrollView extends FrameLayout implements OnScrollListener, OnHierarchyChangeListener {
  private Drawable mCurrentThumb;
  private Drawable mOverlayDrawable;
  private int mThumbH;
  private int mThumbW;
  private int mThumbY;
  private RectF mOverlayPos;
  // Hard coding these for now
  private final int mOverlayWidth = 310;
  private final int mOverlayHeight = 85;
  private boolean mDragging;
  private static ListView mList;
  private boolean mScrollCompleted;
  private boolean mThumbVisible;
  private int mVisibleItem;
  private Paint mPaint;
  private static int mListOffset;
  private static Object[] mSections;
  private String mSectionText;
  private boolean mDrawOverlay;
  private ScrollFade mScrollFade;
  private final Handler mHandler = new Handler();
  private static BaseAdapter mListAdapter;
  private boolean mChangedBounds;

  public interface SectionIndexer {
    Object[] getSections();

    int getPositionForSection(int section);

    int getSectionForPosition(int position);
  }

  public FastScrollView(final Context context) {
    super(context);
    init(context);
  }

  public FastScrollView(final Context context, final AttributeSet attrs) {
    super(context, attrs);
    init(context);
  }

  public FastScrollView(final Context context, final AttributeSet attrs, final int defStyle) {
    super(context, attrs, defStyle);
    init(context);
  }

  private void useThumbDrawable(final Drawable drawable) {
    mCurrentThumb = drawable;
    mThumbW = 64; // mCurrentThumb.getIntrinsicWidth();
    mThumbH = 52; // mCurrentThumb.getIntrinsicHeight();
    mChangedBounds = true;
  }

  private void init(final Context context) {
    // Get both the scrollbar states drawables
    final Resources res = context.getResources();
    useThumbDrawable(res.getDrawable(R.drawable.scrollbar_handle_accelerated_anim2));
    mOverlayDrawable = res.getDrawable(R.drawable.dialog_full_dark);
    mScrollCompleted = true;
    setWillNotDraw(false);
    // Need to know when the ListView is added
    setOnHierarchyChangeListener(this);
    mOverlayPos = new RectF();
    mScrollFade = new ScrollFade();
    mPaint = new Paint();
    mPaint.setAntiAlias(true);
    mPaint.setTextAlign(Paint.Align.CENTER);
    mPaint.setTextSize(mOverlayHeight / 4);
    mPaint.setColor(0xFFFFFFFF);
    mPaint.setStyle(Paint.Style.FILL_AND_STROKE);
  }

  private void removeThumb() {
    mThumbVisible = false;
    // Draw one last time to remove thumb
    invalidate();
  }

  @Override
  public void draw(final Canvas canvas) {
    super.draw(canvas);
    if (!mThumbVisible) {
      // No need to draw the rest
      return;
    }
    final int y = mThumbY;
    final int viewWidth = getWidth();
    final FastScrollView.ScrollFade scrollFade = mScrollFade;
    int alpha = -1;
    if (scrollFade.mStarted) {
      alpha = scrollFade.getAlpha();
      if (alpha < ScrollFade.ALPHA_MAX / 2) {
        mCurrentThumb.setAlpha(alpha * 2);
      }
      final int left = viewWidth - mThumbW * alpha / ScrollFade.ALPHA_MAX;
      mCurrentThumb.setBounds(left, 0, viewWidth, mThumbH);
      mChangedBounds = true;
    }
    canvas.translate(0, y);
    mCurrentThumb.draw(canvas);
    canvas.translate(0, -y);
    // If user is dragging the scroll bar, draw the alphabet overlay
    if (mDragging && mDrawOverlay) {
      mOverlayDrawable.draw(canvas);
      final Paint paint = mPaint;
      final float descent = paint.descent();
      final RectF rectF = mOverlayPos;
      canvas.drawText(mSectionText, (int)(rectF.left + rectF.right) / 2, (int)(rectF.bottom + rectF.top) / 2 + mOverlayHeight / 6 - descent,
          paint);
    } else if (alpha == 0) {
      scrollFade.mStarted = false;
      removeThumb();
    } else {
      invalidate(viewWidth - mThumbW, y, viewWidth, y + mThumbH);
    }
  }

  @Override
  protected void onSizeChanged(final int w, final int h, final int oldw, final int oldh) {
    super.onSizeChanged(w, h, oldw, oldh);
    if (mCurrentThumb != null) {
      mCurrentThumb.setBounds(w - mThumbW, 0, w, mThumbH);
    }
    final RectF pos = mOverlayPos;
    pos.left = (w - mOverlayWidth) / 2;
    pos.right = pos.left + mOverlayWidth;
    pos.top = h / 10; // 10% from top
    pos.bottom = pos.top + mOverlayHeight;
    mOverlayDrawable.setBounds((int)pos.left, (int)pos.top, (int)pos.right, (int)pos.bottom);
  }

  public void onScrollStateChanged(final AbsListView view, final int scrollState) {
  }

  public void onScroll(final AbsListView view, final int firstVisibleItem, final int visibleItemCount, final int totalItemCount) {
    if (totalItemCount - visibleItemCount > 0 && !mDragging) {
      mThumbY = (getHeight() - mThumbH) * firstVisibleItem / (totalItemCount - visibleItemCount);
      if (mChangedBounds) {
        final int viewWidth = getWidth();
        mCurrentThumb.setBounds(viewWidth - mThumbW, 0, viewWidth, mThumbH);
        mChangedBounds = false;
      }
    }
    mScrollCompleted = true;
    if (firstVisibleItem == mVisibleItem) {
      return;
    }
    mVisibleItem = firstVisibleItem;
    if (!mThumbVisible || mScrollFade.mStarted) {
      mThumbVisible = true;
      mCurrentThumb.setAlpha(ScrollFade.ALPHA_MAX);
    }
    mHandler.removeCallbacks(mScrollFade);
    mScrollFade.mStarted = false;
    if (!mDragging) {
      mHandler.postDelayed(mScrollFade, 1500);
    }
  }

  public static void getSections() {
    Adapter adapter = mList.getAdapter();
    if (adapter instanceof HeaderViewListAdapter) {
      mListOffset = ((HeaderViewListAdapter)adapter).getHeadersCount();
      adapter = ((HeaderViewListAdapter)adapter).getWrappedAdapter();
    }
    if (adapter instanceof SectionIndexer) {
      mListAdapter = (BaseAdapter)adapter;
      mSections = ((SectionIndexer)mListAdapter).getSections();
    }
  }

  public void onChildViewAdded(final View parent, final View child) {
    if (child instanceof ListView) {
      mList = (ListView)child;
      mList.setOnScrollListener(this);
      getSections();
    }
  }

  public void onChildViewRemoved(final View parent, final View child) {
    if (child == mList) {
      mList = null;
      mListAdapter = null;
      mSections = null;
    }
  }

  @Override
  public boolean onInterceptTouchEvent(final MotionEvent ev) {
    if (mThumbVisible && ev.getAction() == MotionEvent.ACTION_DOWN) {
      if (ev.getX() > getWidth() - mThumbW && ev.getY() >= mThumbY && ev.getY() <= mThumbY + mThumbH) {
        mDragging = true;
        return true;
      }
    }
    return false;
  }

  private void scrollTo(final float position) {
    final int count = mList.getCount();
    mScrollCompleted = false;
    final Object[] sections = mSections;
    int sectionIndex;
    if (sections != null && sections.length > 1) {
      final int nSections = sections.length;
      int section = (int)(position * nSections);
      if (section >= nSections) {
        section = nSections - 1;
      }
      sectionIndex = section;
      final SectionIndexer baseAdapter = (SectionIndexer)mListAdapter;
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
      mList.setSelectionFromTop(index + mListOffset, 0);
    } else {
      final int index = (int)(position * count);
      mList.setSelectionFromTop(index + mListOffset, 0);
      sectionIndex = -1;
    }
    if (sectionIndex >= 0) {
      final String text = mSectionText = sections[sectionIndex].toString();
      mDrawOverlay = (text.length() != 1 || text.charAt(0) != ' ') && sectionIndex < sections.length;
    } else {
      mDrawOverlay = false;
    }
  }

  private void cancelFling() {
    // Cancel the list fling
    final MotionEvent cancelFling = MotionEvent.obtain(0, 0, MotionEvent.ACTION_CANCEL, 0, 0, 0);
    mList.onTouchEvent(cancelFling);
    cancelFling.recycle();
  }

  @Override
  public boolean onTouchEvent(final MotionEvent me) {
    if (me.getAction() == MotionEvent.ACTION_DOWN) {
      if (me.getX() > getWidth() - mThumbW && me.getY() >= mThumbY && me.getY() <= mThumbY + mThumbH) {
        mDragging = true;
        if (mListAdapter == null && mList != null) {
          getSections();
        }
        cancelFling();
        return true;
      }
    } else if (me.getAction() == MotionEvent.ACTION_UP) {
      if (mDragging) {
        mDragging = false;
        final Handler handler = mHandler;
        handler.removeCallbacks(mScrollFade);
        handler.postDelayed(mScrollFade, 1000);
        return true;
      }
    } else if (me.getAction() == MotionEvent.ACTION_MOVE) {
      if (mDragging) {
        final int viewHeight = getHeight();
        mThumbY = (int)me.getY() - mThumbH + 10;
        if (mThumbY < 0) {
          mThumbY = 0;
        } else if (mThumbY + mThumbH > viewHeight) {
          mThumbY = viewHeight - mThumbH;
        }
        // If the previous scrollTo is still pending
        if (mScrollCompleted) {
          scrollTo((float)mThumbY / (viewHeight - mThumbH));
        }
        return true;
      }
    }
    return super.onTouchEvent(me);
  }

  public class ScrollFade implements Runnable {
    long mStartTime;
    long mFadeDuration;
    boolean mStarted;
    static final int ALPHA_MAX = 255;
    static final long FADE_DURATION = 200;

    void startFade() {
      mFadeDuration = FADE_DURATION;
      mStartTime = SystemClock.uptimeMillis();
      mStarted = true;
    }

    int getAlpha() {
      if (!mStarted) {
        return ALPHA_MAX;
      }
      int alpha;
      final long now = SystemClock.uptimeMillis();
      if (now > mStartTime + mFadeDuration) {
        alpha = 0;
      } else {
        alpha = (int)(ALPHA_MAX - (now - mStartTime) * ALPHA_MAX / mFadeDuration);
      }
      return alpha;
    }

    public void run() {
      if (!mStarted) {
        startFade();
        invalidate();
      }
      if (getAlpha() > 0) {
        final int y = mThumbY;
        final int viewWidth = getWidth();
        invalidate(viewWidth - mThumbW, y, viewWidth, y + mThumbH);
      } else {
        mStarted = false;
        removeThumb();
      }
    }
  }
}
