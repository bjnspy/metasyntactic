//
//  CachedCell.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface CachedCell : UITableViewCell {
    NSMutableDictionary* cellCache;
    NSIndexPath* indexPath;
}

@property (retain) NSMutableDictionary* cellCache;
@property (retain) NSIndexPath* indexPath;

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier;

@end
