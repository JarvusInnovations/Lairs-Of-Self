//
//  NoPushAnimationSegue.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/4/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "NoPushAnimationSegue.h"

@implementation NoPushAnimationSegue 

-(void) perform{
    NSLog(@"Segue Preformed");
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
