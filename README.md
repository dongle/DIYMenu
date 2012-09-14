## DIYMenu

It's a modal menu that looks OK. It's a singleton and it'll send strings to a delegate based on what selections the user makes.

## Getting Started

```objective-c
#import "DIYMenu.h"
```

Setup:
```objective-c

UIFont *font = [UIFont fontWithName:@"Helvetica-Neue" size:32];

// Set the delegate
[DIYMenu setDelegate:self];

// Add menu items
[DIYMenu addMenuItem:@"Portfolio" withIcon:[UIImage imageNamed:@"portfolioIcon@2x.png"] withColor:[UIColor colorWithRed:0.18f green:0.76f blue:0.93f alpha:1.0f] withFont:font];
[DIYMenu addMenuItem:@"Skills" withIcon:[UIImage imageNamed:@"skillsIcon@2x.png"] withColor:[UIColor colorWithRed:0.28f green:0.55f blue:0.95f alpha:1.0f] withFont:font];
```

Use:
```objective-c
[DIYMenu show];
```

Then implement the delegate methods and do stuff I guess.

PS – Link these bad babies:

```bash
QuartzCore.framework
CoreGraphics.framework
```

## Methods
```objective-c

//
// Show / dismiss / check status
//
+ (void)show;
+ (void)dismiss;
+ (BOOL)isActivated;

//
// Setup
//
+ (void)setDelegate:(NSObject<DIYMenuDelegate> *)delegate;

+ (void)addMenuItem:(NSString *)name withIcon:(UIImage *)image withColor:(UIColor *)color withFont:(UIFont *)font;
// Alternately, use a glyph instead of a UIImage
+ (void)addMenuItem:(NSString *)name withGlyph:(NSString *)glyph withColor:(UIColor *)color withFont:(UIFont *)font withGlyphFont:(UIFont *)glyphFont;
```

## Delegate Methods
```objective-c
@protocol DIYMenuDelegate <NSObject>
@required
- (void)menuItemSelected:(NSString *)action;
@optional
- (void)menuActivated;
- (void)menuCancelled;
@end
```

## Configuration
DIYMenuOptions.h holds some config options so you can set the default font and some sizes and stuff.

## iOS Support
DIYMenu is tested on iOS 5 and up.

## ARC
DIYMenu as of v0.2.0 is built using ARC. If you are including DIYMenu in a project that does not use Automatic Reference Counting (ARC), you will need to set the -fobjc-arc compiler flag on all of the DIYMenu source files. To do this in Xcode, go to your active target and select the "Build Phases" tab. Now select all DIYMenu source files, press Enter, insert -fobjc-arc and then "Done" to enable ARC for DIYMenu.

## LICENSE

Copyright 2012 DIY, Co.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.