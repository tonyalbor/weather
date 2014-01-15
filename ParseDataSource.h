//
//  ParseDataSource.h
//  weather-retry
//
//  Created by Tony Albor on 1/14/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWClosetDataSource.h"

@interface ParseDataSource : NSObject

+ (ParseDataSource *)sharedDataSource;

//
- (void)getClosetItems;

// create a parse readable string of sky from CW
// create a CW readable string of sky from parse



@end
