//
//  CWLoginViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
