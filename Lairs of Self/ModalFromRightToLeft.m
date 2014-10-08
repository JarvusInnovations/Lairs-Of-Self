//
//  ModalFromRightToLeft.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/8/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "ModalFromRightToLeft.h"
#import "QuartzCore/QuartzCore.h"

@implementation ModalFromRightToLeft

-(void)perform
{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    NSLog(@"Source: %@", srcViewController);
    NSLog(@"Target: %@", destViewController);
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

@end
