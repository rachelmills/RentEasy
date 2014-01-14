//
//  LandlordLoginController.m
//  RentEasy
//
//  Created by Rachel Mills on 9/01/2014.
//  Copyright (c) 2014 Rachel Mills. All rights reserved.
//

#import "LandlordLoginController.h"

//the web location of the service
#define kAPIHost @"http://localhost"
#define kAPIPath @"renteasy/"
@implementation LandlordLoginController

@synthesize user;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(LandlordLoginController*)sharedInstance
{
    static LandlordLoginController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init
//intialize the API class with the destination host name

-(LandlordLoginController*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {
        //initialize the object
        user = nil;
  
  //      [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    //    [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(BOOL)isAuthorized
{
    return [[user objectForKey:@"id"] intValue]>0;
}

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:kAPIPath];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
//    NSMutableURLRequest *apiRequest =
//    [self multipartFormRequestWithMethod:@"POST"
//                                    path:kAPIPath
//                              parameters:params
//               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//                   //TODO: attach file if needed
//               }];
    

    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest: apiRequest];
    
    // not sure if this is needed?
  //  operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

@end
