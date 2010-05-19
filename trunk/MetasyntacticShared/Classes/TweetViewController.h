//

#import "AbstractTableViewController.h"

@interface TweetViewController : AbstractTableViewController<UITextViewDelegate> {
@private
  UITextView* textView;
  UILabel* label;
  AbstractTwitterAccount* account;
}

- (id) initWithTweet:(NSString*) tweet
             account:(AbstractTwitterAccount*) account;

@end
