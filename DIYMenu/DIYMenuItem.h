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
@property (unsafe_unretained) NSObject<DIYMenuItemDelegate> *delegate;
@property (assign)            BOOL                          isSelected;
@property                     UIView                        *shadingView;
@property (assign)            CGPoint                       menuPosition;

// Fun stuff
@property                     UILabel                       *name;
@property                     UIImageView                   *icon;
@property                     UILabel                       *glyph;

- (void)setName:(NSString *)name withColor:(UIColor *)color withFont:(UIFont *)font;
- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;
- (void)setName:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont;

@end
