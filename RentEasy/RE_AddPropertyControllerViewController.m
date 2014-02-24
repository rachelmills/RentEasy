//
//  RE_AddPropertyControllerViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 28/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_AddPropertyControllerViewController.h"
#import <Parse/Parse.h>
#import "RE_PhotoController.h"

@interface RE_AddPropertyControllerViewController ()



@end

@implementation RE_AddPropertyControllerViewController
@synthesize scrollView;
@synthesize propertyAddress;

UILabel *label;

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
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(320, 568)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
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


- (IBAction)selectPropertyType:(UISegmentedControl *)sender {
    if (segment.selectedSegmentIndex == 0) {
        _propertyType = @"House";
        bedsSegment.enabled = TRUE;
    } else if (segment.selectedSegmentIndex == 1) {
        _propertyType = @"Unit";
        bedsSegment.enabled = TRUE;
    } else if (segment.selectedSegmentIndex == 2) {
        _propertyType = @"Townhouse";
        bedsSegment.enabled = TRUE;
    } else if (segment.selectedSegmentIndex == 3) {
        _propertyType = @"Studio";
        bedsSegment.enabled = FALSE;
        [bedsSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        _numberOfBeds = 0;
    }
}

- (IBAction)selectNumberOfBeds:(UISegmentedControl *)sender {
    if (bedsSegment.selectedSegmentIndex == 0) {
        _numberOfBeds = 1;
    } else if (bedsSegment.selectedSegmentIndex == 1) {
        _numberOfBeds = 2;
    } else if (bedsSegment.selectedSegmentIndex == 2) {
        _numberOfBeds = 3;
    } else if (bedsSegment.selectedSegmentIndex == 3) {
        _numberOfBeds = 4;
    } else if (bedsSegment.selectedSegmentIndex == 4) {
        _numberOfBeds = 5;
    } else if (bedsSegment.selectedSegmentIndex == 5) {
        _numberOfBeds = 6;
    }
}

- (IBAction)selectNumberOfBathrooms:(UISegmentedControl *)sender {
    if (bathsSegment.selectedSegmentIndex == 0) {
        _numberOfBathrooms = 1;
    } else if (bathsSegment.selectedSegmentIndex == 1) {
        _numberOfBathrooms = 2;
    } else if (bathsSegment.selectedSegmentIndex == 2) {
        _numberOfBathrooms = 3;
    } else if (bathsSegment.selectedSegmentIndex == 3) {
        _numberOfBathrooms = 4;
    }
}

- (IBAction)selectNumberOfCarSpaces:(UISegmentedControl *)sender {
    if (carSpacesSegment.selectedSegmentIndex == 0 ) {
        _numberOfCarSpaces = 1;
    } else if (carSpacesSegment.selectedSegmentIndex == 1) {
        _numberOfCarSpaces = 2;
    } else if (carSpacesSegment.selectedSegmentIndex == 2) {
        _numberOfCarSpaces = 3;
    } else if (carSpacesSegment.selectedSegmentIndex == 3) {
        _numberOfCarSpaces = 4;
    }
}

-(IBAction)selectPetsAllowed:(UISegmentedControl *)sender {
    if (petsYesNo.selectedSegmentIndex == 0) {
        _petsAllowed = YES;
    } else if (petsYesNo.selectedSegmentIndex == 1) {
        _petsAllowed = NO;
    }
}

- (IBAction)submitClicked:(id)sender {
    
    // Display the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];

    PFObject *property = [PFObject objectWithClassName:@"Property"];
    
    if (segment.selectedSegmentIndex == UISegmentedControlNoSegment || bedsSegment.selectedSegmentIndex == UISegmentedControlNoSegment || bathsSegment.selectedSegmentIndex == UISegmentedControlNoSegment || carSpacesSegment.selectedSegmentIndex == UISegmentedControlNoSegment || petsYesNo.selectedSegmentIndex == UISegmentedControlNoSegment)  {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Please complete all fields"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];

    } else {
        [property setObject:self.propertyType forKey:@"PropertyType"];
        [property setObject:[NSNumber numberWithInt:self.numberOfBeds] forKey:@"NumberOfBedrooms"];
        [property setObject:[NSNumber numberWithInt:self.numberOfBathrooms] forKey:@"NumberOfBathrooms"];
        [property setObject:[NSNumber numberWithInt:self.numberOfCarSpaces] forKey:@"NumberOfCarSpaces"];
        [property setObject:[NSNumber numberWithBool:self.petsAllowed] forKey:@"PetsAllowed"];
        [property setObject:propertyAddress.text forKey:@"PropertyAddress"];
        property[@"user"] = [PFUser currentUser].username;
        [property saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
            }
        }];
    }
    
    for (int i = 0; i < [self images].count; i++) {
        PFFile * image = [[self images]objectAtIndex:i];
    
        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 2
            PFObject *propertyObject = [PFObject objectWithClassName:@"PropertyImageObject"];
            propertyObject[@"image"] = image;
            propertyObject[@"user"] = [PFUser currentUser].username;
            propertyObject[@"property"] = property;
            
            // 3
            [propertyObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                // 4
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        } else {
            // 5
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d%%", percentDone);
    }];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    RE_PhotoController *photoController = segue.destinationViewController;
    
    photoController.photoType = @"propertyPhoto";
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action
                 fromViewController:(RE_PhotoController *)photoController withSender:(id)sender {
    if ([photoController.photoType isEqualToString:@"propertyPhoto"]) {
        return TRUE;
    } else return FALSE;
}


-(IBAction)uploadPhotos:(UIStoryboardSegue *)segue {
    // have access to source here
    RE_PhotoController *photoController = [segue sourceViewController];
    [self setImages:[photoController images]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
