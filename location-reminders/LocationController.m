//
//  LocationController.m
//  location-reminders
//
//  Created by Mike Miksch on 5/2/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import "LocationController.h"

@interface LocationController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationController

- (LocationController *)init {
    self = [super init];
    if (self) {
        self.locationManager.delegate = self;
    }
    return self;
}

+ (LocationController *)shared {
    static LocationController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[LocationController alloc] init];
    });
    return shared;
}

- (void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; //meters
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    [self.delegate locationControllerUpdatedLocation:location];
    
}


@end
