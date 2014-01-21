//
//  CWTestAddItemViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CWClosetDataSource.h"

typedef enum selectedItemType {
    TYPE_TOPS,
    TYPE_BOTTOMS
}selectedItemType;

@interface CWTestAddItemViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *check0;
@property (weak, nonatomic) IBOutlet UILabel *check1;
@property (weak, nonatomic) IBOutlet UILabel *nameLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageErrorLabel;

@end
