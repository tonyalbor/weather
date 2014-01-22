//
//  CWTestViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/2/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWTestViewController.h"
#import "ParseDataSource.h"

@interface CWTestViewController ()

@end

@implementation CWTestViewController

@synthesize nameLabel;
@synthesize locationManager,currentLocation;
@synthesize dataSource;
- (IBAction)didPressLookUpItems:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *closet = [PFQuery queryWithClassName:@"CWItem"];
    [closet whereKey:@"owner" equalTo:user.username];
    [closet findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if(!error) NSLog(@"success: %@",items);
        else NSLog(@"fail");
    }];
}

- (IBAction)addItem:(id)sender {
    UIStoryboard *storyboard = self.storyboard;
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"addItem"] animated:YES completion:nil];
    
}

- (IBAction)logCloset:(id)sender {
    NSLog(@"clicked log closet");
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    //NSLog(@"closet: %@",closet.items);
    NSLog(@"closet: \n");
    for(NSString *itemType in closet.items) {
        NSLog(@"%@",itemType);
        NSArray *items = [closet.items objectForKey:itemType];
        printf("{\n");
        for(int i = 0; i < items.count; ++i) {
            CWItem *item = [items objectAtIndex:i];
            NSLog(@"%@",item.name);
        }
        printf("}\n");
    }
}

- (IBAction)addCustomItem:(id)sender {
    UIStoryboard *storyboard = self.storyboard;
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"addItem"] animated:YES completion:nil];
}

- (IBAction)generateCondition:(id)sender {
    NSLog(@"clicked gen con");
    
    int input = 0;
    int oldInput = 0;
    for(int i = 0; i < 100; ++i) {
        
        CWCondition *condition =[CWCondition makeNew];
        do {
            input = arc4random() % 14;
        } while(input == oldInput);
        
        oldInput = input;
        
        CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
        NSArray *allItems = [closet arrayOfAllItems];
        CWItem *item = [allItems objectAtIndex:input];
        
        NSNumber *scoreModifier = [[NSNumber alloc] init];
        
        if(input == 3 || input == 8 || input == 9) scoreModifier = [NSNumber numberWithInt:-3];
        else scoreModifier = @9;
        
        [item addToConditions:condition withScoreModifier:scoreModifier];
        
        CWCondition *conditionMinus1 = [[CWCondition alloc] init];
        conditionMinus1.temperature = [NSNumber numberWithInt:condition.temperature.intValue-1];
        conditionMinus1.skies = condition.skies;
        
        CWCondition *conditionPlus1 = [[CWCondition alloc] init];
        conditionPlus1.temperature = [NSNumber numberWithInt:condition.temperature.intValue+1];
        conditionPlus1.skies = condition.skies;
        
        NSNumber *scoreModifierDividedByThree = [NSNumber numberWithDouble:scoreModifier.doubleValue/3];
        
        [item addToConditions:conditionMinus1 withScoreModifier:scoreModifierDividedByThree];
        [item addToConditions:conditionPlus1 withScoreModifier:scoreModifierDividedByThree];
    }
}

- (IBAction)logItemConditions:(id)sender {
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    [closet printClosetItems];
}

- (IBAction)findItem:(id)sender {
    CWCondition *condition = [CWCondition makeNew];
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    
    CWItem *top = [closet findItem:@"tops" forCondition:condition];
    CWItem *bottoms = [closet findItem:@"bottoms" forCondition:condition];
    NSLog(@"Condition: %@ %@",condition.skies,condition.temperature);
    NSLog(@"top: %@",top.name);
    NSLog(@"bottoms: %@",bottoms.name);
}

- (IBAction)getTemperatures:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [main instantiateViewControllerWithIdentifier:@"FKViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)didPressGoToCloset:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"closetViewController"] animated:YES completion:nil];
}

- (IBAction)didPressGetRecommendation:(id)sender {
    [self getNextFourHours];
    // NSString *sky = [dataSource getCurrentSky];
    // [[ForecastDataSource sharedDataSource] getHourlyForecastForLatitude:currentLocation.coordinate.latitude forLongitude:currentLocation.coordinate.longitude];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ParseDataSource sharedDataSource] getClosetItems];
    NSString *name = [[PFUser currentUser] username];
    nameLabel.text = [NSString stringWithFormat:@"Hello, %@",name];
    dataSource = [ForecastDataSource sharedDataSource];
    dataSource.delegate = self;
    currentLocation = [[CLLocation alloc] init];
    [self initializeLocationManager];
}

