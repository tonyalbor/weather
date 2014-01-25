//
//  CWViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/20/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWViewController.h"
#import "CWRecommendation.h"

@interface CWViewController ()

@end

@implementation CWViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)didPressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressYes:(id)sender {
    if(![CWRecommendation isActive]) [CWRecommendation setRecommendationActive];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpView {
    if([CWRecommendation isActive]) {
        [_yesButton setTitle:@"Finish" forState:UIControlStateNormal];
    } else {
        [_yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    }
    
    CWItem *top = [CWRecommendation getTop];
    CWItem *bottoms = [CWRecommendation getBottoms];
    
    _topImageView.image = [UIImage imageNamed:top.imageName];
    _bottomsImageView.image = [UIImage imageNamed:bottoms.imageName];
    
    [_topLabel setText:top.name];
    [_bottomsLabel setText:bottoms.name];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
