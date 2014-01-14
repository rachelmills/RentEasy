//
//  RE_AddPropertyControllerViewController.h
//  RentEasy
//
//  Created by Rachel Mills on 28/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_AddPropertyControllerViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UISegmentedControl *segment;
    IBOutlet UISegmentedControl *bedsSegment;
    IBOutlet UISegmentedControl *bathsSegment;
    IBOutlet UISegmentedControl *carSpacesSegment;
    IBOutlet UISegmentedControl *petsYesNo;
}

- (IBAction)selectPropertyType:(UISegmentedControl *)sender;
- (IBAction)selectNumberOfBeds:(UISegmentedControl *)sender;
- (IBAction)selectNumberOfBathrooms:(UISegmentedControl *)sender;
- (IBAction)selectNumberOfCarSpaces:(UISegmentedControl *)sender;
- (IBAction)selectPetsAllowed:(UISegmentedControl *)sender;


@property (strong, nonatomic) NSString *propertyType;
@property NSInteger numberOfBeds;
@property NSInteger numberOfBathrooms;
@property NSInteger numberOfCarSpaces;
@property (nonatomic) BOOL petsAllowed;



@end
