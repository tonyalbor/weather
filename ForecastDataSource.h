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

@interface ForecastDataSource : NSObject

@property (strong, nonatomic) ForecastKit *forecast;

+ (ForecastDataSource *)sharedDataSource;

- (void)getConditionsForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude;
- (void)getDailyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude;
- (void)getHourlyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude;
- (void)getMinutelyForecastForLatitude:(CLLocationDegrees)latitude ForLongitude:(CLLocationDegrees)longitude;

@end
