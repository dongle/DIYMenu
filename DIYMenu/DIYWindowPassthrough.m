//
//  DIYWindowPassthrough.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/22/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYWindowPassthrough.h"

@implementation DIYWindowPassthrough

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL passTouch = false;
    for (UIView *view in self.subviews) {
        if (!view.hidden && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            passTouch = true;
        }
    }
    return passTouch;
}

@end
