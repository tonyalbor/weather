//
//  CWClosetViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/14/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWClosetViewController.h"

@interface CWClosetViewController ()

@end

@implementation CWClosetViewController

@synthesize collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWClosetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"closetCell" forIndexPath:indexPath];
    
    
    
    
    return cell;
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
