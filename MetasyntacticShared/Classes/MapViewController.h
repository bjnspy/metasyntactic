//
//  MapViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface MapViewController : UIViewController<MKMapViewDelegate> {
@private
  Location* center;
  NSArray* total;

  MKMapView* mapView;
  BOOL locationFound;
}

+ (MapViewController*) controllerWithCenter:(Location*) center total:(NSArray*) total;

@end
