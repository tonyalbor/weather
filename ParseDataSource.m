//
//  ParseDataSource.m
//  weather-retry
//
//  Created by Tony Albor on 1/14/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "ParseDataSource.h"

@implementation ParseDataSource

static ParseDataSource *_sharedDataSource = nil;

+ (ParseDataSource *)sharedDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataSource = [[ParseDataSource alloc] init];
    });
    
    return _sharedDataSource;
}

@end
