//
//  RE_AddPropertyControllerViewController.m
//  RentEasy
//
//  Created by Rachel Mills on 28/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_AddPropertyControllerViewController.h"
#import "SBJson.h"

@interface RE_AddPropertyControllerViewController ()

@end

@implementation RE_AddPropertyControllerViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
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
        _numberOfBeds = @"0";
    }
}

- (IBAction)selectNumberOfBeds:(UISegmentedControl *)sender {
    if (bedsSegment.selectedSegmentIndex == 0) {
        _numberOfBeds = @"1";
    } else if (bedsSegment.selectedSegmentIndex == 1) {
        _numberOfBeds = @"2";
    } else if (bedsSegment.selectedSegmentIndex == 2) {
        _numberOfBeds = @"3";
    } else if (bedsSegment.selectedSegmentIndex == 3) {
        _numberOfBeds = @"4";
    } else if (bedsSegment.selectedSegmentIndex == 4) {
        _numberOfBeds = @"5";
    } else if (bedsSegment.selectedSegmentIndex == 5) {
        _numberOfBeds = @"6";
    }
}

- (IBAction)selectNumberOfBathrooms:(UISegmentedControl *)sender {
    if (bathsSegment.selectedSegmentIndex == 0) {
        _numberOfBathrooms = @"1";
    } else if (bathsSegment.selectedSegmentIndex == 1) {
        _numberOfBathrooms = @"2";
    } else if (bathsSegment.selectedSegmentIndex == 2) {
        _numberOfBathrooms = @"3";
    } else if (bathsSegment.selectedSegmentIndex == 3) {
        _numberOfBathrooms = @"4";
    }
}

- (IBAction)selectNumberOfCarSpaces:(UISegmentedControl *)sender {
    if (carSpacesSegment.selectedSegmentIndex == 0 ) {
        _numberOfCarSpaces = @"1";
    } else if (carSpacesSegment.selectedSegmentIndex == 1) {
        _numberOfCarSpaces = @"2";
    } else if (carSpacesSegment.selectedSegmentIndex == 2) {
        _numberOfCarSpaces = @"3";
    } else if (carSpacesSegment.selectedSegmentIndex == 3) {
        _numberOfCarSpaces = @"4";
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
    @try {
        
        // if any fields  empty
        if(_propertyType == nil || _numberOfBeds == nil) {
            [self alertStatus:@"Please complete all fields" :@"Property not saved!"];
        } else {

        
        NSString *post =[[NSString alloc] initWithFormat:@"propertyType=%@&numberOfBedrooms=%d&numberOfBathrooms=%d&numberOfCarSpaces=%d&petsAllowed=%hhd",_propertyType, [_numberOfBeds intValue], [_numberOfBathrooms intValue], [_numberOfCarSpaces intValue], _petsAllowed];
        NSLog(@"PostData: %@",post);
            
        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/renteasy/saveProperty.php"];
            
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
            
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
        NSLog(@"Response code: %d", [response statusCode]);
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            NSLog(@"%@",jsonData);
            NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
            NSLog(@"%d",success);
            if(success == 1)
            {
                NSLog(@"Property saved");
                [self alertStatus:@"Property saved." :@"Property saved!"];
            } else {
                NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                [self alertStatus:error_msg :@"Property not saved1!"];
            }
                
        } else {
            if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Property not saved2!"];
        }
        }
    }
    
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Property not saved." :@"Property not saved3!"];
    }
}
                         
- (void) alertStatus:(NSString *)msg :(NSString *)title {
   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
   }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
