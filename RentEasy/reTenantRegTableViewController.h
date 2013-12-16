//
//  reTenantTableViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 14/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RETenantRegTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *tenantName;
@property (strong, nonatomic) IBOutlet UITextField *tenantEmail;
@property (strong, nonatomic) IBOutlet UITextField *tenantPhoneNo;

@end
