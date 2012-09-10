//
//  DIYAppDelegate.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYAppDelegate.h"
#import "DIYViewController.h"
#import "DIYMenuOptions.h"

@implementation DIYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont systemFontOfSize:24];
    
    //
    // Set up the menu
    //
    
    [DIYMenu setDelegate:self];
    
    // Add menu items
    [DIYMenu addMenuItem:@"Portfolio" withIcon:[UIImage imageNamed:@"portfolioIcon@2x.png"] withColor:[UIColor colorWithRed:0.18f green:0.76f blue:0.93f alpha:1.0f] withFont:font];
    [DIYMenu addMenuItem:@"Skills" withIcon:[UIImage imageNamed:@"skillsIcon@2x.png"] withColor:[UIColor colorWithRed:0.28f green:0.55f blue:0.95f alpha:1.0f] withFont:font];
    [DIYMenu addMenuItem:@"Explore" withIcon:[UIImage imageNamed:@"exploreIcon@2x.png"] withColor:[UIColor colorWithRed:0.47f green:0.24f blue:0.93f alpha:1.0f] withFont:font];
    [DIYMenu addMenuItem:@"Settings" withIcon:[UIImage imageNamed:@"settingsIcon@2x.png"] withColor:[UIColor colorWithRed:0.57f green:0.0f blue:0.85f alpha:1.0f] withFont:font];
    
    //
    
    // A view controller with a button to show the menu
    DIYViewController *vc = [[DIYViewController alloc] init];
    self.window.rootViewController = vc;

    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - DIYMenuDelegate

- (void)menuItemSelected:(NSString *)action
{
    NSLog(@"Delegate: selected: %@", action);
}

- (void)menuActivated
{
    NSLog(@"Delegate: menuActivated");
}

- (void)menuCancelled
{
    NSLog(@"Delegate: menuCancelled");
}

@end
