//
//  RE_PhotoController.h
//  RentEasy
//
//  Created by Rachel Mills on 30/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RE_PhotoController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *uploadPhoto;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSString *photoType;

//-(IBAction)takePhoto:(UIButton *)sender;
//-(IBAction)selectPhoto:(UIButton *)sender;
//-(void)savePhotos:(UIImage *)photos;
//-(IBAction)uploadImage:(UIButton *)sender;


@end


