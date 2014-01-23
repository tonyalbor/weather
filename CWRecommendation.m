//
//  CWRecommendation.m
//  weather-retry
//
//  Created by Tony Albor on 1/21/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWRecommendation.h"

@implementation CWRecommendation

static BOOL _isActive;

static CWItem *_top = nil;
static CWItem *_bottoms = nil;
static CWItem *_jacket = nil;

static CWRecommendation *_sharedDataSource = nil;

+ (CWRecommendation *)sharedDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataSource = [[CWRecommendation alloc] init];
        
        PFUser *user = [PFUser currentUser];
        _isActive = [[user objectForKey:@"hasRecommendation"] boolValue];
    });
    
    return _sharedDataSource;
}

+ (BOOL)isActive {
    return _isActive;
}

// will try to use lightly, just to update the value from online
// then i will save it locally and use above method to get status
+ (void)getRecommendationStatus {
    PFUser *user = [PFUser currentUser];
    _isActive = [[user objectForKey:@"hasRecommendation"] boolValue];
    
    if(_isActive) {
        PFUser *user = [PFUser currentUser];
        
        NSString *topName = [user objectForKey:@"top"];
        NSString *bottomsName = [user objectForKey:@"bottoms"];
        //NSString *jacketName = [user objectForKey:@"jacket"];
        
        _top = [[CWClosetDataSource sharedDataSource] getItemByName:topName andType:@"tops"];
        _bottoms = [[CWClosetDataSource sharedDataSource] getItemByName:bottomsName andType:@"bottoms"];
    }
    
}

+ (void)setTop:(CWItem *)item {
    _top = item;
}

+ (void)setBottoms:(CWItem *)item {
    _bottoms = item;
}

+ (void)setJacket:(CWItem *)item {
    _jacket = item;
}

+ (CWItem *)getTop {
    return _top;
}

+ (CWItem *)getBottoms {
    return _bottoms;
}

+ (CWItem *)getJacket {
    return _jacket;
}

+ (void)setItemsToNil {
    _top = nil;
    _bottoms = nil;
    _jacket = nil;
}

+ (void)setRecommendationActive {
    PFUser *user = [PFUser currentUser];
    [user setObject:@YES forKey:@"hasRecommendation"];
    [user setObject:_top.name forKey:@"top"];
    [user setObject:_bottoms.name forKey:@"bottoms"];
    [user setObject:((!_jacket) ? @"" : _jacket.name) forKey:@"jacket"];
    
    [user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) NSLog(@"successfully save active recommendation.");
        else NSLog(@"failed saving active recommendation: %@",error);
    }];
    
    _isActive = YES;
}

+ (void)cancelActiveRecommendation {
    PFUser *user = [PFUser currentUser];
    [user setObject:@NO forKey:@"hasRecommendation"];
    [user setObject:@"" forKey:@"top"];
    [user setObject:@"" forKey:@"bottoms"];
    [user setObject:@"" forKey:@"jacket"];
    
    [user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) NSLog(@"successfully cancelled active recommendation");
        else NSLog(@"failed to cancel active recommendation: %@",error);
    }];
    
    [self setItemsToNil];
    
    _isActive = NO;
}

@end
