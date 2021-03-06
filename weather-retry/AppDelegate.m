//
//  FKAppDelegate.m
//  ForecastKit
//
//  Created by Brandon Emrich on 3/28/13.
//  Copyright (c) 2013 Brandon Emrich. All rights reserved.
//

#import "AppDelegate.h"
#import "FKViewController.h"
#import <Parse/Parse.h>
#import "Mixpanel.h"

#define MIXPANEL_TOKEN @"12dd43e97ece7a4b70923c7c9a2e46d8"

@implementation FKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"R8sZZHO3eY3YThzQGziwty7pS9GXRTqjFllktmr0"
                  clientKey:@"sV1MaKLZ98X3JxjCl9OetXR9LWWFtJvtw2BWO0dg"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Test" bundle:nil];
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"startScreen"];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    

    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    [[Mixpanel sharedInstance] track:@"test!" properties:@{@"testing":@1}];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
