//
//  RE_LandlordTableViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 16/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_LandlordTableViewController : UITableViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *landlordFirstName;
@property (strong, nonatomic) IBOutlet UITextField *landlordEmail;
@property (strong, nonatomic) IBOutlet UITextField *landlordPhoneNo;
- (IBAction)loginClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *roundedButton;
@property (strong, nonatomic) IBOutlet UITextField *landlordPassword;
@property (strong, nonatomic) IBOutlet UITextField *landlordSurname;

@end
