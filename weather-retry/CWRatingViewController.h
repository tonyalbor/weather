//
//  CWRatingViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/24/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWRecommendation.h"

@interface CWRatingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *firstSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *secondSegmentedControl;

@end
