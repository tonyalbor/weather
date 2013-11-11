//
//  FKViewController.m
//  ForecastKit
//
//  Created by Brandon Emrich on 3/28/13.
//  Copyright (c) 2013 Brandon Emrich. All rights reserved.
//

#import "FKViewController.h"

#import "ForecastKit.h"

@interface FKViewController ()

@end

@implementation FKViewController
@synthesize cityLabel;


- (IBAction)triggerCity:(id)sender {
    NSLog(@"button pressed");
    //ini for location info
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


- (void) viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"did update locations");
    // get newly updated location and grab its coordinates
    CLLocation* location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees lonitude = location.coordinate.longitude;
    
    [self getConditionsForLatitude:latitude ForLongitude:lonitude];
    [self getCurrentCity:location];
    [locationManager stopUpdatingLocation];
}

- (void)getCurrentCity:(CLLocation *)location {
    NSLog(@"get current city");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // in a background thread, gets location info
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"location: %@",placemark.addressDictionary);
        NSString *city;
        city = [placemark.addressDictionary objectForKey: @"City"];
        cityLabel.text = city;
    }];
    return;
}

-(void) getConditionsForLatitude:(CLLocationDegrees) latitude ForLongitude:(CLLocationDegrees) longitude {
    ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"f58ba3586b5691d23a2eb3bf45eaeea4"];

    [forecast getCurrentConditionsForLatitude:latitude longitude:longitude success:^(NSMutableDictionary *responseDict) {
        
        NSLog(@"%@", responseDict);
        
    } failure:^(NSError *error){
        
        NSLog(@"Currently %@", error.description);
        
    }];
}

- (void) viewDidAppear:(BOOL)animated {

    
    [super viewDidAppear:animated];
    
    /*
    // Request the forecast for a location starting now
    [forecast getDailyForcastForLatitude:31.146187 longitude:-83.452435 success:^(NSArray *responseArray) {
        
        //NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Daily %@", error.description);
        
    }];
    
    // Request the forecast for a location starting now
    [forecast getHourlyForcastForLatitude:31.146187 longitude:-83.452435 success:^(NSArray *responseArray) {
        
        //NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Hourly %@", error.description);
        
    }];
    
    // Request the forecast for a location starting now
    [forecast getMinutelyForcastForLatitude:31.146187 longitude:-83.452435 success:^(NSArray *responseArray) {
        
        //NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Minutely %@", error.description);
        
    }];
    
    // Request the forecast for a location at a specified time
    [forecast getDailyForcastForLatitude:31.146187 longitude:-83.452435 time:1372708800 success:^(NSArray *responseArray) {
        
        //NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Daily w/ time %@", error.description);
        
    }];
    
    // Request the forecast for a location at a specified time
    [forecast getHourlyForcastForLatitude:31.146187 longitude:-83.452435 time:1372708800 success:^(NSArray *responseArray) {
        
        //NSLog(@"%@", responseArray);
        
    } failure:^(NSError *error){
        
        NSLog(@"Hourly w/ time %@", error.description);
        
    }]; 
     */
}

@end
