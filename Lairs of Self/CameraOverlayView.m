//
//  CameraOverlayView.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "CameraOverlayView.h"
#import "CameraViewController.h"

@interface CameraOverlayView()
@property (strong, nonatomic) UIButton *captureImageButton;
@property (strong, nonatomic) UIButton *retakeImageButton;
@property (strong, nonatomic) UIButton *proceedWithImageButton;
@end

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        NSLog(@"Width %f Height: %f", self.frame.size.width, self.frame.size.height);
        
        // Top Space Filler
        CGRect topFillerRect = CGRectMake(0, 0, self.frame.size.width, 110);
        UIView *fillerTop = [[UIView alloc] initWithFrame:topFillerRect];
        fillerTop.backgroundColor = [UIColor blackColor];
        [self addSubview:fillerTop];
        
        // Bottom Space Filler
        CGRect bottomFillerRect = CGRectMake(0, 875, self.frame.size.width, 200);
        UIView *fillerBottom = [[UIView alloc] initWithFrame:bottomFillerRect];
        fillerBottom.backgroundColor = [UIColor blackColor];
        [self addSubview:fillerBottom];
 
        // Background Panel
        UIImage *background = [UIImage imageNamed:@"00LOSMaskOverlays_BlackMask800.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        backgroundView.frame = CGRectMake(0, 100, self.frame.size.width, 800);
        [self addSubview:backgroundView];
        
        
        // Top Label
        UILabel *placeEyes = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width , 100)];
        placeEyes.attributedText = [[NSAttributedString alloc] initWithString:@"Place Your Eyes"];
        placeEyes.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:35.0f];
        placeEyes.textColor = [UIColor whiteColor];
        placeEyes.textAlignment = NSTextAlignmentCenter;
        [self addSubview:placeEyes];
        
        // Get display type from settings
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString * display_type = [standardUserDefaults objectForKey:@"display_type"];

        // Diplay type 1
        if ([display_type isEqualToString:@"1"]) {
            NSLog(@"Display Type 1");
            // Left eye overlay
            UIImage *leftEye = [UIImage imageNamed:@"test1.png"];
            UIImageView *leftEyeView = [[UIImageView alloc] initWithImage:leftEye];
            leftEyeView.frame = CGRectMake(50, 200, 200, 200);
            leftEyeView.alpha = .5;
            leftEyeView.contentMode = UIViewContentModeCenter;
            [self addSubview:leftEyeView];
            
            // Right eye overlay
            UIImage *rightEye = [UIImage imageNamed:@"test1.png"];
            UIImageView *rightEyeView = [[UIImageView alloc] initWithImage:rightEye];
            rightEyeView.frame = CGRectMake(400, 200, 200, 200);
            rightEyeView.alpha = .4;
            rightEyeView.contentMode = UIViewContentModeCenter;
            [self addSubview:rightEyeView];
            
        // Display type 2
        } else {
            NSLog(@"Display Type 2");
            // Left eye overlay
            UIImage *leftEye = [UIImage imageNamed:@"test1.png"];
            UIImageView *leftEyeView = [[UIImageView alloc] initWithImage:leftEye];
            leftEyeView.frame = CGRectMake(50, 400, 200, 200);
            leftEyeView.alpha = .5;
            leftEyeView.contentMode = UIViewContentModeCenter;
            [self addSubview:leftEyeView];
            
            // Right eye overlay
            UIImage *rightEye = [UIImage imageNamed:@"test1.png"];
            UIImageView *rightEyeView = [[UIImageView alloc] initWithImage:rightEye];
            rightEyeView.frame = CGRectMake(400, 400, 200, 200);
            rightEyeView.alpha = .4;
            rightEyeView.contentMode = UIViewContentModeCenter;
            [self addSubview:rightEyeView];
        }
        
        [self createCaptureImageButton];
        [self addSubview:_captureImageButton];
    }
    return self;
}

- (IBAction)captureImage:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"captureImage" object:self];
    
    // [_captureImageButton removeFromSuperview];
}
- (void)createCaptureImageButton{
    if (_captureImageButton == nil) {
        UIImage *captureButtonImage = [UIImage imageNamed:@"LOSButtonRightWhite.png"];
        _captureImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _captureImageButton.frame = CGRectMake(self.frame.size.width/2-62.5, 854, 125, 86);
        [_captureImageButton setBackgroundImage:captureButtonImage forState:UIControlStateNormal];
        [_captureImageButton setTitle:@"Capture" forState:UIControlStateNormal];
        [_captureImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _captureImageButton.titleLabel.numberOfLines = 1;
        _captureImageButton.titleLabel.adjustsFontSizeToFitWidth = YES;

        _captureImageButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_captureImageButton sizeThatFits:CGSizeMake(274, 189)];
        [_captureImageButton addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
