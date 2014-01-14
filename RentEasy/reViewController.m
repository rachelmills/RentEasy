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

@property (strong, nonatomic) IBOutlet UITextField *tenantEmail;
@property (strong, nonatomic) IBOutlet UITextField *tenantPassword;
@property (strong, nonatomic) NSString* userType;
@property (strong, nonatomic) IBOutlet UITextField *landlordEmail;
@property (strong, nonatomic) IBOutlet UITextField *landlordPassword;


@end

@implementation REViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    _textView.layer.cornerRadius = 10;
}

- (IBAction)landlordLoginPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.landlordEmail.text password:self.landlordPassword.text block:^(PFUser *user, NSError *error) {
        if (!user) {
            //[self performSegueWithIdentifier:@"LandlordLoginSuccessful" sender:self];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    } //else {
        //    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        //}
    }];

}

-(IBAction)tenantLoginPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.tenantEmail.text password:self.tenantPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"TenantLoginSuccessful" sender:self];
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
