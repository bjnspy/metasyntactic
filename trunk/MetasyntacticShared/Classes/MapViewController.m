//
//  MapViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

#import "AbstractApplication.h"
#import "Location.h"
#import "MetasyntacticStockImages.h"
#import "NotificationCenter.h"

@interface MapViewController()
@property (retain) Location* center;
@property (retain) NSArray* total;
@property (retain) MKMapView* mapView;
@end

@implementation MapViewController

@synthesize center;
@synthesize total;
@synthesize mapView;

- (void)dealloc {
  self.center = nil;
  self.total = nil;
  self.mapView = nil;
  [super dealloc];
}


NSComparisonResult comapreByDistance(id l1, id l2, void* context) {
  Location* center = context;
  Location* location1 = l1;
  Location* location2 = l2;
 
  double distance1 = [center distanceTo:location1];
  double distance2 = [center distanceTo:location2];
  
  if (distance1 == distance2) {
    return NSOrderedSame;
  } else if (distance1 < distance2) {
    return NSOrderedAscending;
  } else {
    return NSOrderedDescending;
  }
}


- (NSArray*) determineNearby {
  if (total.count == 0) {
    return total;
  }

  NSArray* sorted = [total sortedArrayUsingFunction:comapreByDistance context:center];
  sorted = [sorted subarrayWithRange:NSMakeRange(0, MIN(5, total.count))];

  NSMutableArray* array = [NSMutableArray arrayWithArray:sorted];
  [array removeObject:center];
  
  return array;
}


- (id) initWithCenter:(Location*) center_
            total:(NSArray*) total_ {
  if ((self = [super init])) {
    self.center = center_;
    self.total = total_;
    self.hidesBottomBarWhenPushed = YES;
  }
  return self;
}


+ (MapViewController*) controllerWithCenter:(Location*) center
                                  total:(NSArray*) total {
  return [[[MapViewController alloc] initWithCenter:center total:total] autorelease];
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  [NotificationCenter disableNotifications];
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  [NotificationCenter disableNotifications];
  mapView.delegate = nil;
}


- (void) updateAccessory:(MKAnnotationView*) view {
  UIButton* button = (id)view.leftCalloutAccessoryView;
  if (button == nil) {
    UIImage* image = [MetasyntacticStockImages directions];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    view.leftCalloutAccessoryView = button;
  }

  button.enabled = locationFound;
}


- (void) findLocation {
  CLLocation* userLocation = mapView.userLocation.location;
  if (userLocation == nil ||
      userLocation.horizontalAccuracy < 0 ||
      userLocation.horizontalAccuracy > kCLLocationAccuracyKilometer) {
    [self performSelector:@selector(findLocation) withObject:nil afterDelay:2];
    return;
  }

  locationFound = YES;
  for (MKAnnotationView* view in mapView.selectedAnnotations) {
    if ([view.annotation isKindOfClass:[Location class]]) {
      [self updateAccessory:view];
    }
  }
}


- (void) loadView {
  [super loadView];
  
  NSArray* nearby = [self determineNearby];
  
  NSMutableArray* remainder = [NSMutableArray arrayWithArray:total];
  [remainder removeObject:center];
  [remainder removeObjectsInArray:nearby];
  
  self.mapView = [[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
  mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  mapView.delegate = self;
  mapView.showsUserLocation = YES;
  
  if (nearby.count == 0) {
    mapView.region = MKCoordinateRegionMake(center.coordinate, MKCoordinateSpanMake(0.015, 0.015));
  } else {
    double minLat = center.latitude;
    double maxLat = center.latitude;
    double minLng = center.longitude;
    double maxLng = center.longitude;
    
    for (Location* location in nearby) {
      minLat = MIN(minLat, location.latitude);
      maxLat = MAX(maxLat, location.latitude);
      minLng = MIN(minLng, location.longitude);
      maxLng = MAX(maxLng, location.longitude);
    }

    CLLocationCoordinate2D centerCoord = { (minLat + maxLat) / 2., (minLng + maxLng) / 2. };
    MKCoordinateSpan span = MKCoordinateSpanMake(ABS(maxLat - minLat), ABS(maxLng - minLng));
    mapView.region = MKCoordinateRegionMake(centerCoord, span);
  }
  [self.view addSubview:mapView];
  
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Google Maps", nil) style:UIBarButtonItemStyleDone target:self action:@selector(openGoogleMaps)] autorelease];
  
  [mapView addAnnotation:center];
  for (Location* location in nearby) {
    [mapView addAnnotation:location];
  }
  for (Location* location in remainder) {
    [mapView addAnnotation:location];
  }
  
  [self findLocation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id <MKAnnotation>)annotation {
  if (annotation == mapView.userLocation) {
    return nil;
  }
  
  static NSString* reuseIdentifier = @"reuseIdentifier";
  MKPinAnnotationView* result = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
  if (result == nil) {
    result = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
    result.animatesDrop = YES;
    result.canShowCallout = YES;
  }
  
  result.annotation = annotation;
  [self updateAccessory:result];
  
  return result;
}


- (void) openGoogleMaps {
  Location* location = center;
  for (id annotation in mapView.selectedAnnotations) {
    if ([annotation isKindOfClass:[Location class]]) {
      location = annotation;
      break;
    }
  }
  
  [AbstractApplication openMap:location.mapUrl];
}


- (void)mapView:(MKMapView *)mapView_ didAddAnnotationViews:(NSArray *)views {
  [mapView selectAnnotation:center animated:YES];
}


- (void)mapView:(MKMapView *)mapView_ annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIButton *)button {
  Location* location = (id)view.annotation;
  MKUserLocation* userLocation = mapView.userLocation;
  
  NSString* address = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                       userLocation.coordinate.latitude,
                       userLocation.coordinate.longitude,
                       location.latitude,
                       location.longitude];
  [AbstractApplication openMap:address];
}

@end
