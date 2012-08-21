//
//  DIYMenuButton.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/16/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYMenuButton.h"

@implementation DIYMenuButton

@synthesize delegate    = _delegate;
@synthesize name        = _name;
@synthesize isSelected  = _isSelected;

#pragma mark - Init

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _shadingView = [[UIView alloc] initWithFrame:self.frame];
        self.shadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.shadingView.backgroundColor = [UIColor blackColor];
        self.shadingView.userInteractionEnabled = false;
        self.shadingView.alpha = 0.0f;
        [self addSubview:self.shadingView];
    }
    return self;
}

#pragma mark - Drawing

- (void)depictSelected
{
    if (!self.isSelected) {
        self.shadingView.alpha = 0.5f;
        [self bringSubviewToFront:self.shadingView];
        self.isSelected = true;
    }
}

- (void)depictUnselected
{
    if (self.isSelected) {
        self.shadingView.alpha = 0.0f;
        self.isSelected = false;
    }
}

#pragma mark - Touching

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self depictSelected];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        [self depictSelected];
    }
    else {
        [self depictUnselected];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self depictUnselected];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self depictUnselected];
    
    // Call delegate if touch ended in view
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        [self.delegate diyMenuAction:self.name];
    }
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
