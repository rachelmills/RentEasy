//
//  RE_LandlordTableViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 16/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_LandlordTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *landlordName;
@property (strong, nonatomic) IBOutlet UITextField *landlordEmail;
@property (strong, nonatomic) IBOutlet UITextField *landlordPhoneNo;

@end
