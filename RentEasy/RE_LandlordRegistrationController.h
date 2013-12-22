//
//  RE_LandlordRegistrationController.h
//  RentEasy
//
//  Created by Rachel Mills on 22/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_LandlordRegistrationController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *landlordUsername;
@property (strong, nonatomic) IBOutlet UITextField *landlordPassword;
@property (strong, nonatomic) IBOutlet UITextField *landlordFirstName;
@property (strong, nonatomic) IBOutlet UITextField *landlordSurname;
@property (strong, nonatomic) IBOutlet UITextField *landlordTel;
@property (strong, nonatomic) IBOutlet UITextField *landlordEmail;

@end
