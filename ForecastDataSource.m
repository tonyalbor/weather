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

static ForecastDataSource *_sharedDataSource = nil;

+ (ForecastDataSource *)sharedDataSource {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataSource = [[ForecastDataSource alloc] init];
        _sharedDataSource.forecast = [[ForecastKit alloc] initWithAPIKey:@"f58ba3586b5691d23a2eb3bf45eaeea4"];
    });
    
    return _sharedDataSource;
}

- (void)getConditionsForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude {
    NSLog(@"got called boyy");
    [forecast getCurrentConditionsForLatitude:latitude longitude:longitude success:^(NSMutableDictionary *responseDict) {
        
        NSLog(@"%@", responseDict);
        
    } failure:^(NSError *error){
        
        NSLog(@"Currently %@", error.description);
        
    }];
}

- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude {
    [forecast getDailyForcastForLatitude:latitude longitude:longitude success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Daily %@", error.description);
        
    }];
}

- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude {
    [forecast getHourlyForcastForLatitude:latitude longitude:longitude success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Hourly %@", error.description);
        
    }];
}

- (void)getMinutelyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude {
    [forecast getMinutelyForcastForLatitude:31.146187 longitude:-83.452435 success:^(NSArray *responseArray) {
        
        NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Minutely %@", error.description);
        
    }];
}

@end
