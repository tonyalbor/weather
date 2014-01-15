//
//  CWClosetDataSource.m
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "CWClosetDataSource.h"
#import <Parse/Parse.h>

// stuff has changed, so this algorithm is not up to date ~

// algorithm to find a percentage of goodness for each item
//
// temperature score / 3 -> result
// result / item score -> result
// result will be percentage of goodness

// ex:
// temperature: 77
// itemType: "tops"

// itemScore: 18
// temperatureScore: 38

// 14 perfect
// 4 cold
// 14*3 - 4*1 = 38

// 38/3 ~ 13
// 13/18 ~ .7

// itemScore: 5
// temperatureScore: 11

// 4 perfect
// 1 cold
// 4*3 - 1*1 = 11

// 11/3 ~ 4
// 4/5 ~ .8

@implementation CWClosetDataSource
@synthesize items;

static CWClosetDataSource *_sharedDataSource = nil;

+ (CWClosetDataSource *)sharedDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataSource = [[CWClosetDataSource alloc] init];
        _sharedDataSource.items = [[NSMutableDictionary alloc] init];
        
        // rather than set empty arrays,
        // i should read items from a file if i can
        [_sharedDataSource.items setObject:[NSMutableArray new] forKey:@"tops"];
        [_sharedDataSource.items setObject:[NSMutableArray new] forKey:@"bottoms"];
        [_sharedDataSource.items setObject:[NSMutableArray new] forKey:@"jackets"];
        
    });
    
    return _sharedDataSource;
}

- (void)addItem:(CWItem *)item {
    [[items objectForKey:item.type] addObject:item];
}

- (void)removeItem:(CWItem *)item {
    [[items objectForKey:item.type] removeObject:item];
}

