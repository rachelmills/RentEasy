//
//  reViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 14/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface REViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)tenantLoginPressed:(id)sender;
- (IBAction)landlordLoginPressed:(id)sender;

@end
