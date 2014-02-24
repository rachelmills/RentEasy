//
//  ServiceProviderRegistrationViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 18/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProviderRegistrationViewController : UIViewController {
    IBOutlet UISegmentedControl *specialitySegment;
}

@property (strong, nonatomic) IBOutlet UITextField *serviceProviderEmail;
@property (strong, nonatomic) IBOutlet UITextField *serviceProviderPassword;
@property (strong, nonatomic) IBOutlet UITextField *serviceProviderCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *serviceProviderTel;

- (IBAction)selectSpecialitytype:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *specialityType;

@end
