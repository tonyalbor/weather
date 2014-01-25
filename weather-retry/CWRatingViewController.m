//
//  CWRatingViewController.m
//  weather-retry
//
//  Created by Tony Albor on 1/24/14.
//  Copyright (c) 2014 tonyalbor. All rights reserved.
//

#import "CWRatingViewController.h"

@interface CWRatingViewController ()

@end

@implementation CWRatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)didPressDone:(id)sender {
    NSString *username = [[PFUser currentUser] username];

    NSString *topName = [[CWRecommendation getTop] name];
    NSString *bottomsName = [[CWRecommendation getBottoms] name];
    
    CWItem *top = [[CWClosetDataSource sharedDataSource] getItemByName:topName andType:@"tops"];
    CWItem *bottoms = [[CWClosetDataSource sharedDataSource] getItemByName:bottomsName andType:@"bottoms"];
    
    NSNumber *numberOfHours = [CWRecommendation getNumberOfHours];
    int halfDay = numberOfHours.intValue / 2;
    
    NSNumber *scoreModifier;
    
    if(_firstSegmentedControl.selectedSegmentIndex == 1) {
        scoreModifier = @3;
    } else scoreModifier = [NSNumber numberWithInt:-1];
    
    NSArray *skies = [CWRecommendation getSkies];
    NSArray *temperatures = [CWRecommendation getTemperatures];
    
    CWCondition *condition = [[CWCondition alloc] init];
    
    int i;
    for(i = 0; i < halfDay; ++i) {
        condition.skies = [skies objectAtIndex:i];
        condition.temperature = [temperatures objectAtIndex:i];
        
        [top addToConditions:condition withScoreModifier:scoreModifier];
        [bottoms addToConditions:condition withScoreModifier:scoreModifier];
        
        // need to figure out how to store conditions
        // was planning on just saving a new object for each item,
        // but that would probably be too slow once there
        // are many objects save online (slow to search for specific
        // condition)
        PFObject *conditionsObjectTop = [PFObject objectWithClassName:@"conditions"];
        [conditionsObjectTop setObject:topName forKey:@"item"];
        [conditionsObjectTop setObject:username forKey:@"owner"];
        
        // i should save this at the end of the next for loop
        // as well...or maybe not, still deciding how to handle all
        // of this stuff
        
    }
    
    if(_secondSegmentedControl.selectedSegmentIndex == 1) {
        scoreModifier = @3;
    } else scoreModifier = [NSNumber numberWithInt:-1];
    
    for( ; i < numberOfHours.intValue; ++i) {
        condition.skies = [skies objectAtIndex:i];
        condition.temperature = [temperatures objectAtIndex:i];
        
        [top addToConditions:condition withScoreModifier:scoreModifier];
        [bottoms addToConditions:condition withScoreModifier:scoreModifier];
    }
    
    [[CWClosetDataSource sharedDataSource] printClosetItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
