//
//  CWTestAddItemViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/13/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CWCloset.h"

typedef enum selectedItemType {
    TYPE_TOPS,
    TYPE_BOTTOMS
}selectedItemType;

@interface CWTestAddItemViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
