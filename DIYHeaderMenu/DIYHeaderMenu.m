//
//  DIYHeaderMenu.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYHeaderMenu.h"
#import "DIYHeaderItem.h"

@interface DIYHeaderMenu ()

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) CGRect itemFrame;
@property (nonatomic, retain, readonly) UIWindow *overlayWindow;

@end

@implementation DIYHeaderMenu

// Private
@synthesize items = _items;
@synthesize itemFrame = _itemFrame;
@synthesize overlayWindow = _overlayWindow;

// Public
@synthesize isActivated = _isActivated;
@synthesize currentItem = _currentItem;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenFrame];
    if (self) {
        _itemFrame = frame;
    }
    return self;
}

#pragma mark - Show methods

- (void)show
{
    
}

#pragma mark - Dismiss methods

- (void)dismiss
{
    
}

#pragma mark - Item management
- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{
    DIYHeaderItem *item = [[DIYHeaderItem alloc] initWithFrame:self.itemFrame];
    [item setName:name ]
    
    
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
