//
//  DIYHeaderItem.h
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIYHeaderItem : UIView

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, assign) BOOL isSelected;

- (void)setName:(UILabel *)name withIcon:(UIImage *)image withColor:(UIColor *)color;

@end
