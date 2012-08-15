//
//  DIYHeaderMenu.m
//  DIYHeaderMenu
//
//  Created by Jonathan Beilin on 8/13/12.
//  Copyright (c) 2012 DIY. All rights reserved.
//

#import "DIYHeaderMenu.h"
#import "DIYHeaderItem.h"
#import "DIYHeaderOptions.h"

@interface DIYHeaderMenu ()

@end

@implementation DIYHeaderMenu

@synthesize items = _items;
@synthesize overlayWindow = _overlayWindow;
@synthesize isActivated = _isActivated;

@synthesize currentItem = _currentItem;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [[NSMutableArray alloc] init];
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
        sharedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
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

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{
    [[DIYHeaderMenu sharedView] addItem:name withIcon:image withColor:color];
}


#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!self->_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self->_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self->_overlayWindow.backgroundColor = [UIColor blackColor];
        self->_overlayWindow.alpha = 0.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
        [self->_overlayWindow addGestureRecognizer:tap];
        [tap release];
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
        
        [self.overlayWindow makeKeyAndVisible];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.overlayWindow.alpha = 0.75f;
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

#pragma mark - Item management

/* UGH this is way too long fml
- (void)addHeaderWithDismissIcon:(UIImage *)dismissImage withColor:(UIColor *)color withTitle:(NSString *)title withButtonImage:(UIImage *)buttonImage withButtonName:(NSString *)buttonName
{
    
}
 */

- (void)addItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color
{
    UIApplication *application = [UIApplication sharedApplication];
    
    float statusBarPadding = application.statusBarHidden ? 0 : application.statusBarFrame.size.height;
    
    int itemCount = [self.items count];
    NSLog(@"Items: %i", itemCount);
    CGRect itemFrame = CGRectMake(0, statusBarPadding + itemCount*ITEMHEIGHT, self.frame.size.width, ITEMHEIGHT);
    DIYHeaderItem *item = [[DIYHeaderItem alloc] initWithFrame:itemFrame];
    [item setName:name withIcon:image withColor:color];
    
    [self.items addObject:item];
    [self addSubview:item];
    [item release];
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    [_items release], _items = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end
