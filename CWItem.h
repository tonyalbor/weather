//
//  CWItem.h
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCondition.h"
#import "CWScore.h"
#import <Parse/Parse.h>

@interface CWItem : NSObject

/*
 
 NSMapTable *conditions;
 
 ---------------------------------------------------------------------------------------
        || ... |   76   |   77   |  ....  |   88   |   89   |   90   |  ....  |  ....  |
 =======================================================================================
 Clear  || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 ---------------------------------------------------------------------------------------
 Sunny  || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 ---------------------------------------------------------------------------------------
 Cloudy || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 ---------------------------------------------------------------------------------------
 Rainy  || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 ---------------------------------------------------------------------------------------
 Snowy  || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 ---------------------------------------------------------------------------------------
 Foggy  || ... | {X, Y} | {X, Y} | {X, Y} |  ....  | {X, Y} | {X, Y} | {X, Y} |  ....  |
 .
 .                                                                X: Temperature Score
 .                                                                       Y: Times Used
 ---------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------
 
 
 // key:    (NSString *)   - skies
 // object: (NSMapTable *) - // key:    (NSNumber *)   - temperature
                             // object: (CWScore *)    - score
                             //                          (temperature score, times used)
 
 */
@property (strong, nonatomic) NSMapTable *conditions;

@property (strong, nonatomic) NSString *name;
 
// will be either "top" or "bottoms" (maybe "jacket" as well)
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *imageName;

// used to keep track of how many times item has been used
@property (strong, nonatomic) NSNumber *itemScore;

// probably default to NO and the user can toggle it to YES
@property (nonatomic) BOOL isGoodForRain;
@property (nonatomic) BOOL isGoodForSnow;

// determines if item is possible choice for user
- (BOOL)isPossibleChoiceForCondition:(CWCondition *)condition;

// adds to temperature map after receiving input
- (void)addToConditions:(CWCondition *)condition withScoreModifier:(NSNumber *)scoreModifier;

- (CWScore *)getScoreForCondition:(CWCondition *)condition;

+ (CWItem *)makeNew;
+ (CWItem *)newItemWithType:(NSString *)itemType andName:(NSString *)name;

@end