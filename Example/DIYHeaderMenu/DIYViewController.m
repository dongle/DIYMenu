//
//  DIYViewController.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYViewController.h"
#import "DIYHeaderMenu.h"

@interface DIYViewController ()

@end

@implementation DIYViewController

@synthesize menuButton;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UI

- (IBAction)showMenu:(id)sender
{
    [DIYHeaderMenu show];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return true;
}

#pragma mark - Dealloc

- (void)dealloc {
    [menuButton release];
    [super dealloc];
}
@end
