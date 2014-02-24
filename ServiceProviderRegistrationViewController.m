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

@property (nonatomic) BOOL signedUp;

@end

@implementation ServiceProviderRegistrationViewController

@synthesize serviceProviderCompanyName;
@synthesize serviceProviderEmail;
@synthesize serviceProviderTel;
@synthesize serviceProviderPassword;
@synthesize specialityType;
@synthesize signedUp;
@synthesize scrollView;

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
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(320, 568)];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];

    // Add Apply and Cancel buttons to telephone key pad text field
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    serviceProviderTel.inputAccessoryView = numberToolbar;
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [specialitySegment setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];

}

#pragma mark - Private methods
- (IBAction)signUpUserPressed:(id)sender {
    NSError *error = nil;
    if (serviceProviderCompanyName && serviceProviderEmail && serviceProviderPassword && serviceProviderTel && specialityType && serviceProviderCompanyName.text.length && serviceProviderEmail.text.length && serviceProviderPassword.text.length && serviceProviderTel.text.length && specialityType.length) {
    PFUser *user = [PFUser user];
    user.username = serviceProviderEmail.text;
    user.password = serviceProviderPassword.text;
    user[@"companyName"] = serviceProviderCompanyName.text;
    user[@"specialityType"] = specialityType;
    user[@"tel"] = serviceProviderTel.text;
    user[@"userType"] = @"Service Provider";
    user[@"email"] = serviceProviderEmail.text;
        
    signedUp = [user signUp:&error];
        
        if (signedUp) {
            [self performSegueWithIdentifier:@"ServiceProviderRegistrationSuccessful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill in all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}

-(void)cancelNumberPad{
    [serviceProviderTel resignFirstResponder];
    serviceProviderTel.text = @"";
}

-(void)doneWithNumberPad{
    [serviceProviderTel resignFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
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
        specialityType = @"Plumber";
    } else if (specialitySegment.selectedSegmentIndex == 1) {
        specialityType = @"Electrician";
    } else if (specialitySegment.selectedSegmentIndex == 2) {
        specialityType = @"Gardener";
    } else if (specialitySegment.selectedSegmentIndex == 3) {
        specialityType = @"Maintenance";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
