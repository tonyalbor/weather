//
//  FKViewController.h
//  ForecastKit
//
//  Created by Brandon Emrich on 3/28/13.
//  Copyright (c) 2013 Brandon Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FKViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@end
