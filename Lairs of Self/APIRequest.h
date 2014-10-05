//
//  APIRequest.h
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/4/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaskSelectionViewController.h"

@interface APIRequest : NSObject

@property (nonatomic, strong) NSURL *requestUrl;

-(void)makeAPIRequest;
-(void)makeAPIRequestWithMask:(NSInteger)index andUserImage:(UIImage *)image;

@end
