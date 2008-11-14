/*
 * Copyright (C) 2007 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.metasyntactic.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.widget.GridView;

/** A gallery of the different styles of buttons. */
public class CustomGridView extends GridView {
  public CustomGridView(Context context) {
    super(context);
    this.setFocusableInTouchMode(true);
    // TODO Auto-generated constructor stub
  }

  public CustomGridView(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
    this.setFocusableInTouchMode(true);
    // TODO Auto-generated constructor stub
  }

  public CustomGridView(Context context, AttributeSet attrs) {
    super(context, attrs);
    this.setFocusable(true);
    this.setFocusableInTouchMode(true);
    // TODO Auto-generated constructor stub
  }

@Override
protected void onScrollChanged(int l, int t, int oldl, int oldt) {
    // TODO Auto-generated method stub
    super.onScrollChanged(l/20, t/20, oldl, oldt);
}




}
