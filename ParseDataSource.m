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

- (void)getClosetItems {
    [self getClosetItemsWithType:@"tops"];
    [self getClosetItemsWithType:@"bottoms"];
}

- (void)getClosetItemsWithType:(NSString *)type {
    NSString *username = [[PFUser currentUser] username];
    
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"CWItem"];
    [itemQuery whereKey:@"owner" equalTo:username];
    [itemQuery whereKey:@"type" equalTo:type];
    
    NSMutableArray *allItemTypes = [[NSMutableArray alloc] init];
    
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *tops, NSError *error) {
        for(PFObject *object in tops) {
            CWItem *item = [CWItem newItemWithType:type andName:[object objectForKey:@"name"]];
            //[_sharedDataSource addItem:top];
            item.conditions = [[NSMapTable alloc] init];
            
            PFQuery *conditionsQuery = [PFQuery queryWithClassName:@"conditions"];
            [conditionsQuery whereKey:@"owner" equalTo:username];
            [conditionsQuery whereKey:@"item" equalTo:item.name];
            
            //NSArray *objects = [conditionsQuery findObjects];
            
            
            [conditionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for(PFObject *object2 in objects) {
                    CWScore *score = [[CWScore alloc] init];
                    NSNumber *temperature = [[NSNumber alloc] init];
                    NSMapTable *scores = [[NSMapTable alloc] init];
                    
                    temperature = [object2 objectForKey:@"temperature"];
                    score.temperatureScore = [object2 objectForKey:@"temperatureScore"];
                    score.timesUsed = [object2 objectForKey:@"timesUsed"];
                    
                    [scores setObject:score forKey:temperature];
                    
                    [item.conditions setObject:scores forKey:[object2 objectForKey:@"skies"]];
                    
                }
            }];
            
            //[_sharedDataSource addItem:top];
            [allItemTypes addObject:item];
            
        }
        CWClosetDataSource *dataSource = [CWClosetDataSource sharedDataSource];
        [dataSource.items setObject:allItemTypes forKey:type];
    }];
}

@end
