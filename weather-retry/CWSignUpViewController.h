//
//  CWSignUpViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSignUpViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@end
