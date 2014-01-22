//
//  CWItem.m
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "CWItem.h"

@implementation CWItem
@synthesize conditions;
@synthesize itemScore;

+ (CWItem *)makeNew {
    CWItem *item = [[CWItem alloc] init];
    item.conditions = [[NSMapTable alloc] init];
    item.itemScore = @0;
    return item;
}

+ (CWItem *)newItemWithType:(NSString *)itemType andName:(NSString *)name {
    CWItem *item = [self makeNew];
    item.type = itemType;
    item.name = name;
    
    return item;
}

- (BOOL)isPossibleChoiceForCondition:(CWCondition *)condition {
    // if the item has been used for this
    // temperature before, and if the temperature
    // score is positive, then return YES
    NSMapTable *temperatures = [conditions objectForKey:condition.skies];
    
    if([temperatures objectForKey:condition.temperature]) {
        CWScore *score = [self getScoreForCondition:condition];
        return score.temperatureScore.intValue > 0;
    }
    
    // grab previously used temperatures
    // to check if the temperature passed in
    // is within range of old temperatures
    
    int indexOfLow = 0;
    int low = 100;
    
    int indexOfHigh = 0;
    int high = -30;
    
    int indexCount = 0;
    NSMutableArray *previouslyUsedTemperatures = [[NSMutableArray alloc] init];
    for(NSNumber *key in temperatures) {
        if(key.intValue < low) {
            low = key.intValue;
            indexOfLow = indexCount;
        }
        if(key.intValue > high) {
            high = key.intValue;
            indexOfHigh = indexCount;
        }
        [previouslyUsedTemperatures addObject:key];
        ++indexCount;
    }
    
    // has never been used before
    // for testing purposes, just returning no
    // actually, i think i should return no
    // then in find item, if there are no possible choices
    // it will find a generic item
    // but what if one item never gets used and there are other
    // possible choices, so this one will never be used
    // check this part for sure
    //
    // new thoughts lol Jan 21:
    // i will return yes and then later in find item i can
    // see if there are many not used yet....sure why not
    if(indexCount == 0) return YES;
    
    NSNumber *temperatureLow = [previouslyUsedTemperatures objectAtIndex:indexOfLow];
    NSNumber *temperatureHigh = [previouslyUsedTemperatures objectAtIndex:indexOfHigh];
    
    NSLog(@"temperature low: %@",temperatureLow);
    NSLog(@"temperature high: %@",temperatureHigh);
    return condition.temperature.intValue >= temperatureLow.intValue
    &&
    condition.temperature.intValue <= temperatureHigh.intValue;
}

- (void)addToConditions:(CWCondition *)condition withScoreModifier:(NSNumber *)scoreModifier {
    // initialize sky if nil
    if(![conditions objectForKey:condition.skies]) {
        [conditions setObject:([NSMapTable new]) forKey:condition.skies];
    }
    
    // initialize score if nil
    if(![[conditions objectForKey:condition.skies] objectForKey:condition.temperature]) {
        [[conditions objectForKey:condition.skies] setObject:[CWScore makeNew] forKey:condition.temperature];
    }
    
    // get scores
    CWScore *score = [self getScoreForCondition:condition];
    NSNumber *temperatureScore = score.temperatureScore;
    
    // update scores
    int newTemperatureScore = temperatureScore.intValue + scoreModifier.intValue;
    temperatureScore = [NSNumber numberWithInt:newTemperatureScore];
    int newTimesUsed = score.timesUsed.intValue + 1;
    
    // create new score with updated values
    CWScore *newScore = [CWScore makeNew];
    newScore.temperatureScore = [NSNumber numberWithInt:newTemperatureScore];
    newScore.timesUsed = [NSNumber numberWithInt:newTimesUsed];
    
    // set scores with new value
    [[conditions objectForKey:condition.skies] setObject:newScore forKey:condition.temperature];
    itemScore = [NSNumber numberWithInt:itemScore.intValue+1];
}

- (CWScore *)getScoreForCondition:(CWCondition *)condition {
    return [[conditions objectForKey:condition.skies] objectForKey:condition.temperature];
}

@end