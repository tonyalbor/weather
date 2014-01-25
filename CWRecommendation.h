//
//  CWRecommendation.h
//  weather-retry
//
//  Created by Tony Albor on 1/21/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDataSource.h"

@interface CWRecommendation : NSObject

+ (CWRecommendation *)sharedDataSource;

@property (nonatomic) BOOL isActive;

//@property (strong, nonatomic) CWItem *item;

@property (strong, nonatomic) NSString *topName;
@property (strong, nonatomic) NSString *topImageName;

@property (strong, nonatomic) NSString *bottomsName;
@property (strong, nonatomic) NSString *bottomsImageName;

+ (BOOL)isActive;
+ (void)getRecommendationStatus;

+ (void)setTop:(CWItem *)item;
+ (void)setBottoms:(CWItem *)item;
+ (void)setJacket:(CWItem *)item;

+ (CWItem *)getTop;
+ (CWItem *)getBottoms;
+ (CWItem *)getJacket;

+ (void)setSkies:(NSMutableArray *)array;
+ (void)setTemperatures:(NSMutableArray *)array;

+ (NSArray *)getSkies;
+ (NSArray *)getTemperatures;

+ (void)setNumberOfHours:(int)number;
+ (NSNumber *)getNumberOfHours;

+ (void)setRecommendationActive;
+ (void)cancelActiveRecommendation;

@end