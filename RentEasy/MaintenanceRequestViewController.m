//
//  MaintenanceRequestViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 19/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "MaintenanceRequestViewController.h"
#import "RE_PhotoController.h"
#import <Parse/Parse.h>

@interface MaintenanceRequestViewController ()

@end

@implementation MaintenanceRequestViewController

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
    
    [self maintenanceDescription].text = @"Please add a description for the maintenance issue";

    [self maintenanceDescription].textColor = [UIColor lightGrayColor];
    [self maintenanceDescription].delegate = (id)self;
    
    [_maintenanceDescription addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.maintenanceTypeSegment setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    //Center vertical alignment
   // CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/40.0;
    CGFloat topCorrect = 0.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    }

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[self maintenanceDescription].text isEqualToString:@"Please add a description for the maintenance issue"]) {
        [self maintenanceDescription].text = @"";
        [self maintenanceDescription].textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if([self maintenanceDescription].text.length == 0){
        [self maintenanceDescription].textColor = [UIColor lightGrayColor];
        [self maintenanceDescription].text = @"Comment";
        [[self maintenanceDescription] resignFirstResponder];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    RE_PhotoController *photoController = segue.destinationViewController;
    
    photoController.photoType = @"maintenancePhoto";
}

- (IBAction)submitClicked:(id)sender {
    [_maintenanceDescription removeObserver:self forKeyPath:@"contentSize"];
    __block NSString *propertyID;
        // Get property details for current tenant
    PFQuery *query = [PFUser query];
    
    // Hard code property ID for now
    [query whereKey:@"property" equalTo:@"OeGcmL9wue"];
    NSArray *users = [query findObjects];
    
    for (PFUser *user in users) {
        NSLog(@"property id is %@",[user objectForKey:@"property"]);
        propertyID = [user objectForKey:@"property"];
    }
    
    // Display the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];
    
    PFObject *maintenanceRequest = [PFObject objectWithClassName:@"MaintenanceRequest"];
    
    if ([self maintenanceDescription] == NULL || [[self maintenanceDescription].text isEqualToString:@""]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Please complete description"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    } else {
        [maintenanceRequest setObject:self.maintenanceDescription.text forKey:@"MaintenanceDescription"];
        maintenanceRequest[@"user"] = [PFUser currentUser].username;
        NSLog(@"Property ID is %@", propertyID);
        maintenanceRequest[@"property"] = propertyID;
        maintenanceRequest[@"maintenanceType"] = self.maintenanceType;
        
        [maintenanceRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
            }
        }];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Property"];
        [query whereKey:@"objectId" equalTo:@"OeGcmL9wue"];
        NSArray *properties = [query findObjects];
        

        
        NSString *user;
        for (PFObject *property in properties) {
            NSLog(@"user is %@",[property objectForKey:@"user"]);
            user = [property objectForKey:@"user"];
        }
        NSMutableSet *channelSet = [NSMutableSet setWithCapacity:1];
        
        PFQuery *query1 = [PFUser query];
        [query whereKey:@"objectId" equalTo:user];
        PFUser *user1 = (PFUser *)[query1 getFirstObject];
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user1 objectId]];
            if (privateChannelName && privateChannelName.length != 0) {
            [channelSet addObject:privateChannelName];
        }
        
        NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@"You have a maintenance request", @"key1", [[PFUser currentUser] objectId], @"key2", nil];
        
        // Send the push
        PFPush *push = [[PFPush alloc] init];
        [push setChannels:[channelSet allObjects]];
        [push setData:payload];
        [push sendPushInBackground];
        [PFPush sendPushMessageToChannelInBackground:privateChannelName withMessage:@"You have a maintenance request1"];
        
        
    }
    
    if ([self images].count > 0) {
        for (int i = 0; i < [self images].count; i++) {
            PFFile * image = [[self images]objectAtIndex:i];
            
            [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    PFObject *maintenancePhoto = [PFObject objectWithClassName:@"MaintenancePhoto"];
                    maintenancePhoto[@"image"] = image;
                    maintenancePhoto[@"maintenanceRequest"] = maintenanceRequest;
                    
                    [maintenancePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                } else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"Uploaded: %d%%", percentDone);
            }];
            
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)uploadPhotos:(UIStoryboardSegue *)segue {
    RE_PhotoController *photoController = [segue sourceViewController];
    [self setImages:[photoController images]];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action
                 fromViewController:(RE_PhotoController *)photoController withSender:(id)sender {
    if ([photoController.photoType isEqualToString:@"maintenancePhoto"]) {
        return TRUE;
    } else return FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectMaintenanceRequired:(id)sender {
    
    if (self.maintenanceTypeSegment.selectedSegmentIndex == 0) {
        _maintenanceType = @"Electrical";
    } else if (self.maintenanceTypeSegment.selectedSegmentIndex == 1) {
        _maintenanceType = @"Plumbing";
    } else if (self.maintenanceTypeSegment.selectedSegmentIndex == 2) {
        _maintenanceType = @"Painting";
    } else if (self.maintenanceTypeSegment.selectedSegmentIndex == 3) {
        _maintenanceType = @"Gardening";
    } else if (self.maintenanceTypeSegment.selectedSegmentIndex == 4) {
        _maintenanceType = @"Other";
    }
}

@end
