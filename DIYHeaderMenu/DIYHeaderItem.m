//
//  DIYHeaderItem.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYHeaderItem.h"
#import "DIYHeaderOptions.h"

@interface DIYHeaderItem ()

@end

@implementation DIYHeaderItem

@synthesize name = _name;
@synthesize icon = _icon;
@synthesize isSelected = _isSelected;

#pragma mark - Init & Setup

- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{    
    CGRect labelFrame = CGRectMake(2*ICONPADDING + ICONSIZE, ICONPADDING, self.frame.size.width, ICONSIZE);
    _name = [[UILabel alloc] initWithFrame:labelFrame];
    self.name.backgroundColor = [UIColor clearColor];
    self.name.textColor = [UIColor whiteColor];
    self.name.font = [UIFont fontWithName:FONT_FAMILY size:FONT_SIZE];
    self.name.text = name;
    [self addSubview:self.name];
    
    _icon = [[UIImageView alloc] initWithImage:image];
    self.icon.frame = CGRectMake(ICONPADDING, ICONPADDING, ICONSIZE, ICONSIZE);
    [self addSubview:self.icon];
    
    self.backgroundColor = color;
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
