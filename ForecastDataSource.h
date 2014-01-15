//
//  ForecastSharedService.h
//  weather-retry
//
//  Created by Tony Albor on 11/11/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ForecastKit.h"

@protocol ForecastDataSourceDelegate;

@interface ForecastDataSource : NSObject

@property (strong, nonatomic) ForecastKit *forecast;

@property (weak, nonatomic) id<ForecastDataSourceDelegate> delegate;

+ (ForecastDataSource *)sharedDataSource;

- (void)getConditionsForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude;
- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude;

- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude;
- (void)getMinutelyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude;

- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude atTime:(NSTimeInterval)time;
- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude forLongitude:(CLLocationDegrees)longitude atTime:(NSTimeInterval)time;

- (NSString *)getCurrentSky;

@end

@protocol ForecastDataSourceDelegate <NSObject>

@optional

- (void)didGetConditions:(NSDictionary *)conditions;
- (void)failedToGetConditions:(NSError *)error;

- (void)didGetDailyForecast:(NSArray *)dailyForecast;
- (void)failedToGetDailyForecast:(NSError *)error;

- (void)didGetHourlyForecast:(NSArray *)hourlyForecast;
- (void)failedToGetHourlyForecast:(NSError *)error;

@end

