//
//  AddReminderViewController.m
//  location-reminders
//
//  Created by Mike Miksch on 5/2/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderName;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Annotation Title: %@", self.annotationTitle);
    NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);

}

- (void)saveDetails {
    NSString *name = self.reminderName.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *radius =[formatter numberFromString:self.reminderRadius.text];
}

@end
