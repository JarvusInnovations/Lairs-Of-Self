//
//  CameraViewController.h
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *cameraView;
@property (strong, nonatomic) IBOutlet UIImageView *maskImage;
@property (strong, nonatomic) IBOutlet UIButton *proceedButton;
@property (strong, nonatomic) IBOutlet UIButton *retakeButton;
@property (strong, nonatomic) IBOutlet UIImage *userImage;

- (IBAction)retakePicture:(id)sender;
- (IBAction)proceedWithPicture:(id)sender;

@end
