//
//  DIYAppDelegate.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYAppDelegate.h"
#import "DIYViewController.h"
#import "DIYHeaderMenu.h"

@implementation DIYAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //
    // Set up the menu
    //
    
    // Set up the titlebar
    [DIYHeaderMenu setTitle:@"Menu" withDismissIcon:[UIImage imageNamed:@"dismissIcon@2x.png"] withColor:[UIColor colorWithRed:0.34f green:0.47f blue:0.78f alpha:1.0f]];
    
    // Add menu items
    [DIYHeaderMenu addMenuItem:@"Portfolio" withIcon:[UIImage imageNamed:@"portfolioIcon@2x.png"] withColor:[UIColor colorWithRed:0.18f green:0.76f blue:0.93f alpha:1.0f]];
    [DIYHeaderMenu addMenuItem:@"Skills" withIcon:[UIImage imageNamed:@"skillsIcon@2x.png"] withColor:[UIColor colorWithRed:0.28f green:0.55f blue:0.95f alpha:1.0f]];
    [DIYHeaderMenu addMenuItem:@"Explore" withIcon:[UIImage imageNamed:@"exploreIcon@2x.png"] withColor:[UIColor colorWithRed:0.47f green:0.24f blue:0.93f alpha:1.0f]];
    [DIYHeaderMenu addMenuItem:@"Settings" withIcon:[UIImage imageNamed:@"settingsIcon@2x.png"] withColor:[UIColor colorWithRed:0.57f green:0.0f blue:0.85f alpha:1.0f]];
    
    //
    
    // A view controller with a button to show the menu
    DIYViewController *vc = [[DIYViewController alloc] init];
    self.window.rootViewController = vc;
    [vc release];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
