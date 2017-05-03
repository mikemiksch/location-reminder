//
//  AddReminderViewController.m
//  location-reminders
//
//  Created by Mike Miksch on 5/2/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderName;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)saveButtonPressed:(id)sender {

    Reminder *newReminder = [Reminder object];
    
    newReminder.name =self.reminderName.text;
    
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Annotation Title: %@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Save Reminder Successful:%i - Error: %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse" object:nil];
        
        if (self.completion) {
            CGFloat radius = [self.reminderRadius.text floatValue];
            
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
            
            self.completion(circle);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

//- (void)saveDetails {
//    NSString *name = self.reminderName.text;
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle = NSNumberFormatterFloa;
//    NSNumber *radius =[formatter numberFromString:self.reminderRadius.text];
//}

@end
