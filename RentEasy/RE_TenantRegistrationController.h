//
//  RE_TenantRegistrationController.h
//  RentEasy
//
//  Created by Rachel Mills on 22/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_TenantRegistrationController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *tenantUsername;
@property (strong, nonatomic) IBOutlet UITextField *tenantPassword;
@property (strong, nonatomic) IBOutlet UITextField *tenantFirstName;
@property (strong, nonatomic) IBOutlet UITextField *tenantSurname;
@property (strong, nonatomic) IBOutlet UITextField *tenantTel;
@property (strong, nonatomic) IBOutlet UITextField *tenantEmail;

@end
