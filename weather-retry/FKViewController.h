//
//  FKViewController.h
//  ForecastKit
//
//  Created by Brandon Emrich on 3/28/13.
//  Copyright (c) 2013 Brandon Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastDataSource.h"

@interface FKViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) ForecastDataSource *dataSource;


@end
