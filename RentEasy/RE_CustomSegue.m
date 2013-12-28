//
//  RE_CustomSegue.m
//  RentEasy
//
//  Created by Rachel Mills on 27/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_CustomSegue.h"

@implementation RE_CustomSegue

- (void)perform

{
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
