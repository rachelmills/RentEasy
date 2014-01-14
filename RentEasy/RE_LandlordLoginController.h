//
//  RE_LandlordLoginController.h
//  RentEasy
//
//  Created by Rachel Mills on 21/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_LandlordLoginController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *landlordEmail;
@property (strong, nonatomic) IBOutlet UITextField *landlordPassword;
@property NSArray *fieldArray;

@end
