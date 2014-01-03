//
//  CWScore.m
//  
//
//  Created by Tony Albor on 12/29/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "CWScore.h"

@implementation CWScore

+ (CWScore *)makeNew {
    CWScore *score = [[CWScore alloc] init];
    score.temperatureScore = @0;
    score.timesUsed = @0;
    
    return score;
}

@end
