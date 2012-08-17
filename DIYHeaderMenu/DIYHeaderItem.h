//
//  DIYHeaderItem.h
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DIYHeaderMenu.h"

@class NoiseLayer;

@interface DIYHeaderItem : UIView

// Internals
@property (nonatomic, assign) NSObject<DIYMenuItemDelegate> *delegate;
@property (nonatomic, assign) NoiseLayer *noise;

// Fun stuff
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, assign) BOOL isSelected;

- (void)setName:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color;

- (void)refreshNoise;

@end
