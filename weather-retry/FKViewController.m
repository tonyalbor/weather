//
//  FKViewController.h
//  weather-retry
//
//  Created by Tony Albor & Gus on 11/9/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import "FKViewController.h"

#import "ForecastKit.h"

@interface FKViewController ()

@end

@implementation FKViewController
@synthesize locationLabel,degreeLabel,summaryLabel;
@synthesize tomorrowsHighLabel,tomorrowsLowLabel;
@synthesize nextDaysHighLabel,nextDaysLowLabel;
@synthesize dataSource;

#pragma mark user interface

- (void)updateLocationLabel:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // in a background thread, gets location info
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"location: %@",placemark.addressDictionary);
        NSString *city = [placemark.addressDictionary objectForKey: @"City"];
        NSString *state = [placemark.addressDictionary objectForKey:@"State"];
        locationLabel.text = [NSString stringWithFormat:@"%@ %@",city,state];
    }];
    return;
}

- (void)updateTodaysForecast:(NSDictionary *)conditions {
    // set the degrees label
    NSNumber *temperature = [conditions objectForKey:@"temperature"];
    degreeLabel.text = [NSString stringWithFormat:@"%d",temperature.intValue];
    
    // set the summary label
    NSString *summary = [conditions objectForKey:@"summary"];
    summaryLabel.text = [summary uppercaseString];
}

- (void)updateTomorrowsForecast:(NSDictionary *)tomorrowsForecast {
    NSNumber *tomorrowsHigh = [tomorrowsForecast objectForKey:@"temperatureMax"];
    NSNumber *tomorrowsLow = [tomorrowsForecast objectForKey:@"temperatureMin"];
    
    tomorrowsHighLabel.text = [tomorrowsHigh stringValue];
    tomorrowsLowLabel.text = [tomorrowsLow stringValue];
}

- (void)updateNextDaysForecast:(NSDictionary *)nextDaysForecast {
    NSNumber *nextDaysHigh = [nextDaysForecast objectForKey:@"temperatureMax"];
    NSNumber *nextDaysLow = [nextDaysForecast objectForKey:@"temperatureMin"];
    
    nextDaysHighLabel.text = [nextDaysHigh stringValue];
    nextDaysLowLabel.text = [nextDaysLow stringValue];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"did update locations");
    
    // stop updating current location, otherwise it will keep updating
    [locationManager stopUpdatingLocation];
    
    // get newly updated location and grab its coordinates
    CLLocation* location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    [dataSource getConditionsForLatitude:latitude forLongitude:longitude];
    [dataSource getDailyForecastForLatitude:latitude forLongitude:longitude];
    [self updateLocationLabel:location];
}

#pragma mark ForecaseDataSourceDelegate

- (void)didGetConditions:(NSDictionary *)conditions {
    [self updateTodaysForecast:conditions];
}

- (void)didGetDailyForecast:(NSArray *)dailyForecast {
    [self updateTomorrowsForecast:[dailyForecast objectAtIndex:1]];
    [self updateNextDaysForecast:[dailyForecast objectAtIndex:2]];
}

#pragma mark UIViewController

- (void)viewDidLoad {
    NSLog(@"view did load");
    if(dataSource == nil) dataSource = [ForecastDataSource sharedDataSource];
    dataSource.delegate = self;
    [self initializeLocationManager];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark helper functions

- (void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

// just in case we need it
- (NSTimeInterval)getTomorrowsTime {
    NSDate *currentDate = [NSDate date];
    NSDate *tomorrowsDate = [currentDate dateByAddingTimeInterval:NSCalendarUnitDay];
    NSTimeInterval tomorrowsTime = [tomorrowsDate timeIntervalSince1970];
    
    return tomorrowsTime;
}

@end
