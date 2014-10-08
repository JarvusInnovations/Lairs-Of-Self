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
@property (strong, nonatomic) UIButton *capture;
@property (strong, nonatomic) UIButton *back;
@end

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
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
        placeEyes.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30.0f];
        placeEyes.textColor = [UIColor whiteColor];
        placeEyes.textAlignment = NSTextAlignmentCenter;
        [self addSubview:placeEyes];
        
        // Get display type from settings
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString * display_type = [standardUserDefaults objectForKey:@"display_type"];

        // Diplay type 1
        if ([display_type isEqualToString:@"1"]) {
            NSLog(@"Display Type 1");
            UIImage *eyeOverlayImage1 = [UIImage imageNamed:@"eyeoverlays-1.png"];
            UIImageView *eyeOverlay1 = [[UIImageView alloc] initWithImage:eyeOverlayImage1];
            eyeOverlay1.contentMode = UIViewContentModeScaleToFill;
            
            int mask1X = [[standardUserDefaults objectForKey:@"maskOneX"] intValue];
            int mask1Y = [[standardUserDefaults objectForKey:@"maskOneY"] intValue];
            int mask1Height = [[standardUserDefaults objectForKey:@"maskOneHeight"] intValue];
            int mask1Width = [[standardUserDefaults objectForKey:@"maskOneWidth"] intValue];
            
            if (!mask1X) {
                mask1X = 170;
            }
            if (!mask1Y) {
                mask1Y = 250;
            }
            if (!mask1Height) {
                mask1Height = 500;
            }
            if (!mask1Width) {
                mask1Width = 295;
            }
            
            eyeOverlay1.frame = CGRectMake(mask1X, mask1Y, mask1Width, mask1Height);
            eyeOverlay1.alpha = .5;
            [self addSubview:eyeOverlay1];
            
        // Display type 2
        } else {
            NSLog(@"Display Type 2");
            UIImage *eyeOverlayImage2 = [UIImage imageNamed:@"eyeoverlays-2.png"];
            UIImageView *eyeOverlay2 = [[UIImageView alloc] initWithImage:eyeOverlayImage2];
            eyeOverlay2.contentMode = UIViewContentModeScaleToFill;
            
            int mask2X = [[standardUserDefaults objectForKey:@"maskTwoX"] intValue];
            int mask2Y = [[standardUserDefaults objectForKey:@"maskTwoY"] intValue];
            int mask2Height = [[standardUserDefaults objectForKey:@"maskTwoHeight"] intValue];
            int mask2Width = [[standardUserDefaults objectForKey:@"maskTwoWidth"] intValue];
            
            if (!mask2X) {
                mask2X = 225;
            }
            if (!mask2Y) {
                mask2Y = 300;
            }
            if (!mask2Height) {
                mask2Height = 123;
            }
            if (!mask2Width) {
                mask2Width = 300;
            }
            
            eyeOverlay2.frame = CGRectMake(mask2X, mask2Y, mask2Width, mask2Height);
            eyeOverlay2.alpha = .4;
            [self addSubview:eyeOverlay2];
        }
        
        UIImage *captureImage = [UIImage imageNamed:@"LOSButtonRightWhite.png"];
        _capture = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _capture.frame = CGRectMake(430, 878, 125, 86);
        [_capture setBackgroundImage:captureImage forState:UIControlStateNormal];
        [_capture setTitle:@"Capture" forState:UIControlStateNormal];
        [_capture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _capture.titleLabel.numberOfLines = 1;
        _capture.titleLabel.adjustsFontSizeToFitWidth = YES;
        _capture.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_capture sizeThatFits:CGSizeMake(274, 189)];
        [_capture addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_capture];

        
        UIImage *backImage = [UIImage imageNamed:@"LOSButtonLeftWhite.png"];
        _back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _back.frame = CGRectMake(213, 878, 125, 86);
        [_back setBackgroundImage:backImage forState:UIControlStateNormal];
        [_back setTitle:@"Back" forState:UIControlStateNormal];
        [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _back.titleLabel.numberOfLines = 1;
        _back.titleLabel.adjustsFontSizeToFitWidth = YES;
        _back.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_back sizeThatFits:CGSizeMake(274, 189)];
        [_back addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_back];
        
    }
    return self;
}

- (IBAction)captureImage:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"captureImage" object:self];
}

- (IBAction)backToHome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backToHome" object:self];
}
@end
