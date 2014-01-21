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
@synthesize check0,check1;

- (IBAction)done:(id)sender {
    if(nameTextField.text.length == 0) {
        NSLog(@"could not save item: no name entered.");
        self.nameLengthLabel.hidden = NO;
        return;
    } else if(check0.hidden && check1.hidden) {
        NSLog(@"could not save item: no image selected.");
        self.imageErrorLabel.hidden = NO;
        return;
    }
    
    PFUser *user = [PFUser currentUser];
    NSString *type = [NSString new];
    NSString *image = [NSString new];
    
    // save to parse
    PFObject *object = [PFObject objectWithClassName:@"CWItem"];
    [object setObject:nameTextField.text forKey:@"name"];
    [object setObject:@0 forKey:@"itemScore"];
    
    if(segmentedControl.selectedSegmentIndex == 0) {
        type = @"tops";
        if(!check0.hidden) image = @"t-shirt.png";
        else if(!check1.hidden) image = @"long-sleeve.png";
        else image = @"";
    } else {
        type = @"bottoms";
        if(!check0.hidden) image = @"shorts.png";
        else if(!check1.hidden) image = @"pants.png";
        else image = @"";
    }

    [object setObject:type forKey:@"type"];
    [object setObject:user.username forKey:@"owner"];
    
    [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            NSLog(@"success");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else NSLog(@"fail");
    }];
    
    CWItem *item = [CWItem newItemWithType:type andName:nameTextField.text];
    item.imageName = image;
    
    // save locally (not really saving to device)
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

- (IBAction)segmentedControlDidChange:(id)sender {
    [self setUpImages];
}

- (void)setUpImages {
    if(!self.segmentedControl.selectedSegmentIndex) {
        [self.imageView1 setImage:[UIImage imageNamed:@"t-shirt.png"]];
        [self.imageView2 setImage:[UIImage imageNamed:@"long-sleeve.png"]];
    } else {
        [self.imageView1 setImage:[UIImage imageNamed:@"shorts.png"]];
        [self.imageView2 setImage:[UIImage imageNamed:@"pants.png"]];
    }
}

- (IBAction)didTapIndex0:(id)sender {
    [check0 setHidden:NO];
    [check1 setHidden:YES];
}

- (IBAction)didTapIndex1:(id)sender {
    [check0 setHidden:YES];
    [check1 setHidden:NO];
}

- (void)viewDidLoad
{
    [self setUpImages];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
