//
//  MaskSelectionViewController.h
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "APIRequest.h"
#import "SharingViewController.h"
#import "EnterInstallationViewController.h"

@interface MaskSelectionViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UIButton *proceedButton;
@property (strong) UIActivityIndicatorView *indicator;
- (IBAction)proceedButtonClicked:(id)sender;

@end
    