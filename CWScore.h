//
//  CWScore.h
//  
//
//  Created by Tony Albor on 12/29/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWScore : NSObject

@property (strong, nonatomic) NSNumber *temperatureScore;
@property (strong, nonatomic) NSNumber *timesUsed;

+ (CWScore *)makeNew;

@end
