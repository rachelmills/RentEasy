//
//  ServiceProviderLoginViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 14/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "ServiceProviderLoginViewController.h"
#import <Parse/Parse.h>

@interface ServiceProviderLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ServiceProviderLoginViewController

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
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
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
