//
//  CameraViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraOverlayView.h"
#import "ViewController.h"

@interface CameraViewController ()

@property (strong, nonatomic)UIImagePickerController *picker;
@property (strong, nonatomic)CameraOverlayView *overlay;
@property (nonatomic, assign) BOOL returnToHome;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setReturnToHome:NO];
    NSLog(@"Camera View Did Load");
    if (self.cameraView.image == nil) {
        _retakeButton.hidden = true;
        _proceedButton.hidden = true;
        _proceedLabel.hidden = true;
    } else {
        _retakeButton.hidden = false;
        _proceedButton.hidden = false;
        _proceedLabel.hidden = false;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Camera View Did Appear");
    [self.view bringSubviewToFront:_maskImage];

    //NSLog(@"Retun to Home Value: %hhd", _returnToHome);
    
    if (_returnToHome == YES) {
        [self performSegueWithIdentifier:@"goToHome" sender:self];
    }
    
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
        [self.view bringSubviewToFront:_proceedLabel];
        _retakeButton.hidden = false;
        _proceedButton.hidden = false;
        _proceedLabel.hidden = false;
        _maskImage.hidden = false;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *unflippedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    _userImage = [UIImage imageWithCGImage:unflippedImage.CGImage
                                         scale:unflippedImage.scale
                                   orientation:UIImageOrientationLeftMirrored];
    
    self.cameraView.image = _userImage;
    [_picker dismissViewControllerAnimated:NO completion:nil];
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
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"selectMask" sender:self];
}

#pragma mark - Navigation
////In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    //Get the new view controller using [segue destinationViewController].
//    //Pass the selected object to the new view controller.
//    NSLog(@"Prepare for Segue");
//}

#pragma - mark Notifications

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(captureImageFromOverlay:)
     name:@"captureImage"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goBackToHome:)
     name:@"backToHome"
     object:nil];
}

-(void)captureImageFromOverlay:(NSNotification *) notification {
    [_picker takePicture];
}

-(void)goBackToHome:(NSNotification *) notification {
    NSLog(@"Set return to home");
    [self setReturnToHome:YES];
    [_picker dismissViewControllerAnimated:NO completion:nil];    
}
@end
