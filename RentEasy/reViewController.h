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

@property (strong, nonatomic) IBOutlet UIButton *landlordLogin;
@property (strong, nonatomic) IBOutlet UIButton *landlordRegister;

@property (strong, nonatomic) IBOutlet UIButton *tenantLogin;
@property (strong, nonatomic) IBOutlet UIButton *tenantRegister;

@property (strong, nonatomic) IBOutlet UIButton *serviceProvicerLogin;
@property (strong, nonatomic) IBOutlet UIButton *serviceProviderRegister;

@end
