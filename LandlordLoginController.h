//
//  LandlordLoginController.h
//  RentEasy
//
//  Created by Rachel Mills on 9/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

//Call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface LandlordLoginController : AFHTTPRequestOperationManager
    //the authorized user
    @property (strong, nonatomic) NSDictionary* user;

+(LandlordLoginController*)sharedInstance;

// check whether there's an authorised user
-(BOOL)IsAuthorised;

// send a command to the server
-(void)commandWithParams:(NSMutableDictionary*) params onCompletion:(JSONResponseBlock)completionBlock;
@end
