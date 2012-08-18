//
//  DIYHeaderMenu.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYHeaderMenu.h"
#import "DIYHeaderOptions.h"

#import "DIYHeaderItem.h"
#import "DIYMenuButton.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface DIYHeaderMenu ()

@end

@implementation DIYHeaderMenu

@synthesize menuItems = _menuItems;
@synthesize titleButtons = _titleButtons;

@synthesize isActivated = _isActivated;
@synthesize currentItem = _currentItem;

@synthesize titleBar = _titleBar;

@synthesize overlayWindow = _overlayWindow;
@synthesize blockingView = _blockingView;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuItems = [[NSMutableArray alloc] init];
        _titleButtons = [[NSMutableArray alloc] init];
        _titleBar = nil;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = true;
    }
    return self;
}

#pragma mark - Class methods

+ (DIYHeaderMenu *)sharedView
{
    static dispatch_once_t once;
    static DIYHeaderMenu *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[DIYHeaderMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedView;
}

+ (void)show
{
    [[DIYHeaderMenu sharedView] showMenu];
}

+ (void)dismiss
{
    [[DIYHeaderMenu sharedView] dismissMenu];
}

+ (BOOL)isActivated
{
    return [DIYHeaderMenu sharedView].isActivated;
}

+ (void)setDelegate:(NSObject<DIYMenuDelegate> *)delegate
{
    [DIYHeaderMenu sharedView].delegate = delegate;
}

+ (void)setTitle:(NSString *)title withDismissIcon:(UIImage *)dismissImage withColor:(UIColor *)color
{
    [[DIYHeaderMenu sharedView] setTitle:title withDismissIcon:dismissImage withColor:color];
}

+ (void)addTitleButton:(NSString *)name withIcon:(UIImage *)image
{
    [[DIYHeaderMenu sharedView] addTitleButton:name withIcon:image];
}

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{
    [[DIYHeaderMenu sharedView] addItem:name withIcon:image withColor:color];
}


#pragma mark - Getters

- (UIWindow *)overlayWindow
{
    if(!self->_overlayWindow) {
        CGRect overlayFrame;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            CGRect bounds = [UIScreen mainScreen].bounds;
            overlayFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
        }
        else {
            overlayFrame = [UIScreen mainScreen].bounds;
        }
        
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self->_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self->_overlayWindow.backgroundColor = [UIColor clearColor];
        self->_overlayWindow.autoresizesSubviews = true;
        
        _blockingView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.blockingView.backgroundColor = [UIColor blackColor];
        self.blockingView.alpha = 0.0f;
        self.blockingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
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
            [self.titleBar refreshNoise];
            for (DIYHeaderItem *item in self.menuItems) {
                [item refreshNoise];
            }
        }
        
        // Bring the overlay window container thing to the front
        [self.overlayWindow makeKeyAndVisible];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.blockingView.alpha = 0.75f;
        }];
        
        // slide in menu
        
        [self setNeedsDisplay];
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
        [UIView animateWithDuration:0.2f animations:^{
            self.overlayWindow.alpha = 0.0f;
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

#pragma mark - Drawing

/*
- (void)drawRect:(CGRect)rect
{
    
}
 */

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

- (void)setTitle:(NSString *)title withDismissIcon:(UIImage *)dismissImage withColor:(UIColor *)color
{
    if (_titleBar == nil) {
        UIApplication *application = [UIApplication sharedApplication];        
        float padding = application.statusBarHidden ? 0 : application.statusBarFrame.size.height;
        _titleBar = [[DIYHeaderItem alloc] initWithFrame:CGRectMake(0, padding, self.frame.size.width, ITEMHEIGHT)];
        
        [self.titleBar setName:title withIcon:dismissImage withColor:color];
        self.titleBar.isSelectable = false;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
        self.titleBar.icon.userInteractionEnabled = true;
        [self.titleBar.icon addGestureRecognizer:tap];
        [tap release];
        
        [self addSubview:self.titleBar];
    }
}

- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{
    UIApplication *application = [UIApplication sharedApplication];
    
    float padding = application.statusBarHidden ? 0 : application.statusBarFrame.size.height;
    padding += self.titleBar ? ITEMHEIGHT : 0;
    
    int itemCount = [self.menuItems count];
    
    CGRect itemFrame = CGRectMake(0, padding + itemCount*ITEMHEIGHT, self.frame.size.width, ITEMHEIGHT);
    DIYHeaderItem *item = [[DIYHeaderItem alloc] initWithFrame:itemFrame];
    [item setName:name withIcon:image withColor:color];
    item.delegate = self;
    
    [self.menuItems addObject:item];
    [self addSubview:item];
    [item release];
}

- (void)addTitleButton:(NSString *)name withIcon:(UIImage *)image
{
    int buttonCount = [self.titleButtons count] + 1;
    
    DIYMenuButton *button = [[DIYMenuButton alloc] initWithImage:image];
    button.userInteractionEnabled = true;
    button.delegate = self;
    button.name = name;
    button.frame = CGRectMake(self.titleBar.frame.size.width - ICONPADDING - (buttonCount * (ICONPADDING + ICONSIZE)), ICONPADDING, ICONSIZE, ICONSIZE);
    
    [self.titleButtons addObject:button];
    [self.titleBar addSubview:button];
    [button release];
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    [_menuItems release], _menuItems = nil;
    [_titleButtons release], _titleButtons = nil;
    [_titleBar release], _titleBar = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
