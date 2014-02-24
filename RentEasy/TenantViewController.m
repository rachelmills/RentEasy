//
//  TenantViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 22/02/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "TenantViewController.h"
#import <Parse/Parse.h>

@interface TenantViewController ()

@end

@implementation TenantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    [self.navigationController popViewControllerAnimated:NO];
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
