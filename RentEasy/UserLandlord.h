//
//  UserLandlord.h
//  RentEasy
//
//  Created by Rachel Mills on 14/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserLandlord : PFUser

@property (nonatomic, strong) NSString *userType;

@end