- (void)getNextFourHours {
    [dataSource getHourlyForecastForLatitude:currentLocation.coordinate.latitude forLongitude:currentLocation.coordinate.longitude];
}

- (void)didGetHourlyForecast:(NSArray *)hourlyForecast {
    const int numOfHoursToCompute = 8;
    //NSLog(@"hourly forecast: %d",hourlyForecast.count);
    double totalTemp = 0.0;
    
    NSMutableArray *skies = [[NSMutableArray alloc] init];
    for(int i = 0; i < numOfHoursToCompute; ++i) {
        NSString *sky = [[hourlyForecast objectAtIndex:i] objectForKey:@"icon"];
        [skies addObject:sky];
        
        double feelsLike = [[[hourlyForecast objectAtIndex:i] objectForKey:@"apparentTemperature"] doubleValue];
        double temperature = [[[hourlyForecast objectAtIndex:i] objectForKey:@"temperature"] doubleValue];
        double average = (feelsLike + temperature) / 2.0;
        
        totalTemp += average;
        //NSLog(@"hourly forecast: %@",[hourlyForecast objectAtIndex:i]);
        NSLog(@"%@ %.0lf",sky,average);
    }
    totalTemp /= numOfHoursToCompute;
    NSLog(@"Temperature will be: %.02f",totalTemp);
    
    NSString *icon = [self getMostCommonString:skies];
    NSLog(@"icon: %@",icon);
    
    CWCondition *condition = [[CWCondition alloc] init];
    condition.temperature = [NSNumber numberWithInt:(int)totalTemp];
    condition.skies = icon;
    
    CWItem *top = [[CWClosetDataSource sharedDataSource] findItem:@"tops" forCondition:condition];
    CWItem *bottoms = [[CWClosetDataSource sharedDataSource] findItem:@"bottoms" forCondition:condition];
    NSLog(@"found recommendation, ho");
    NSLog(@"top: %@",top.name);
    NSLog(@"bottoms: %@",bottoms.name);
}

- (void)failedToGetHourlyForecast:(NSError *)error {
    NSLog(@"Failed to get hourly forecast: %@",error);
}

- (IBAction)didSwipeUp:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"closetViewController"] animated:YES completion:nil];
}

- (NSString *)getMostCommonString:(NSArray *)strings {
    NSMapTable *map = [[NSMapTable alloc] init];
    
    int i = 0;
    NSString *icon = [NSString new];
    
    for(NSString *string in strings) {
        if(![map objectForKey:string]) {
            [map setObject:@1 forKey:string];
        } else {
            int newValue = [[map objectForKey:string] intValue] + 1;
            [map setObject:[NSNumber numberWithInt:newValue] forKey:string];
            
            if(newValue > i) {
                icon = string;
                i = newValue;
            }
        }
    }

    return icon;
    
    /*
    NSString *icon = [NSString new];
    int i = 0;
    for(NSString *key in map) {
        int comparison = [[map objectForKey:key] intValue];
        NSLog(@"key: %@, %d", key, comparison);
        if(comparison > i) {
            i = comparison;
            icon = key;
        }
    }
    return icon;
     */
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"did update locations");
    
    // stop updating current location, otherwise it will keep updating
    [locationManager stopUpdatingLocation];
    
    // get newly updated location and grab its coordinates
    currentLocation = [locations lastObject];
    NSLog(@"location: %@",currentLocation);
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        // in a background thread, gets location info
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"location: %@",placemark.addressDictionary);
        NSString *city = [placemark.addressDictionary objectForKey: @"City"];
        NSString *state = [placemark.addressDictionary objectForKey:@"State"];
        NSLog(@"city, state: %@, %@",city, state);
        //locationLabel.text = [NSString stringWithFormat:@"%@ %@",city,state];
    }];
    
    //[self getNextFourHours];
    
    //[dataSource getConditionsForLatitude:latitude forLongitude:longitude];
    //[dataSource getDailyForecastForLatitude:latitude forLongitude:longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager did fail: %@",error);
}

- (void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



