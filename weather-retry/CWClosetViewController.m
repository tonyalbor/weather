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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)didPressGoBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressDelete:(id)sender {
    UIButton *deleteButton = (UIButton *)sender;
    UICollectionViewCell *cellToBeDeleted = (UICollectionViewCell *)[[deleteButton superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cellToBeDeleted];
    
    NSArray *items = [[CWClosetDataSource sharedDataSource] arrayOfAllItems];
    CWItem *item = [items objectAtIndex:indexPath.row];
    
    [[CWClosetDataSource sharedDataSource] removeItem:item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [[ParseDataSource sharedDataSource] removeParseItem:item];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWClosetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"closetCell" forIndexPath:indexPath];

    if(!cell) {
        cell = [[CWClosetCell alloc] init];
    }
    
    NSArray *items = [[CWClosetDataSource sharedDataSource] arrayOfAllItems];
    CWItem *item = (CWItem *)[items objectAtIndex:indexPath.row];
    [cell.nameLabel setText:item.name];
    [cell.typeLabel setText:item.type];
    
    UIImage *image = [UIImage imageNamed:item.imageName];
    [cell.imageView setImage:image];
    
    NSLog(@"item: %@",item.name);
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [[[CWClosetDataSource sharedDataSource] arrayOfAllItems] count];
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
