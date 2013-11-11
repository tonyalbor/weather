//
//  FKViewController.h
//  weather-retry
//
//  Created by Tony Albor & Gus on 11/9/13.
//  Copyright (c) 2013 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastDataSource.h"

@interface FKViewController : UIViewController <CLLocationManagerDelegate, ForecastDataSourceDelegate> {
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic) ForecastDataSource *dataSource;


@end
