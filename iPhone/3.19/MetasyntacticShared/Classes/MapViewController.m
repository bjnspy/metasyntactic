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

#import "MapViewController.h"

#import "AbstractApplication.h"
#import "Location.h"
#import "MapPoint.h"
#import "MapViewControllerDelegate.h"
#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "NotificationCenter.h"

@interface MapViewController()
@property (retain) id<MKAnnotation> center;
@property (retain) NSArray* locations;
@property (retain) MKMapView* mapView;
@end

@implementation MapViewController

static const NSInteger DIRECTIONS_TAG = 1;
static const NSInteger DETAILS_TAG = 2;

@synthesize mapDelegate;
@synthesize center;
@synthesize locations;
@synthesize mapView;

- (void) dealloc {
  self.mapDelegate = nil;
  self.center = nil;
  self.locations = nil;
  self.mapView = nil;
  [super dealloc];
}


NSComparisonResult comapreByDistance(id l1, id l2, void* context) {
  id<MKAnnotation> center = context;
  id<MKAnnotation> location1 = l1;
  id<MKAnnotation> location2 = l2;

  double distance1 = [Location distanceFrom:center.coordinate to:location1.coordinate useKilometers:YES];
  double distance2 = [Location distanceFrom:center.coordinate to:location2.coordinate useKilometers:YES];

  if (distance1 == distance2) {
    return NSOrderedSame;
  } else if (distance1 < distance2) {
    return NSOrderedAscending;
  } else {
    return NSOrderedDescending;
  }
}


- (NSArray*) determineNearby {
  if (locations.count == 0) {
    return locations;
  }

  NSArray* sorted = [locations sortedArrayUsingFunction:comapreByDistance context:center];
  sorted = [sorted subarrayWithRange:NSMakeRange(0, MIN(9, locations.count))];

  NSMutableArray* array = [NSMutableArray arrayWithArray:sorted];
  [array removeObject:center];

  return array;
}


- (id) initWithCenter:(id<MapPoint>) center_
            locations:(NSArray*) locations_ {
  if ((self = [super init])) {
    self.center = center_;
    self.locations = locations_;
    self.hidesBottomBarWhenPushed = YES;
    self.title = center.location.city;
  }
  return self;
}


+ (MapViewController*) controllerWithCenter:(id<MapPoint>) center
                                  locations:(NSArray*) locations {
  return [[[MapViewController alloc] initWithCenter:center locations:locations] autorelease];
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];
  [NotificationCenter disableNotifications];
}


- (void) onBeforeViewControllerPopped {
  [super onBeforeViewControllerPopped];
  [NotificationCenter enableNotifications];
  mapView.delegate = nil;
}


- (void) updateAccessory:(MKAnnotationView*) view {
  UIButton* button = (id)view.leftCalloutAccessoryView;
  if (button == nil) {
    UIImage* image = [MetasyntacticStockImages directions];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    button.tag = DIRECTIONS_TAG;

    view.leftCalloutAccessoryView = button;
  }

  button.enabled = locationFound;
}


- (void) findLocation {
  CLLocation* userLocation = mapView.userLocation.location;
  if (userLocation == nil || userLocation.horizontalAccuracy < 0) {
    [self performSelector:@selector(findLocation) withObject:nil afterDelay:2];
    return;
  }

  locationFound = YES;
  for (id annotation in mapView.annotations) {
    if ([annotation conformsToProtocol:@protocol(MapPoint)]) {
      MKAnnotationView* view = [mapView viewForAnnotation:annotation];
      [self updateAccessory:view];
    }
  }
}


- (void) loadView {
  [super loadView];

  NSArray* nearby = [self determineNearby];

  NSMutableArray* remainder = [NSMutableArray arrayWithArray:locations];
  [remainder removeObject:center];
  [remainder removeObjectsInArray:nearby];

  self.mapView = [[[MKMapView alloc] initWithFrame:self.view.bounds] autorelease];
  mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  mapView.delegate = self;
  mapView.showsUserLocation = YES;

  if (nearby.count == 0) {
    mapView.region = MKCoordinateRegionMake(center.coordinate, MKCoordinateSpanMake(0.015, 0.015));
  } else {
    double minLat = center.coordinate.latitude;
    double maxLat = center.coordinate.latitude;
    double minLng = center.coordinate.longitude;
    double maxLng = center.coordinate.longitude;

    for (id<MKAnnotation> annotation in nearby) {
      minLat = MIN(minLat, annotation.coordinate.latitude);
      maxLat = MAX(maxLat, annotation.coordinate.latitude);
      minLng = MIN(minLng, annotation.coordinate.longitude);
      maxLng = MAX(maxLng, annotation.coordinate.longitude);
    }

    CLLocationCoordinate2D centerCoord = { (minLat + maxLat) / 2., (minLng + maxLng) / 2. };
    MKCoordinateSpan span = MKCoordinateSpanMake(ABS(maxLat - minLat), ABS(maxLng - minLng));
    mapView.region = MKCoordinateRegionMake(centerCoord, span);
  }
  [self.view addSubview:mapView];

  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"Google Maps", nil) style:UIBarButtonItemStyleDone target:self action:@selector(openGoogleMaps)] autorelease];

  [mapView addAnnotation:center];
  for (id<MKAnnotation> location in nearby) {
    [mapView addAnnotation:location];
  }
  for (id<MKAnnotation> location in remainder) {
    [mapView addAnnotation:location];
  }

  [self findLocation];
}


- (MKAnnotationView*) mapView:(MKMapView*) mapView_ viewForAnnotation:(id <MKAnnotation>)annotation {
  if (annotation == mapView.userLocation) {
    return nil;
  }

  static NSString* reuseIdentifier = @"reuseIdentifier";
  MKPinAnnotationView* result = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
  if (result == nil) {
    result = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
    result.animatesDrop = YES;
    result.canShowCallout = YES;

    if (mapDelegate != nil) {
      if ([mapDelegate hasDetailsForAnnotation:annotation]) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.tag = DETAILS_TAG;
        result.rightCalloutAccessoryView = button;
      }
    }
  }

  result.annotation = annotation;
  [self updateAccessory:result];

  return result;
}


- (void) openGoogleMaps {
  id<MapPoint> location = center;
  for (id annotation in mapView.selectedAnnotations) {
    if ([annotation conformsToProtocol:@protocol(MapPoint)]) {
      location = annotation;
      break;
    }
  }

  [AbstractApplication openMap:[location mapUrl]];
}


- (void) mapView:(MKMapView*) mapView_ didAddAnnotationViews:(NSArray*) views {
  [mapView selectAnnotation:center animated:YES];
}


- (void) onDirectionsTappedForView:(MKAnnotationView*) view {
  id<MKAnnotation> location = view.annotation;

  MKUserLocation* userLocation = mapView.userLocation;

  NSString* address = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                       userLocation.coordinate.latitude,
                       userLocation.coordinate.longitude,
                       location.coordinate.latitude,
                       location.coordinate.longitude];
  [AbstractApplication openMap:address];
}


- (void) onDetailsTappedForView:(MKAnnotationView*) view {
  [mapDelegate detailsButtonTappedForAnnotation:view.annotation];
}


- (void) mapView:(MKMapView*) mapView_ annotationView:(MKAnnotationView*) view calloutAccessoryControlTapped:(UIButton*) button {
  if (button.tag == DIRECTIONS_TAG) {
    [self onDirectionsTappedForView:view];
  } else {
    [self onDetailsTappedForView:view];
  }
}

@end
