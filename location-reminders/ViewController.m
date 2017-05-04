//
//  ViewController.m
//  location-reminders
//
//  Created by Mike Miksch on 5/1/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderViewController.h"
#import "LocationController.h"
#import "Reminder.h"

@import Parse;
@import MapKit;
# import <ParseUI/ParseUI.h>

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationController.shared requestPermissions];
    LocationController.shared.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self fetchReminders];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
//    [PFUser logOut];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        
        loginViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook;
        loginViewController.logInView.logo = [[UIView alloc]init];
        loginViewController.logInView.backgroundColor = [UIColor grayColor];

        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
}

- (void)reminderSavedToParse:(id)sender {
    NSLog(@"Do some stuff since our newReminder was saved.");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKPinAnnotationView class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        
        __weak typeof(self) bruce = self;
        
        newReminderViewController.completion = ^(MKCircle *circle) {
            __strong typeof(bruce) hulk = bruce;
            
            [hulk.mapView removeAnnotation:annotationView.annotation];
            [hulk.mapView addOverlay:circle];
        };
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderSavedToParse" object:nil];

}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.3796527, -86.31108310000002);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)location2Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.0431415, -84.3908793);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}


- (IBAction)location3Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(19.6201258, -155.94922359999998);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
    
}


- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        
        newPoint.coordinate = coordinate;
        newPoint.title = @"New Location";
        
        [self.mapView addAnnotation:newPoint];
        
    }
    
}

- (UIColor *)randomizePinColor {
    
    int lowerBound = 1;
    int upperBound = 5;
    int randomNumber = lowerBound + arc4random() % (upperBound - lowerBound);
    
    if (randomNumber == 1){
        return UIColor.redColor;
    }
    if (randomNumber == 2){
        return UIColor.blueColor;
    }
    if (randomNumber == 3){
        return UIColor.yellowColor;
    }
    if (randomNumber == 4){
        return UIColor.orangeColor;
    }
    if (randomNumber == 5){
        return UIColor.greenColor;
    } else {
        return nil;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    annotationView.pinTintColor = [self randomizePinColor];
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Accessory Tapped!");
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    
    renderer.strokeColor = [UIColor blueColor];
    renderer.fillColor = [UIColor redColor];
    renderer.alpha = 0.5;
    
    return renderer;
}


- (void)locationControllerUpdatedLocation:(CLLocation *)location {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchReminders {
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (Reminder *object in objects) {
                NSLog(@"Here's a reminder! %@", object);
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(object.location.latitude, object.location.longitude);
                NSLog(@"%f", [object.radius doubleValue]);
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:[object.radius doubleValue]];
                if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:coordinate radius:[object.radius doubleValue] identifier:object.name];
                    [LocationController.shared startMonitoringForRegion:region];
                }
                [self.mapView addOverlay:circle];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
