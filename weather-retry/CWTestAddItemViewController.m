//
//  CWTestAddItemViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWTestAddItemViewController.h"
#import <Parse/Parse.h>

@interface CWTestAddItemViewController ()

@end

@implementation CWTestAddItemViewController

@synthesize nameTextField,segmentedControl;

- (IBAction)done:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSString *type = [NSString new];
    
    // save to parse
    PFObject *object = [PFObject objectWithClassName:@"CWItem"];
    [object setObject:nameTextField.text forKey:@"name"];
    [object setObject:@0 forKey:@"itemScore"];
    if(segmentedControl.selectedSegmentIndex == 0) type = @"tops";
    else type = @"bottoms";
    [object setObject:type forKey:@"type"];
    [object setObject:user.username forKey:@"owner"];
    
    [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            NSLog(@"success");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else NSLog(@"fail");
    }];
    
    // save locally (not really saving to device)
    CWItem *item = [CWItem newItemWithType:type andName:nameTextField.text];
    [[CWClosetDataSource sharedDataSource] addItem:item];
    
    
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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
