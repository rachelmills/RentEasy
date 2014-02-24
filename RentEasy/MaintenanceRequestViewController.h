//
//  MaintenanceRequestViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 19/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceRequestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *maintenanceTypeSegment;

@property (strong, nonatomic) IBOutlet UITextView *maintenanceDescription;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSString *maintenanceType;

- (IBAction)selectMaintenanceRequired:(id)sender;

@end
