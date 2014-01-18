//
//  RE_PhotoController.m
//  RentEasy
//
//  Created by Rachel Mills on 30/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_PhotoController.h"
#import <Parse/Parse.h>
#import "RE_AddPropertyControllerViewController.h"

@interface RE_PhotoController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *photoToUpload;
@property (strong, nonatomic) IBOutlet UIButton *takePhoto;




@end

@implementation RE_PhotoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        [self takePhoto].enabled = NO;
         self.images = [[NSMutableArray alloc] init];
    }
}

#pragma mark - Private methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhotoPressed:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    [self uploadPhoto].enabled = TRUE;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self uploadSelectedPhotos:chosenImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)uploadSelectedPhotos:(id)sender
{
        
    NSData *imageData = UIImageJPEGRepresentation(self.photoToUpload.image, 90);
    // Upload new picture
    PFFile *image = [PFFile fileWithName:@"img" data:imageData];
    
    // add to array of images
    [_images addObject:image];
}
@end
