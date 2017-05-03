//
//  AddReminderViewController.h
//  location-reminders
//
//  Created by Mike Miksch on 5/2/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void(^NewReminderCreatedCompletion)(MKCircle *); // return type(^callback name)(input)

@interface AddReminderViewController : UIViewController

@property(strong, nonatomic) NSString *annotationTitle;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(strong, nonatomic) NewReminderCreatedCompletion completion;

@end