- (CWItem *)findItem:(NSString *)itemType forCondition:(CWCondition *)condition {
    // will contain possible choices for the user to wear
    NSMutableArray *possibleChoices = [[NSMutableArray alloc] init];
    
    // go through items for itemType to find if the item is
    // a good possible choice
    NSArray *itemsForType = [items objectForKey:itemType];
    for(CWItem *item in itemsForType) {
        if([item isPossibleChoiceForCondition:condition]) {
            [possibleChoices addObject:item];
        }
    }
    
    if(!possibleChoices.count) {
        // there were no possible choices
        // this will happen when the user
        // has just begun using the app
        
        // still need to implement
        CWItem *item = [self generateGenericRecommendationFor:itemType forCondition:condition];
        return item;
    }
    
    // go through possibleChoices to select an item
    
    
    // find percentages of all possible choices
    NSMutableArray *percentages = [[NSMutableArray alloc] init];
    for(CWItem *item in possibleChoices) {
        CWScore *score = [item getScoreForCondition:condition];
        NSNumber *temperatureScore = score.temperatureScore;
        
        double percentage = temperatureScore.doubleValue / score.timesUsed.doubleValue;
        
        //double percentage = temperatureScore.doubleValue / 6.0;
        //percentage = percentage / score.timesUsed.doubleValue;
        
        NSNumber *percentageObject = [NSNumber numberWithDouble:percentage];
        [percentages addObject:percentageObject];
        // the same index for percentages and possibleChoices
        // will refer to the same object
    }
    
    // key:    (NSNumber *) - index of object in possibleChoices
    // object: (NSNumber *) - the actual percentage
    // will only contain percentages of at least .7
    NSMapTable *goodPercentages = [[NSMapTable alloc] init];
    
    // go through all percentages and add the good ones to goodPercentages
    for(int i = 0; i < percentages.count; ++i) {
        double percentage = ((NSNumber *)([percentages objectAtIndex:i])).doubleValue;
        NSLog(@"%@ percentage: %d",[[possibleChoices objectAtIndex:i] name],(int)(percentage));
        if(percentage >= 6) {
            NSNumber *percentageObject = [NSNumber numberWithDouble:percentage];
            NSNumber *indexObject = [NSNumber numberWithInt:i];
            
            [goodPercentages setObject:percentageObject forKey:indexObject];
        }
    }
    
    // still need a case for when there are zero
    NSMutableArray *goodPercentageKeys = [[NSMutableArray alloc] init];
    for(NSNumber *key in goodPercentages) {
        [goodPercentageKeys addObject:key];
    }
    
    switch(goodPercentageKeys.count) {
        case 0:
            break;
        case 1: {
            int index = ((NSNumber *)[goodPercentageKeys objectAtIndex:0]).intValue;
            return [possibleChoices objectAtIndex:index];
        }
        case 2: {
            
            int returnIndex = 0;
            int leastItemScore = 0;
            int itemScoreToCompare = 0;
            for(int i = 0; i < goodPercentageKeys.count; ++i) {
                int index = [[goodPercentageKeys objectAtIndex:i] intValue];
                CWItem *item = [possibleChoices objectAtIndex:index];
                
                if(i == 0) {
                    leastItemScore = item.itemScore.intValue;
                    break;
                }
                
                itemScoreToCompare = item.itemScore.intValue;
                if(itemScoreToCompare < leastItemScore) {
                    leastItemScore = itemScoreToCompare;
                    returnIndex = i;
                }
            }
            
            return (CWItem *)[possibleChoices objectAtIndex:returnIndex];
        }
        case 3:
            // same as for case 2:
            break;
        default: {
            NSMutableArray *goodPercentagesArray = [[NSMutableArray alloc] init];
            NSMutableArray *goodIndicesArray = [[NSMutableArray alloc] init];
            for(NSNumber *index in goodPercentages) {
                [goodPercentagesArray addObject:[goodPercentages objectForKey:index]];
                [goodIndicesArray addObject:index];
            }
            
            // still needs to be implemented
            // will sort goodPercentagesArray to have it go from
            // greatest to least
            // will also sort goodIndicesArray to the same way
            // goodPercentagesArray gets sorted
            [self sort:goodPercentagesArray and:goodIndicesArray];
            
            // hopefully this works
            int leastItemScore = 0;
            int itemScoreToCompare = 0;
            int index = 0;
            // only look at the three best options
            // select the one with the least item score
            for(int i = 0; i < 3; ++i) {
                CWItem *item = [possibleChoices objectAtIndex:
                                [[goodIndicesArray objectAtIndex:i] intValue]];
                
                if(i == 0) {
                    leastItemScore = item.itemScore.intValue;
                    break;
                }
                
                itemScoreToCompare = item.itemScore.intValue;
                if(itemScoreToCompare < leastItemScore) {
                    leastItemScore = itemScoreToCompare;
                    index = i;
                }
            }
            
            return (CWItem *)[possibleChoices objectAtIndex:index];
        }
    }
    return nil;
}

- (CWItem *)generateGenericRecommendationFor:(NSString *)itemType forCondition:(CWCondition *)condition {
    return nil;
    
}

- (void)sort:(NSMutableArray *)array and:(NSMutableArray *)array2 {
    
}

- (NSArray *)arrayOfAllItems {
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for(NSString *itemType in items) {
        NSArray *array = [items objectForKey:itemType];
        for(CWItem *item in array) {
            [a addObject:item];
        }
    }
    return (NSArray *)a;
}

- (void)printClosetItems {
    NSArray *allItems = [self arrayOfAllItems];
    
    for(CWItem *item in allItems) {
        NSLog(@"%@\n",item.name);
        for(NSString *sky in item.conditions) {
            const char *skyString = sky.UTF8String;
            printf(skyString);
            printf(" -> \n");
            for(NSNumber *temperature in [item.conditions objectForKey:sky]) {
                int t = temperature.intValue;
                
                CWCondition *condition = [[CWCondition alloc] init];
                condition.temperature = temperature;
                condition.skies = sky;
                
                CWScore *score = [item getScoreForCondition:condition];
                int temperatureScore = score.temperatureScore.intValue;
                int timesUsed = score.timesUsed.intValue;
                
                printf("          %d ->\n",t);
                printf("                 timesUsed: %d\n",timesUsed);
                printf("                 temperatureScore: %d\n\n",temperatureScore);
            }
            
            
        }
    }
}

@end