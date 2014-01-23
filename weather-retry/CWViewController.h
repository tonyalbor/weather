//
//  CWViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/20/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomsImageView;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@end
