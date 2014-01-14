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


@end

@implementation RegistrationViewController

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
    PFUser *user = [PFUser user];
    user.username = self.emailRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    user[@"firstName"] = self.firstNameRegisterTextField.text;
    user[@"surname"] = self.surnameRegisterTextField.text;
    user[@"tel"] = self.telRegisterTextField.text;
    user[@"userType"] = self.userType;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if ([self.userType  isEqual: @"Landlord"]) {
                [self performSegueWithIdentifier:@"LandlordRegistrationSuccessful" sender:self];
            } else if ([self.userType isEqualToString:@"Tenant"]) {
                [self performSegueWithIdentifier:@"TenantRegistrationSuccessful" sender:self];
            }

        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
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
    _telRegisterTextField.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [self.telRegisterTextField resignFirstResponder];
    self.telRegisterTextField.text = @"";
}

-(void)doneWithNumberPad{
    [self.telRegisterTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
