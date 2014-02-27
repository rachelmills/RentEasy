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
@property (nonatomic) BOOL loginValid;
@property (nonatomic) BOOL loginPressed;

@end

@implementation REViewController

@synthesize tenantEmail;
@synthesize tenantPassword;
@synthesize landlordEmail;
@synthesize landlordPassword;
@synthesize loginValid;
@synthesize loginPressed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.

    
    //_textView.layer.cornerRadius = 10;
}

- (IBAction)tenantLoginPressed:(id)sender {
    NSError *error = nil;
    loginPressed = true;
    if (tenantEmail && tenantPassword && tenantEmail.text.length && tenantPassword.text.length) {
        loginValid = TRUE;
        PFUser *user = [PFUser logInWithUsername:self.tenantEmail.text password:self.tenantPassword.text error:&error];
        if (!user) {
            loginValid = FALSE;
            NSString *errorString = [error userInfo][@"error"];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            if ([[[PFUser currentUser] objectForKey:@"userType" ] isEqualToString:@"Tenant"]) {
            [self performSegueWithIdentifier:@"TenantLoginSuccessful" sender:nil];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access discrepancy", nil) message:NSLocalizedString(@"You do not have permission to access this page", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }
    } else {
        loginValid = FALSE;
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill in all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}

- (IBAction)landlordLoginPressed:(id)sender {
    NSError *error = nil;
    loginPressed = TRUE;
    if (landlordEmail && landlordPassword && landlordEmail.text.length && landlordPassword.text.length) {
        loginValid = TRUE;
        PFUser *user = [PFUser logInWithUsername:self.landlordEmail.text password:self.landlordPassword.text error:&error];
            if (user) {
                if ([[[PFUser currentUser] objectForKey:@"userType"] isEqualToString:@"Landlord"]) {
                    NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
                    // Add the user to the installation so we can track the owner of the device
                    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                    // Subscribe user to private channel
                    [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channels"];
                    // Save installation object
                    [[PFInstallation currentInstallation] saveEventually];
                    
                    [user setObject:privateChannelName forKey:@"privatechannelkey"];
                    [self performSegueWithIdentifier:@"LandlordLoginSuccessful" sender:nil];

                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access discrepancy", nil) message:NSLocalizedString(@"You do not have permission to access this page", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                }
            } else {
                loginValid = FALSE;
                NSString *errorString = [error userInfo][@"error"];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } 
    } else {
        loginValid = FALSE;
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
