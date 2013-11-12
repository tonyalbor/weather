//
//  ForecastSharedService.m
//  weather-retry
//
//  Created by Tony Albor on 11/11/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "ForecastDataSource.h"

@implementation ForecastDataSource

@synthesize forecast;
@synthesize delegate;

static ForecastDataSource *_sharedDataSource = nil;

+ (ForecastDataSource *)sharedDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataSource = [[ForecastDataSource alloc] init];
        _sharedDataSource.forecast = [[ForecastKit alloc] initWithAPIKey:@"f58ba3586b5691d23a2eb3bf45eaeea4"];
    });
    
    return _sharedDataSource;
}

#pragma mark current time

- (void)getConditionsForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude {
    [forecast getCurrentConditionsForLatitude:latitude longitude:longitude success:^(NSMutableDictionary *responseDict) {
        
        NSLog(@"%@", responseDict);
        
        // other classes that become ForecastDataSourceDelegates can access
        // the response dictionary by implementing didGetConditions:
        [delegate didGetConditions:responseDict];
        
        NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
        NSLog(@"time now: %f",t);
        
    } failure:^(NSError *error){
        
        NSLog(@"Currently %@", error.description);
        
    }];
}

- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude {
    [forecast getDailyForcastForLatitude:latitude longitude:longitude success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
        // other classes that become ForecastDataSourceDelegates can access
        // the response array by implementing didGetDailyForecast:
        [delegate didGetDailyForecast:responseArray];
        
    } failure:^(NSError *error){
        
        NSLog(@"Daily %@", error.description);
        
    }];
}

- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude {
    [forecast getHourlyForcastForLatitude:latitude longitude:longitude success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Hourly %@", error.description);
        
    }];
}

- (void)getMinutelyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude {
    [forecast getMinutelyForcastForLatitude:latitude longitude:longitude success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Minutely %@", error.description);
        
    }];
}

#pragma mark given time

- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude atTime:(NSTimeInterval)time {
    [forecast getDailyForcastForLatitude:latitude longitude:longitude time:time success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Daily w/ time %@", error.description);
        
    }];
}

- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude atTime:(NSTimeInterval)time {
    [forecast getHourlyForcastForLatitude:latitude longitude:longitude time:time success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Hourly w/ time %@", error.description);
        
    }];

}

@end
