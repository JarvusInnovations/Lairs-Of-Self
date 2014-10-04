//
//  APIRequest.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/4/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "APIRequest.h"


@implementation APIRequest

- (id)init {
    self = [super init];
    if (self) {
        _requestUrl =[NSURL URLWithString:@"http://tylers-mac.local:8080"];
    }
    return self;
}

-(void)makeAPIRequest {
    NSError* error;
    NSError *err;
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"maskID", @"1", @"image", @"key2", nil];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:_requestUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"Response Data %@", responseData);
    NSLog(@"Response %@", response);
    
}

@end
