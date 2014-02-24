//
//  ServiceProviderLoginViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 14/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "ServiceProviderLoginViewController.h"
#import <Parse/Parse.h>
#import "RE_SOTextField.h"

@interface ServiceProviderLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ServiceProviderLoginViewController

@synthesize emailTextField;
@synthesize passwordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)logInPressed:(id)sender
{
    NSError *error = nil;
    if (emailTextField && passwordTextField && emailTextField.text.length && passwordTextField.text.length) {
        PFUser *user = [PFUser logInWithUsername:self.emailTextField.text password:self.passwordTextField.text error:&error];
        if (!user) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            if ([[[PFUser currentUser] objectForKey:@"userType"] isEqualToString:@"Service Provider"]) {
                [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access discrepancy", nil) message:NSLocalizedString(@"You do not have permission to access this page", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            }
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill in all of the information", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
