//
//  DIYHeaderItem.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYHeaderItem.h"

@interface DIYHeaderItem ()

@end

@implementation DIYHeaderItem

@synthesize name = _name;
@synthesize icon = _icon;
@synthesize isSelected = _isSelected;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithFrame:(CGRect)frame withName:(NSString *)name withIcon:(UIImage *)icon
{
    
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    [_name release]; _name = nil;
    [_icon release]; _icon = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
