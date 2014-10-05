//
//  CameraViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraOverlayView.h"

@interface CameraViewController ()

@property (strong, nonatomic)UIImagePickerController *picker;
@property (strong, nonatomic)CameraOverlayView *overlay;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.cameraView.image == nil) {
        _retakeButton.hidden = true;
        _proceedButton.hidden = true;
    } else {
        _retakeButton.hidden = false;
        _proceedButton.hidden = false;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:_maskImage];
    
    if (self.cameraView.image == nil) {
        _overlay = [[CameraOverlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        _picker = [[UIImagePickerController alloc] init];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        _picker.showsCameraControls = NO;
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.cameraOverlayView = _overlay;
        [self presentViewController:_picker animated:NO completion:NULL];
        
    } else {
        [self.view bringSubviewToFront:_retakeButton];
        [self.view bringSubviewToFront:_proceedButton];
        _retakeButton.hidden = false;
        _proceedButton.hidden = false;
        _maskImage.hidden = false;
        //[self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _userImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.cameraView.image = _userImage;
    [_picker dismissViewControllerAnimated:NO completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)retakePicture:(id)sender {
    _userImage = nil;
    self.cameraView.image = nil;
    [self presentViewController:_picker animated:NO completion:NULL];
}

- (IBAction)proceedWithPicture:(id)sender {
    NSLog(@"procdeed with picture");
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(_userImage) forKey:@"userImage"];
    [self performSegueWithIdentifier:@"selectMask" sender:self];
}

#pragma - mark Notifications

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(captureImageFromOverlay:)
     name:@"captureImage"
     object:nil];
}

-(void)captureImageFromOverlay:(NSNotification *) notification {
    [_picker takePicture];
}

@end
