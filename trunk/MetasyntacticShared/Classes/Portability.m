// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@implementation Portability

- (void) setStatusBarHidden:(BOOL) hidden
                   animated:(BOOL) animated {
}

- (void) setStatusBarHidden:(BOOL) hidden
              withAnimation:(StatusBarAnimation) animation {
}


- (UserInterfaceIdiom) userInterfaceIdiom {
  return UserInterfaceIdiomPhone;
}


+ (UserInterfaceIdiom) userInterfaceIdiom {
  id device = [UIDevice currentDevice];
  if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
    return [device userInterfaceIdiom];
  } else {
    return UserInterfaceIdiomPhone;
  }
}


+ (void)setApplicationStatusBarHidden:(BOOL)hidden
                        withAnimation:(StatusBarAnimation)animation {
  id application = [UIApplication sharedApplication];
  if ([application respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
    [application setStatusBarHidden:hidden withAnimation:animation];
  } else {
    [application setStatusBarHidden:hidden animated:animation != StatusBarAnimationNone];
  }
}

@end
