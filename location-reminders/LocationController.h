//
//  LocationController.h
//  location-reminders
//
//  Created by Mike Miksch on 5/2/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;


@protocol LocationControllerDelegate <NSObject>

@required
- (void) locationControllerUpdatedLocation:(CLLocation *)location;

@end

@interface LocationController : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id<LocationControllerDelegate> delegate;

+ (LocationController *)shared;

- (void)requestPermissions;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;

-(void)startMonitoringForRegion:(CLRegion *)region;

@end
