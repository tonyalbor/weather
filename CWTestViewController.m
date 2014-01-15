//
//  CWTestViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/2/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWTestViewController.h"
//#import <Parse/Parse.h>
#import "ParseDataSource.h"

@interface CWTestViewController ()

@end

@implementation CWTestViewController

@synthesize nameLabel;
- (IBAction)didPressLookUpItems:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *closet = [PFQuery queryWithClassName:@"CWItem"];
    [closet whereKey:@"owner" equalTo:user.username];
    [closet findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        if(!error) NSLog(@"success: %@",items);
        else NSLog(@"fail");
    }];
}

- (IBAction)addItem:(id)sender {
    NSLog(@"clicked add item");
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    /*
    CWItem *item = [CWItem newItemWithType:@"tops" andName:@"White T-Shirt"];
    CWItem *item1 = [CWItem newItemWithType:@"tops" andName:@"Protoge T-Shirt"];
    CWItem *item2 = [CWItem newItemWithType:@"bottoms" andName:@"Green Levis"];
    CWItem *item3 = [CWItem newItemWithType:@"bottoms" andName:@"Grey Corduroys"];
    CWItem *item4 = [CWItem newItemWithType:@"tops" andName:@"Black T-Shirt"];
    CWItem *item5 = [CWItem newItemWithType:@"bottoms" andName:@"Cargo Shorts"];
    CWItem *item6 = [CWItem newItemWithType:@"tops" andName:@"Arsenal Jersey"];
    CWItem *item7 = [CWItem newItemWithType:@"tops" andName:@"UCR T-Shirt"];
    CWItem *item8 = [CWItem newItemWithType:@"tops" andName:@"Black Man City Jersey"];
    CWItem *item9 = [CWItem newItemWithType:@"tops" andName:@"Black T-Shirt"];
    CWItem *item10 = [CWItem newItemWithType:@"bottoms" andName:@"Blue Levis"];
    CWItem *item11 = [CWItem newItemWithType:@"bottoms" andName:@"Light Blue Levis"];
    CWItem *item12 = [CWItem newItemWithType:@"bottoms" andName:@"Khaki Levis"];
    CWItem *item13 = [CWItem newItemWithType:@"bottoms" andName:@"Dark Green Levis"];
    
    
    [closet addItem:item];
    [closet addItem:item1];
    [closet addItem:item2];
    [closet addItem:item3];
    [closet addItem:item4];
    [closet addItem:item5];
    [closet addItem:item6];
    [closet addItem:item7];
    [closet addItem:item8];
    [closet addItem:item9];
    [closet addItem:item10];
    [closet addItem:item11];
    [closet addItem:item12];
    [closet addItem:item13];
    //[closet addItem:item14];
    //[closet addItem:item15];
    */
    
}

- (IBAction)addCustomItem:(id)sender {
    UIStoryboard *storyboard = self.storyboard;
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"addItem"] animated:YES completion:nil];
}

- (IBAction)logCloset:(id)sender {
    NSLog(@"clicked log closet");
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    //NSLog(@"closet: %@",closet.items);
    NSLog(@"closet: \n");
    for(NSString *itemType in closet.items) {
        NSLog(@"%@",itemType);
        NSArray *items = [closet.items objectForKey:itemType];
        printf("{\n");
        for(int i = 0; i < items.count; ++i) {
            CWItem *item = [items objectAtIndex:i];
            NSLog(@"%@",item.name);
        }
        printf("}\n");
    }
}

- (IBAction)generateCondition:(id)sender {
    NSLog(@"clicked gen con");
    
    int input = 0;
    int oldInput = 0;
    for(int i = 0; i < 100; ++i) {
        
        CWCondition *condition =[CWCondition makeNew];
        do {
            input = arc4random() % 14;
        } while(input == oldInput);
        
        oldInput = input;
        
        CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
        NSArray *allItems = [closet arrayOfAllItems];
        CWItem *item = [allItems objectAtIndex:input];
        
        NSNumber *scoreModifier = [[NSNumber alloc] init];
        
        if(input == 3 || input == 8 || input == 9) scoreModifier = [NSNumber numberWithInt:-3];
        else scoreModifier = @9;
        
        [item addToConditions:condition withScoreModifier:scoreModifier];
        
        CWCondition *conditionMinus1 = [[CWCondition alloc] init];
        conditionMinus1.temperature = [NSNumber numberWithInt:condition.temperature.intValue-1];
        conditionMinus1.skies = condition.skies;
        
        CWCondition *conditionPlus1 = [[CWCondition alloc] init];
        conditionPlus1.temperature = [NSNumber numberWithInt:condition.temperature.intValue+1];
        conditionPlus1.skies = condition.skies;
        
        NSNumber *scoreModifierDividedByThree = [NSNumber numberWithDouble:scoreModifier.doubleValue/3];
        
        [item addToConditions:conditionMinus1 withScoreModifier:scoreModifierDividedByThree];
        [item addToConditions:conditionPlus1 withScoreModifier:scoreModifierDividedByThree];
    }
}

- (IBAction)logItemConditions:(id)sender {
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    [closet printClosetItems];
}

- (IBAction)findItem:(id)sender {
    CWCondition *condition = [CWCondition makeNew];
    CWClosetDataSource *closet = [CWClosetDataSource sharedDataSource];
    
    CWItem *top = [closet findItem:@"tops" forCondition:condition];
    CWItem *bottoms = [closet findItem:@"bottoms" forCondition:condition];
    NSLog(@"Condition: %@ %@",condition.skies,condition.temperature);
    NSLog(@"top: %@",top.name);
    NSLog(@"bottoms: %@",bottoms.name);
}

- (IBAction)getTemperatures:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [main instantiateViewControllerWithIdentifier:@"FKViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)didPressGoToCloset:(id)sender {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"closetViewController"] animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[ParseDataSource sharedDataSource] getClosetItems];
    NSString *name = [[PFUser currentUser] username];
    nameLabel.text = [NSString stringWithFormat:@"Hello, %@",name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
