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

static NSMutableArray *goodForArray = nil;

- (IBAction)didPressGoodFor:(id)sender {
    if(!goodForArray) goodForArray = [[NSMutableArray alloc] init];
    
    UIButton *button = (UIButton *)sender;
    UIColor *blueColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    UIColor *redColor = [self.nameLengthLabel textColor];
    
    NSString *goodForString = button.titleLabel.text;
    if([goodForArray containsObject:goodForString]) {
        [goodForArray removeObject:goodForString];
        [button setTitleColor:blueColor forState:UIControlStateNormal];
    } else {
        [goodForArray addObject:goodForString];
        [button setTitleColor:redColor forState:UIControlStateNormal];
    }
}

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
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        type = @"bottoms";
        if(!check0.hidden) image = @"shorts.png";
        else if(!check1.hidden) image = @"pants.png";
        else image = @"";
    } else {
        type = @"jackets";
        image = @"jacket.png";
    }
    
    CWItem *item = [CWItem newItemWithType:type andName:nameTextField.text];
    item.imageName = image;
    
    [self setGoodForsForItem:item];
    
    // save locally (not really saving to device)
    [[CWClosetDataSource sharedDataSource] addItem:item];
    
    [object setObject:type forKey:@"type"];
    [object setObject:user.username forKey:@"owner"];
    [object setObject:image forKey:@"imageName"];
    object[@"goodForRain"] = @(item.isGoodForRain);
    object[@"goodForSnow"] = @(item.isGoodForSnow);
    object[@"goodForCold"] = @(item.isGoodForCold);
    object[@"goodForClear"] = @(item.isGoodForClear);
    object[@"goodForHot"] = @(item.isGoodForHot);
    
    [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(success) {
            NSLog(@"success");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else NSLog(@"fail");
    }];
}

- (IBAction)cancel:(id)sender {
    goodForArray = nil;
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
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        [self.imageView1 setImage:[UIImage imageNamed:@"t-shirt.png"]];
        [self.imageView2 setImage:[UIImage imageNamed:@"long-sleeve.png"]];
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        [self.imageView1 setImage:[UIImage imageNamed:@"shorts.png"]];
        [self.imageView2 setImage:[UIImage imageNamed:@"pants.png"]];
    } else {
        [self.imageView1 setImage:[UIImage imageNamed:@"jacket.png"]];
        [self.imageView2 setImage:[UIImage imageNamed:@"jacket.png"]];
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

- (void)setGoodForsForItem:(CWItem *)item {
    item.isGoodForHot = NO;
    item.isGoodForCold = NO;
    item.isGoodForClear = NO;
    item.isGoodForRain = NO;
    item.isGoodForSnow = NO;
    
    for(NSString *goodForString in goodForArray) {
        if([goodForString isEqualToString:@"Rain"]) item.isGoodForRain = YES;
        else if([goodForString isEqualToString:@"Snow"]) item.isGoodForSnow = YES;
        else if([goodForString isEqualToString:@"Cold"]) item.isGoodForCold = YES;
        else if([goodForString isEqualToString:@"Clear"]) item.isGoodForClear = YES;
        else if([goodForString isEqualToString:@"Hot"]) item.isGoodForHot = YES;
    }
    
    NSLog(@"rain: %d",item.isGoodForRain);
    NSLog(@"snow: %d",item.isGoodForSnow);
    NSLog(@"cold: %d",item.isGoodForCold);
    NSLog(@"clear: %d",item.isGoodForClear);
    NSLog(@"hot: %d",item.isGoodForHot);
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
