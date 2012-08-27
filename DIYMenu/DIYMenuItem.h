//
//  DIYMenuItem.h
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DIYMenu.h"

@interface DIYMenuItem : UIView

// Internals
@property (nonatomic, assign) NSObject<DIYMenuItemDelegate> *delegate;
@property (nonatomic, assign) BOOL                          isSelected;
@property (nonatomic, retain) UIView                        *shadingView;
@property (nonatomic, assign) CGPoint                       menuPosition;

// Fun stuff
@property (nonatomic, retain) UILabel                       *name;
@property (nonatomic, retain) UIImageView                   *icon;
@property (nonatomic, retain) UILabel                       *glyph;

- (void)setName:(NSString *)name withColor:(UIColor *)color withFont:(UIFont *)font;
- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;
- (void)setName:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont;

@end
