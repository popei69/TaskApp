//
//  WebServiceManager.h
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

- (void)getResultFromCustomerQueueRequest:(NSDictionary*)data;
- (void)getResultWithError:(NSError*) error;

@end

@interface WebServiceManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) id<WebServiceDelegate> delegate;

- (void)requestCustomerQueue;

+ (id)sharedManager;


@end


