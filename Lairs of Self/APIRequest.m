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
        NSString *requestUrlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"server_address"];
        _requestUrl = [NSURL URLWithString:requestUrlString];
    }
    return self;
}

-(void)makeAPIRequestWithMask:(NSInteger)index andUserImage:(UIImage*)image {
    
    NSLog(@"Make API with Mask %ld : %@", (long)index, image);
    NSLog(@"Request URL %@", _requestUrl);
    
    NSError *err;
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"boundry"];
    NSString *boundary = [NSString stringWithFormat:@"boundry"];
    NSString *FileParamConstant = [NSString stringWithFormat:@"userImage.jpg"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add mask index
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%ld\"\r\n\r\n", (long)index] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%ld\r\n", (long)index] dataUsingEncoding:NSUTF8StringEncoding]];

    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (image) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:_requestUrl];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSLog(@"Response Data %@", responseData);
    NSLog(@"Response %@", response);
    
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
