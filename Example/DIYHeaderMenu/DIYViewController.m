//
//  DIYViewController.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYViewController.h"
#import "DIYMenu.h"

@interface DIYViewController ()

@end

@implementation DIYViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.cancelsTouchesInView = false;
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - UI

- (IBAction)showMenu:(id)sender
{
    [DIYMenu show];
}

- (IBAction)tapped:(id)sender
{
    NSLog(@"tapped background");
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return true;
}

@end
