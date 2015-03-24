//
//  WebServiceManager.m
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import "WebServiceManager.h"

#define kLOGIN      @"codetest1"
#define kPASSWORD   @"codetest100"

@implementation WebServiceManager

+ (id)sharedManager {
    static WebServiceManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)requestCustomerQueue {
    
    NSString *urlString = @"https://app.qudini.com/api/queue/gj9fs";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kLOGIN, kPASSWORD];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            // ERROR DURING REQUEST
            [_delegate getResultWithError:connectionError];
            return;
        }
        
        NSError *jsonError = nil;
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError != nil) {
            // ERROR DURING PARSE JSON
            [_delegate getResultWithError:jsonError];
            return;
        }
        
        [_delegate getResultFromCustomerQueueRequest:jsonDictionary];
        
        
    }];
}

@end
