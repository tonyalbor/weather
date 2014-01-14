//
//  CWSignUpViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWSignUpViewController.h"
#import <Parse/Parse.h>

@interface CWSignUpViewController ()

@end

@implementation CWSignUpViewController

@synthesize nameTextField,emailTextField,passwordTextField,confirmTextField;
@synthesize errorMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)didPressSignUp:(id)sender {
    NSLog(@"did press sign up");
    
    if(nameTextField.text.length == 0 ||
       emailTextField.text.length == 0 ||
       passwordTextField.text.length == 0 ||
       confirmTextField.text.length == 0) {
        
        [errorMessage setText:@"Please fill out all fields"];
        [errorMessage setHidden:NO];
        return;
    }
    
    
    PFUser *user = [PFUser user];
    user.username = nameTextField.text;
    
    if([passwordTextField.text isEqualToString:confirmTextField.text]) {
        user.password = passwordTextField.text;
    } else {
        NSLog(@"passwords do not match");
        [errorMessage setText:@"Passwords do not match"];
        [errorMessage setHidden:NO];
        
    }
    
    user.email = emailTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(!error) {
            // signed up successfully
            [errorMessage setHidden:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"testViewController"] animated:YES completion:nil];
        } else {
            NSLog(@"Failed to sign up user: %@",[error userInfo][@"error"]);
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
