//
//  CWCloset.h
//
//
//  Created by Tony Albor on 12/27/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "CWItem.h"

// this shall be a singleton class so only one
// closet is instantiated throughout the entire app

@interface CWClosetDataSource : NSObject

// key:    (NSString *) - item.type
// object: (NSArray *)  - array of items
@property (strong, nonatomic) NSMutableDictionary *items;

+ (CWClosetDataSource *)sharedDataSource;

- (void)addItem:(CWItem *)item;
- (void)removeItem:(CWItem *)item;

- (CWItem *)findItem:(NSString *)itemType forCondition:(CWCondition *)condition;
- (CWItem *)generateGenericRecommendationFor:(NSString *)itemType forCondition:(CWCondition *)condition;
- (NSArray *)arrayOfAllItems;
- (void)printClosetItems;

@end