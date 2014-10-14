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
@property (nonatomic, strong) NSURL *maskURL;
@property (nonatomic, strong) NSURL *omitUrl;

-(BOOL)makeAPIRequestWithMask:(NSInteger)index andUserImage:(UIImage *)image;
-(void)sendOmitRequest;

@end
