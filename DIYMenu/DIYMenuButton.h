//
//  DIYMenuButton.h
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/16/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIYMenu.h"

@interface DIYMenuButton : UIImageView

// Internals
@property (nonatomic, assign) NSObject<DIYMenuItemDelegate> *delegate;
@property (nonatomic, assign) BOOL                          isSelected;
@property (nonatomic, retain) UIView                        *shadingView;

// Public properties
@property (nonatomic, retain) NSString                      *name;

@end