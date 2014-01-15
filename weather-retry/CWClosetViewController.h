//
//  CWClosetViewController.h
//  weather-retry
//
//  Created by Tony Albor on 1/14/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWClosetCell.h"
#import "CWClosetDataSource.h"

@interface CWClosetViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
