//
//  CWStartScreenViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWStartScreenViewController.h"

@interface CWStartScreenViewController ()

@end

@implementation CWStartScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)didPressLogin:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES completion:nil];
}

- (IBAction)didPressSignUp:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"signUp"] animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
