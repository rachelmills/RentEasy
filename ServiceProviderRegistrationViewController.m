//
//  ServiceProviderRegistrationViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 18/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "ServiceProviderRegistrationViewController.h"
#import "RE_SOTextField.h"
#import <Parse/Parse.h>

@interface ServiceProviderRegistrationViewController ()

@end

@implementation ServiceProviderRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Add Apply and Cancel buttons to telephone key pad text field
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _serviceProviderTel.inputAccessoryView = numberToolbar;
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [specialitySegment setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];

}

#pragma mark - Private methods
- (IBAction)signUpUserPressed:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.serviceProviderEmail.text;
    user.password = self.serviceProviderPassword.text;
    user[@"companyName"] = self.serviceProviderCompanyName.text;
    user[@"specialityType"] = self.specialityType;
    user[@"tel"] = self.serviceProviderTel.text;
    user[@"userType"] = @"Service Provider";
    user[@"email"] = self.serviceProviderEmail.text;
    NSLog(@"user type is:  %@", @"Service Provider");
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"ServiceProviderRegistrationSuccessful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}


-(void)cancelNumberPad{
    [_serviceProviderTel resignFirstResponder];
    _serviceProviderTel.text = @"";
}

-(void)doneWithNumberPad{
    [_serviceProviderTel resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[RE_SOTextField class]])
        [[(RE_SOTextField *)textField nextField] becomeFirstResponder];
    
    return YES;
    
}

- (IBAction)selectSpecialitytype:(UISegmentedControl *)sender {
    if (specialitySegment.selectedSegmentIndex == 0 ) {
        _specialityType = @"Plumber";
    } else if (specialitySegment.selectedSegmentIndex == 1) {
        _specialityType = @"Electrician";
    } else if (specialitySegment.selectedSegmentIndex == 2) {
        _specialityType = @"Gardener";
    } else if (specialitySegment.selectedSegmentIndex == 3) {
        _specialityType = @"Maintenance";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
