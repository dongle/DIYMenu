//
//  DIYMenu.h
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//
//  Thanks to Sam Vermette for sharing good ideas and clean
//  code for managing a singleton overlay view in SVProgressHUD.

#import <UIKit/UIKit.h>

@class DIYMenuItem, DIYWindowPassthrough;

@protocol DIYMenuDelegate <NSObject>
@required
- (void)menuItemSelected:(NSString *)action;
@optional
- (void)menuActivated;
- (void)menuCancelled;
@end

@protocol DIYMenuItemDelegate <NSObject>
- (void)diyMenuAction:(NSString *)action;
@end

@interface DIYMenu : UIView <DIYMenuItemDelegate>

//
// Class methods
//

// Setup
+ (void)setDelegate:(NSObject<DIYMenuDelegate> *)delegate;

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;
+ (void)addMenuItem:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont;

// Usage
+ (void)show;
+ (void)dismiss;
+ (BOOL)isActivated;

+ (void)clearMenu;

//

@end
