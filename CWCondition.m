//
//  CWCondition.m
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "CWCondition.h"

@implementation CWCondition
@synthesize skies;
@synthesize low,high;

+ (CWCondition *)makeNew {
    CWCondition *condition = [[CWCondition alloc] init];
    NSString *rainy = @"RAINY";
    NSString *cloudy = @"CLOUDY";
    NSString *clear = @"CLEAR";
    NSString *sunny = @"SUNNY";
    
    NSArray *array = @[rainy,clear,cloudy,sunny];
    
    int r = arc4random() % 2;
    condition.skies = [array objectAtIndex:r];
    
    int t = arc4random() % 5;
    t += 67;
    
    condition.temperature = [NSNumber numberWithInt:t];
    return condition;
}

@end