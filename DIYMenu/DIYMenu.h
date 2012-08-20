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

@class DIYMenuItem;

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

@interface DIYMenu : UIView <DIYMenuItemDelegate> {

}

// Menu Item management
@property (nonatomic, retain) NSMutableArray *menuItems;
@property (nonatomic, retain) NSMutableArray *titleButtons;

// State
@property (nonatomic, assign) BOOL isActivated;
@property (nonatomic, assign) DIYMenuItem *currentItem;

// Title bar
@property (nonatomic, retain) DIYMenuItem *titleBar;

// Internal (should be private)
@property (assign) NSObject<DIYMenuDelegate> *delegate;
@property (nonatomic, assign) UIWindow *overlayWindow;
@property (nonatomic, assign) UIView *blockingView;

+ (void)setDelegate:(NSObject<DIYMenuDelegate> *)delegate;

+ (void)setTitle:(NSString *)title withDismissIcon:(UIImage *)dismissImage withColor:(UIColor *)color withFont:(UIFont *)font;
+ (void)addTitleButton:(NSString *)name withIcon:(UIImage *)image;
+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;

+ (void)show;
+ (void)dismiss;
+ (BOOL)isActivated;

@end
