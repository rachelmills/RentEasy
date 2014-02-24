//
//  reAppDelegate.m
//  RentEasy
//
//  Created by Rachel Mills on 14/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "REAppDelegate.h"
#import <Parse/Parse.h>
#import "UserLandlord.h"

@implementation REAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Register app with the service
    [Parse setApplicationId:@"R8sZNjhOSNOsbptNXfy1etfxgdcc9GSx2CfgTawu" clientKey:@"alEt3Sjtd97BozuPDnES29EOkc4HSyPsKIjjZFQw"];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [self handlePush:launchOptions];
    
    return YES;
}

- (void)handlePush:(NSDictionary *)launchOptions {
    // Extract the notification payload dictionary
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    // Check if the app was open from a notification and a user is logged in
    if (remoteNotificationPayload && [PFUser currentUser]) {
        
        // Push the referenced photo into view
        NSString *message = [remoteNotificationPayload objectForKey:@"key1"];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:message
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
    
    [currentInstallation addUniqueObject:@"" forKey:@"channels"];
    
    if ([PFUser currentUser]) {
        if ([[[PFUser currentUser] objectForKey:@"userType" ] isEqualToString:@"Landlord"]) {
            // Make sure they are subscribed to their private push channel
            NSString *privateChannelName = [[PFUser currentUser] objectForKey:@"objectId"];
            if (privateChannelName && privateChannelName.length > 0) {
                NSLog(@"Subscribing user to %@", privateChannelName);
                [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channels"];
                
            }
        }
        
    }
    // Save the added channel(s)
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received notification: %@", userInfo);
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
