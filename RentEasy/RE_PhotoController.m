//
//  RE_PhotoController.m
//  RentEasy
//
//  Created by Rachel Mills on 30/12/2013.
//  Copyright (c) 2013 Rachel Mills. All rights reserved.
//

#import "RE_PhotoController.h"
#import "SBJson.h"

@interface RE_PhotoController ()

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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self uploadImage:chosenImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)uploadImage:(UIImage *)photo {
    NSData *imageData = UIImageJPEGRepresentation(photo, 90);
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/renteasy/savePhoto.php"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"photo=%@",photo];
    NSLog(@"PostData: %@",post);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
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
    NSLog(@"%@",[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding]);
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);


}

/*- (IBAction)uploadImage: (UIButton *)sender {
    NSLog(@"here");
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 90);

    NSString *urlString = @"http://localhost:8080/renteasy/savePhoto.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(returnString);
}
*/



- (void)savePhotos:(UIImage *)photo {
    @try {
        
        // if any fields  empty
        if(photo == nil) {
            [self alertStatus:@"Please complete all fields" :@"Property not saved!"];
        } else {
            
            
            NSString *post =[[NSString alloc] initWithFormat:@"photo=%@",photo];
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://localhost:8080/renteasy/savePhoto.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %d", [response statusCode]);
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                NSLog(@"%@",jsonData);
                NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
                NSLog(@"%d",success);
                if(success == 1)
                {
                    NSLog(@"Photo uploaded");
                    [self alertStatus:@"Photo uploaded." :@"Photo uploaded!"];
                } else {
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                    [self alertStatus:error_msg :@"Photo not uploaded1!"];
                }
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Photo not uploaded2!"];
            } 
        }
    }
 
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Photo not uploaded." :@"Photo not uploaded3!"];
    }
}

- (void) alertStatus:(NSString *)msg :(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}


@end
