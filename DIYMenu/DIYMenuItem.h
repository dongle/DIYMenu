//
//  DIYMenuItem.h
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DIYMenu.h"

@class NoiseLayer;

@interface DIYMenuItem : UIView

// Internals
@property (nonatomic, assign) NSObject<DIYMenuItemDelegate> *delegate;
@property (nonatomic, assign) NoiseLayer *noise;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isSelectable;
@property (nonatomic, retain) UIView *shadingView;
@property (nonatomic, assign) CGPoint menuPosition;

// Fun stuff
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIImageView *icon;

- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;

- (void)refreshNoise;

@end
