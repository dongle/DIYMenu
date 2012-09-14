//
//  DIYMenuItem.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYMenuItem.h"
#import "DIYMenuOptions.h"

@interface DIYMenuItem ()

@end

@implementation DIYMenuItem

#pragma mark - Init & Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = nil;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = true;
        
        _shadingView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.shadingView.backgroundColor = [UIColor blackColor];
        self.shadingView.userInteractionEnabled = false;
        self.shadingView.alpha = 0.0f;
        [self addSubview:self.shadingView];
        
        _menuPosition = CGPointMake(frame.origin.x, frame.origin.y);
    }
    return self;
}

- (void)setName:(NSString *)name withColor:(UIColor *)color withFont:(UIFont *)font
{
    CGRect labelFrame = CGRectMake(ICONPADDING + ICONSIZE + ITEMPADDING, ICONPADDING, self.frame.size.width, ICONSIZE);
    _name = [[UILabel alloc] initWithFrame:labelFrame];
    self.name.backgroundColor = color;
    self.name.textColor = [UIColor whiteColor];
    self.name.font = font;
    self.name.text = name;
    [self addSubview:self.name];
    
    self.backgroundColor = color;
    
    _icon = nil;
    _glyph = nil;
}

- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font
{
    [self setName:name withColor:color withFont:font];
    
    if (image != nil) {
        _icon = [[UIImageView alloc] initWithImage:image];
        self.icon.frame = CGRectMake(ICONPADDING, ICONPADDING, ICONSIZE, ICONSIZE);
        [self addSubview:self.icon];
    }
    else {
        _icon = nil;
    }
}

- (void)setName:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont
{
    [self setName:name withColor:color withFont:font];
    
    if (glyph != nil && glyphFont != nil) {
        CGRect glyphFrame = CGRectMake(ICONPADDING - (ICONSIZE/2), ICONPADDING + GLYPHPADDINGADJUST, 2*ICONSIZE, ICONSIZE + GLYPHPADDINGADJUST);
        _glyph = [[UILabel alloc] initWithFrame:glyphFrame];
        self.glyph.backgroundColor = color;
        self.glyph.textColor = [UIColor whiteColor];
        self.glyph.textAlignment = UITextAlignmentCenter;
        self.glyph.font = glyphFont;
        self.glyph.text = glyph;
        [self addSubview:self.glyph];
    }
    else {
        _glyph = nil;
    }
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
        [self.delegate diyMenuAction:self.name.text];
    }
}

@end
