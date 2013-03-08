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

@interface DIYMenu ()
@property                       NSMutableArray              *menuItems;
@property                       BOOL                        isActivated;
@property                       BOOL                        isLandscape;
@property                       UIView                      *shadingView;

@property (unsafe_unretained)   NSObject<DIYMenuDelegate>   *delegate;
@end

@implementation DIYMenu

#pragma mark - Init

- (void)setup
{
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x -= ITEMHEIGHT;
    self.frame = frame;
    _menuItems = [[NSMutableArray alloc] init];
    self.clipsToBounds = true;
    
    // Set up shadingview
    _shadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
    self.shadingView.backgroundColor = [UIColor blackColor];
    self.shadingView.alpha = 0.0f;
    [self addSubview:self.shadingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
    [self.shadingView addGestureRecognizer:tap];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Class methods

+ (DIYMenu *)sharedView
{
    static dispatch_once_t once;
    static DIYMenu *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[DIYMenu alloc] init];
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

+ (void)clearMenu
{
    [[DIYMenu sharedView] clearMenu];
}

#pragma mark - Show and Dismiss methods

- (void)showMenu
{
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    
    //
    // Animate in items & darken background
    //
    
    [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
        item.transform = CGAffineTransformMakeTranslation(0, -ITEMHEIGHT * (idx + 2));
    }];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
            item.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        self.shadingView.alpha = 0.75f;
    } completion:^(BOOL finished) {
        //
    }];
    
    self.isActivated = true;
    
    // Delegate call
    if ([self.delegate respondsToSelector:@selector(menuActivated)]) {
        [self.delegate performSelectorOnMainThread:@selector(menuActivated) withObject:nil waitUntilDone:false];
    }
}

- (void)dismissMenu
{
    // Animate out the items
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
            item.transform = CGAffineTransformMakeTranslation(0, (CGFloat) -ITEMHEIGHT * (idx + 2));
        }];
    } completion:^(BOOL finished) {
        //
    }];
    
    // Fade out the overlay window and remove self from it
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.shadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
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
    
    int itemCount = [self.menuItems count];
    
    return CGRectMake(0, padding + itemCount*ITEMHEIGHT, self.frame.size.height, ITEMHEIGHT);
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

- (void)clearMenu
{
    [self.menuItems enumerateObjectsUsingBlock:^(DIYMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item removeFromSuperview];
    }];
    
    [self.menuItems removeAllObjects];
}

@end
