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

-(IBAction)selectPropertyType {
    if (segment.selectedSegmentIndex == 0) {
        self.view.backgroundColor = [UIColor redColor];
        _propertyType = @"House";
        
    } else if (segment.selectedSegmentIndex == 1) {
        self.view.backgroundColor = [UIColor blueColor];
        _propertyType = @"Unit";
        
    } else if (segment.selectedSegmentIndex == 2) {
        self.view.backgroundColor = [UIColor greenColor];
        _propertyType = @"Townhouse";
    }
}

- (IBAction)submitClicked:(id)sender {
    @try {
        
        // if both strings empty
        NSString *post =[[NSString alloc] initWithFormat:@"propertyType=%@",_propertyType];
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
