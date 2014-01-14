//
//  CWLoginViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWLoginViewController.h"
#import <Parse/Parse.h>

@interface CWLoginViewController ()

@end

@implementation CWLoginViewController

@synthesize emailTextField,passwordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)didPressLogin:(id)sender {

    [PFUser logInWithUsernameInBackground:emailTextField.text password:passwordTextField.text block:^(PFUser *user, NSError *error) {
        
        if(user) {
            // successfully logged in
            
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"testViewController"] animated:YES completion:nil];
            
        } else {
            NSLog(@"Login failed: %@",error);
        }
    }];
}
- (IBAction)didPressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [[textField superview] viewWithTag:nextTag];
    if(nextResponder) [nextResponder becomeFirstResponder];
    else [textField resignFirstResponder];
    
    return NO;
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
