//
//  DIYHeaderMenu.h
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//
//  Thanks to Sam Vermette for sharing good ideas and clean
//  code for managing a singleton overlay view in SVProgressHUD.

#import <UIKit/UIKit.h>

@class DIYHeaderItem;

@protocol DIYHeaderMenuDelegate <NSObject>
@required
- (void)menuItemSelected:(NSString *)action;
@optional
- (void)menuActivated;
- (void)menuCancelled;
@end

@interface DIYHeaderMenu : UIView {

}

@property (assign) NSObject<DIYHeaderMenuDelegate> *delegate;

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) UIWindow *overlayWindow;
@property (nonatomic, assign) BOOL isActivated;
@property (nonatomic, assign) DIYHeaderItem *currentItem;

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color;

+ (void)show;
+ (void)dismiss;
+ (BOOL)isActivated;

@end
