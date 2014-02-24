//
//  RegistrationViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 14/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "RegistrationViewController.h"
#import <Parse/Parse.h>
#import "RE_SOTextField.h"

@interface RegistrationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailRegisterTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordRegisterTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameRegisterTextField;
@property (strong, nonatomic) IBOutlet UITextField *surnameRegisterTextField;
@property (strong, nonatomic) IBOutlet UITextField *telRegisterTextField;
@property (nonatomic) BOOL signedUp;

@end

@implementation RegistrationViewController

@synthesize scrollView;
@synthesize emailRegisterTextField;
@synthesize passwordRegisterTextField;
@synthesize firstNameRegisterTextField;
@synthesize surnameRegisterTextField;
@synthesize telRegisterTextField;
@synthesize userType;
@synthesize signedUp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Private methods
- (IBAction)signUpUserPressed:(id)sender {
    NSError *error = nil;
    if (emailRegisterTextField && passwordRegisterTextField && firstNameRegisterTextField && surnameRegisterTextField && telRegisterTextField && emailRegisterTextField.text.length && passwordRegisterTextField.text.length && firstNameRegisterTextField.text.length && surnameRegisterTextField.text.length && telRegisterTextField.text.length) {
        PFUser *user = [PFUser user];
        user.username = emailRegisterTextField.text;
        user.password = passwordRegisterTextField.text;
        user[@"firstName"] = firstNameRegisterTextField.text;
        user[@"surname"] = surnameRegisterTextField.text;
        user[@"tel"] = telRegisterTextField.text;
        user[@"userType"] = userType;
        // hard code property id for now
        if ([userType isEqualToString:@"Tenant"]) {
            user[@"property"] = @"UFmtGHoHeq";
        }
        signedUp = [user signUp:&error];
        
        if (signedUp) {
            if ([self.userType  isEqual: @"Landlord"]) {
                [self performSegueWithIdentifier:@"LandlordRegistrationSuccessful" sender:self];
            } else if ([self.userType isEqualToString:@"Tenant"]) {
                [self performSegueWithIdentifier:@"TenantRegistrationSuccessful" sender:self];
            }

        } else {
            NSString *errorString = [error userInfo][@"error"];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        NSLog(@"user type is:  %@", self.userType);
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill in all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[RE_SOTextField class]])
        [[(RE_SOTextField *) textField nextField] becomeFirstResponder];
    
    return YES;
    
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
    telRegisterTextField.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [self.telRegisterTextField resignFirstResponder];
    self.telRegisterTextField.text = @"";
}

-(void)doneWithNumberPad{
    [self.telRegisterTextField resignFirstResponder];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
