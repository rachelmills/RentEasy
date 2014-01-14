//
//  reViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 14/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "REViewController.h"
#import <Parse/Parse.h>
#import "RE_SOTextField.h"
#import "RegistrationViewController.h"

@interface REViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSString* userType;


@end

@implementation REViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    _textView.layer.cornerRadius = 10;
}

-(IBAction)loginPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"LandlordLoginSuccessful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

-(void)login {
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[RE_SOTextField class]])
        [[(RE_SOTextField *) textField nextField] becomeFirstResponder];
    
    return YES;
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    RegistrationViewController *transferViewController = segue.destinationViewController;
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"LandlordSegue"])
    {
        transferViewController.userType = @"Landlord";
        
    } else if([segue.identifier isEqualToString:@"TenantSegue"]) {
        
        transferViewController.userType = @"Tenant";
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
