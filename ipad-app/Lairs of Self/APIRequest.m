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
        _maskURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/submit", requestUrlString]];
        _omitUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/omit", requestUrlString]];
    }
    
    return self;
}

-(BOOL)makeAPIRequestWithMask:(NSInteger)index andUserImage:(UIImage*)image {
    
    
    UIImage *finalImage = [UIImage imageWithCGImage:image.CGImage
                                     scale:image.scale
                               orientation:UIImageOrientationRight];
    
    index++;
    
    NSLog(@"Make API with Mask %ld : %@", (long)index, image);
    NSLog(@"Request URL %@", _requestUrl);
    
    NSError *err;
    NSError *dictErr;
    NSString *BoundaryConstant = [NSString stringWithFormat:@"boundry"];
    NSString *boundary = [NSString stringWithFormat:@"boundry"];
    NSString *FileParamConstant = [NSString stringWithFormat:@"photo"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [NSString stringWithFormat:@"mask"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%ld\r\n", (long)index] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(finalImage, 1.0);
    if (image) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setURL:_maskURL];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if (!err) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&dictErr];

        if (!dictErr && [[res objectForKey:@"success"]boolValue] == YES) {
            
            NSLog(@"Response: %@", res[@"password"]);
            NSLog(@"Success: %@", res[@"success"]);
            
            [[NSUserDefaults standardUserDefaults] setObject:res[@"password"] forKey:@"password"];
            NSLog(@"return true");
            return true;
        }
    }
    return false;
}

-(void)sendOmitRequest {
    NSError *err;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:_omitUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
}

@end
