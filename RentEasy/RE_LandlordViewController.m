//
//  RE_LandlordViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 27/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_LandlordViewController.h"
#import <Parse/Parse.h>

@interface RE_LandlordViewController ()

@end

@implementation RE_LandlordViewController

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
}

- (IBAction)logOut:(id)sender {
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:@"privatechannelkey"] forKey:@"channels"];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
