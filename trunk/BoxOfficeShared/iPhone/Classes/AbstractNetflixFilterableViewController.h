//
//  AbstractNetflixFilterableViewController.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 8/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractNetflixFilterableViewController : AbstractTableViewController {
@private
  NSArray* movies;
  NSArray* filteredMovies;
}

@end
