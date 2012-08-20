//
//  DIYMenuButton.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/16/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYMenuButton.h"

@implementation DIYMenuButton

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize isSelected = _isSelected;

#pragma mark - Init

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return self;
}

#pragma mark - Touching

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // Make look selected
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    // Make look unselected if move out?
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    // Make look unselected
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // Make look unselected
    
    // Call delegate if touch ended in view
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        [self.delegate diyMenuAction:self.name];
    }
}

- (void)depictSelected
{
    // transform a few pixels x,y
    // add shading view
}

- (void)depictUnselected
{
    // return to normal place
    // remove shading view
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    _delegate = nil;
    [_name release], _name = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
