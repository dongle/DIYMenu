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

#import <QuartzCore/QuartzCore.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface DIYMenu ()
// Menu Item management
@property (nonatomic, retain) NSMutableArray               *menuItems;

// State
@property (nonatomic, assign) BOOL                         isActivated;

// Internal
@property (assign)            NSObject<DIYMenuDelegate>    *delegate;
@property (nonatomic, assign) UIWindow                     *overlayWindow;
@property (nonatomic, assign) UIView                       *blockingView;
@end

@implementation DIYMenu

@synthesize menuItems       = _menuItems;

@synthesize isActivated     = _isActivated;

@synthesize overlayWindow   = _overlayWindow;
@synthesize blockingView    = _blockingView;

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
        sharedView = [[DIYMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
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

#pragma mark - Getters

- (UIWindow *)overlayWindow
{
    if(!self->_overlayWindow) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        UIApplication *application = [UIApplication sharedApplication];
        
        _overlayWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self->_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self->_overlayWindow.backgroundColor = [UIColor clearColor];
        self->_overlayWindow.autoresizesSubviews = true;
        
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
        _blockingView = [[[UIView alloc] initWithFrame:blockingFrame] autorelease];
        self.blockingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.blockingView.backgroundColor = [UIColor blackColor];
        self.blockingView.alpha = 0.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
        [self.blockingView addGestureRecognizer:tap];
        [tap release];
        
        [self->_overlayWindow addSubview:self.blockingView];
    }
    return self->_overlayWindow;
}

#pragma mark - Show and Dismiss methods

- (void)showMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Add self to overlayWindow then make the window key for MAXIMUM BLOCKAGE
        if (!self.superview) {
            [self.overlayWindow addSubview:self];
        }
        
        // Ensure orientation is proper
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self.overlayWindow.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            self.overlayWindow.frame = CGRectMake(0, 0, self.overlayWindow.frame.size.height, self.overlayWindow.frame.size.width);
            
            self.frame = CGRectMake(0, 0, self.overlayWindow.frame.size.height, self.overlayWindow.frame.size.width);
            
            // Refresh the noise on the header items (so the noise covers the entire width
            for (DIYMenuItem *item in self.menuItems) {
                [item refreshNoise];
            }
        }
        
        // Bring the overlay window container thing to the front
        [self.overlayWindow makeKeyAndVisible];
        
        //
        // Animate in items
        //
        
        [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
            item.frame = CGRectMake(item.frame.origin.x, (CGFloat) -ITEMHEIGHT * (idx + 2), item.frame.size.width, item.frame.size.height);
        }];
        
        [UIView animateWithDuration:0.4f delay:0.01f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
                item.frame = CGRectMake(item.frame.origin.x, item.menuPosition.y, item.frame.size.width, item.frame.size.height);
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
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
                item.frame = CGRectMake(item.frame.origin.x, (CGFloat) -ITEMHEIGHT * (idx + 2), item.frame.size.width, item.frame.size.height);
            }];
            
        } completion:^(BOOL finished) {
            //
        }];
        
        
        // Fade out the overlay window and remove self from it
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.blockingView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_overlayWindow release], _overlayWindow = nil;
            
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

- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font
{
    UIApplication *application = [UIApplication sharedApplication];
    
    float padding = application.statusBarHidden ? 0 : application.statusBarFrame.size.height;
    
    int itemCount = [self.menuItems count] + 1;
    
    CGRect itemFrame = CGRectMake(0, padding + itemCount*ITEMHEIGHT, self.frame.size.width, ITEMHEIGHT);
    DIYMenuItem *item = [[DIYMenuItem alloc] initWithFrame:itemFrame];
    [item setName:name withIcon:image withColor:color withFont:font];
    item.delegate = self;
    
    [self.menuItems addObject:item];
    [self addSubview:item];
    [item release];
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    [_menuItems release], _menuItems = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
