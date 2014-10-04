//
//  APIRequest.h
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/4/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject

@property (nonatomic, strong) NSURL *requestUrl;

-(void)makeAPIRequest;

@end
