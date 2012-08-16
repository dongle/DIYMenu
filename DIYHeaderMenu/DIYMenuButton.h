//
//  DIYMenuButton.h
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/16/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIYHeaderMenu.h"

@interface DIYMenuButton : UIImageView

@property (nonatomic, assign) NSObject<DIYMenuItemDelegate> *delegate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL isSelected;

@end