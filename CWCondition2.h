//
//  CWCondition.h
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>


// CWCondition
// Class used to determine the current
// temperature and skies
//
// Clear
// Sunny
// Rainy
// Snowy
// Foggy
// Cloudy
//

//  8AM ~ 12PM
// 12PM ~  4PM
//  4PM ~  8PM
//  8PM ~ 12AM
// 12AM ~  4AM
//  4AM ~  8AM
//
@interface CWCondition : NSObject

@property (strong, nonatomic) NSString *skies;
@property (strong, nonatomic) NSNumber *low;
@property (strong, nonatomic) NSNumber *high;
@property (strong, nonatomic) NSNumber *temperature;

+ (CWCondition *)makeNew;

@end