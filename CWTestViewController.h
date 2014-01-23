//
//  CWTestViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/2/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWClosetDataSource.h"
#import "ForecastDataSource.h"
#import "CWRecommendation.h"

@interface CWTestViewController : UIViewController <CLLocationManagerDelegate, ForecastDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) ForecastDataSource *dataSource;

@end
