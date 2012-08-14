//
//  DIYHeaderMenu.h
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DIYHeaderItem;

@protocol DIYHeaderMenuDelegate <NSObject>
@required
- (void)menuItemSelected:(DIYHeaderItem *)item;
@optional
- (void)menuActivated;
- (void)menuCancelled;
@end

@interface DIYHeaderMenu : UIView {
    /*
@private
    NSMutableArray *_items;
    UIWindow *_overlayWindow;
     */
}

@property (assign) NSObject<DIYHeaderMenuDelegate> *delegate;

@property (nonatomic, assign) BOOL isActivated;

// TODO: make private
@property (nonatomic, assign) DIYHeaderItem *currentItem;

- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color;

- (void)show;
- (void)dismiss;

@end
