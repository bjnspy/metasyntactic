//
//  MapViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface MapViewController : UIViewController<MKMapViewDelegate> {
@private
  id<MapPoint> center;
  NSArray* locations;

  MKMapView* mapView;
  BOOL locationFound;
}

+ (MapViewController*) controllerWithCenter:(id<MKAnnotation>) center locations:(NSArray*) locations;

@end
