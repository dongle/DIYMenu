//
//  DIYMenu.m
//  DIYMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYMenu.h"
#import "DIYMenuOptions.h"

#import "DIYMenuItem.h"

#import "DIYWindowPassthrough.h"

#import <QuartzCore/QuartzCore.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface DIYMenu ()
// Menu Item management
@property                     NSMutableArray            *menuItems;

// State
@property                     BOOL                      isActivated;

// Internal
@property (unsafe_unretained) NSObject<DIYMenuDelegate> *delegate;
@property (nonatomic)         DIYWindowPassthrough      *overlayWindow;
@property (weak)              UIView                    *blockingView;
@end

@implementation DIYMenu

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuItems = [[NSMutableArray alloc] init];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = true;
    }
    return self;
}

#pragma mark - Class methods

+ (DIYMenu *)sharedView
{
    static dispatch_once_t once;
    static DIYMenu *sharedView;
    dispatch_once(&once, ^{
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y += ITEMHEIGHT;
        frame.size.height -= ITEMHEIGHT;
        frame.origin.x += ITEMHEIGHT;
        frame.size.width -= ITEMHEIGHT;
        sharedView = [[DIYMenu alloc] initWithFrame:frame];
        sharedView.clipsToBounds = true;
    });
    return sharedView;
}

+ (void)show
{
    [[DIYMenu sharedView] showMenu];
}

+ (void)dismiss
{
    [[DIYMenu sharedView] dismissMenu];
}

+ (BOOL)isActivated
{
    return [DIYMenu sharedView].isActivated;
}

+ (void)setDelegate:(NSObject<DIYMenuDelegate> *)delegate
{
    [DIYMenu sharedView].delegate = delegate;
}

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font
{
    [[DIYMenu sharedView] addItem:name withIcon:image withColor:color withFont:font];
}

+ (void)addMenuItem:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont
{
    [[DIYMenu sharedView] addItem:name withGlyph:glyph withColor:color withFont:font withGlyphFont:glyphFont];
}

#pragma mark - Getters

- (UIWindow *)overlayWindow
{
    if(!self->_overlayWindow) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        UIApplication *application = [UIApplication sharedApplication];
        
        _overlayWindow = [[DIYWindowPassthrough alloc] initWithFrame:screenBounds];
        self->_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self->_overlayWindow.backgroundColor = [UIColor clearColor];
        self->_overlayWindow.autoresizesSubviews = true;
        self->_overlayWindow.exclusiveTouch = false;
        
        CGFloat padding = ITEMHEIGHT;
        if (!application.statusBarHidden) {
            if (UIInterfaceOrientationIsPortrait(application.statusBarOrientation)) {
                padding += application.statusBarFrame.size.height;
            }
            else {
                padding += application.statusBarFrame.size.width;
            }
        }
        
        CGRect blockingFrame = CGRectMake(screenBounds.origin.x, screenBounds.origin.y + padding, screenBounds.size.width, screenBounds.size.height);
        UIView *blocking = [[UIView alloc] initWithFrame:blockingFrame];
        _blockingView = blocking;
        self.blockingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.blockingView.backgroundColor = [UIColor blackColor];
        self.blockingView.alpha = 0.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
        [self.blockingView addGestureRecognizer:tap];
        
        [self->_overlayWindow addSubview:self.blockingView];
    }
    return self->_overlayWindow;
}

#pragma mark - Show and Dismiss methods

- (void)showMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Bring the overlay window container thing to the front
        [self.overlayWindow makeKeyAndVisible];
        
        // Add self to overlayWindow then make the window key for MAXIMUM BLOCKAGE
        if (!self.superview) {
            [self.overlayWindow addSubview:self];
        }
        
        // Ensure orientation is proper
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self.overlayWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            self.overlayWindow.frame = CGRectMake(0, 0, self.overlayWindow.frame.size.height, self.overlayWindow.frame.size.width);
            
            self.frame = CGRectMake(0, ITEMHEIGHT, self.overlayWindow.frame.size.height, self.overlayWindow.frame.size.width - ITEMHEIGHT);
        }
        
        //
        // Animate in items
        //
        
        [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
            item.transform = CGAffineTransformMakeTranslation(0, -ITEMHEIGHT * (idx + 2));
        }];
        
        [UIView animateWithDuration:0.4f delay:0.01f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
                item.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
            
        } completion:^(BOOL finished) {
            //
        }];
        
        //
        
        [UIView animateWithDuration:0.2f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.blockingView.alpha = 0.75f;
        } completion:^(BOOL finished) {
            //
        }];
        
    });
    
    self.isActivated = true;
    
    // Delegate call
    if ([self.delegate respondsToSelector:@selector(menuActivated)]) {
        [self.delegate performSelectorOnMainThread:@selector(menuActivated) withObject:nil waitUntilDone:false];
    }
}

- (void)dismissMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Animate out the items
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
                item.transform = CGAffineTransformMakeTranslation(0, (CGFloat) -ITEMHEIGHT * (idx + 2));
            }];
            
        } completion:^(BOOL finished) {
            //
        }];
        
        
        // Fade out the overlay window and remove self from it
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.blockingView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.overlayWindow = nil;
            
            [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                if ([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                    [window makeKeyWindow];
                    *stop = YES;
                }
            }];
        }];
    });
    
    self.isActivated = false;
}

#pragma mark - UI

- (void)tappedBackground
{
    [self dismissMenu];
    if ([self.delegate respondsToSelector:@selector(menuCancelled)]) {
        [self.delegate performSelectorOnMainThread:@selector(menuCancelled) withObject:nil waitUntilDone:false];
    }
}

- (void)diyMenuAction:(NSString *)action
{
    [self.delegate menuItemSelected:action];
    [self dismissMenu];
}

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

#pragma mark - Item management

- (CGRect)newItemFrame
{
    UIApplication *application = [UIApplication sharedApplication];
    
    float padding;
    if (UIInterfaceOrientationIsPortrait(application.statusBarOrientation)) {
        padding = application.statusBarHidden ? 0 : application.statusBarFrame.size.height;
    } else {
        padding = application.statusBarHidden ? 0 : application.statusBarFrame.size.width;
    }
    
    int itemCount = [self.menuItems count] + 1;
    
    return CGRectMake(0, padding + itemCount*ITEMHEIGHT, self.frame.size.width, ITEMHEIGHT);
}

- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font
{
    DIYMenuItem *item = [[DIYMenuItem alloc] initWithFrame:[self newItemFrame]];
    [item setName:name withIcon:image withColor:color withFont:font];
    item.layer.shouldRasterize = true;
    item.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    item.delegate = self;
    
    [self.menuItems addObject:item];
    [self addSubview:item];
}

- (void)addItem:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont
{
    DIYMenuItem *item = [[DIYMenuItem alloc] initWithFrame:[self newItemFrame]];
    [item setName:name withGlyph:glyph withColor:color withFont:font withGlyphFont:glyphFont];
    item.delegate = self;
    
    [self.menuItems addObject:item];
    [self addSubview:item];
}

+ (void)hideMenuItemNamed:(NSString *)name
{
    for (DIYMenuItem *item in [DIYMenu sharedView].menuItems) {
        if ([item.name.text isEqualToString:name]) {
            item.hidden = true;
        }
    }
}

+ (void)showMenuItemNamed:(NSString *)name
{
    for (DIYMenuItem *item in [DIYMenu sharedView].menuItems) {
        if ([item.name.text isEqualToString:name]) {
            item.hidden = false;
        }
    }
}

@end
