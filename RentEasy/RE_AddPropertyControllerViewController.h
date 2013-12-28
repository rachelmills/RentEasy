//
//  RE_AddPropertyControllerViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 28/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_AddPropertyControllerViewController : UIViewController {
    
    IBOutlet UISegmentedControl *segment;

    
}

-(IBAction)selectPropertyType;
@property (strong, nonatomic) NSString *propertyType;

@end
