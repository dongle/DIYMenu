//
//  DIYMenuUIView+Noise.h
//  Field Recorder
//
//  Created by Andrew Sliwinski on 6/27/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DIYMenuNoiseLayer : CALayer
+ (UIImage *)noiseTileImage;
+ (void)drawPixelInContext:(CGContextRef)context point:(CGPoint)point width:(CGFloat)width opacity:(CGFloat)opacity whiteLevel:(CGFloat)whiteLevel;
@end

@interface UIView (DIYMenuNoise)

// Can be used directly on UIView
- (DIYMenuNoiseLayer *)applyNoise;
- (DIYMenuNoiseLayer *)applyNoiseWithOpacity:(CGFloat)opacity atLayerIndex:(NSUInteger)layerIndex;
- (DIYMenuNoiseLayer *)applyNoiseWithOpacity:(CGFloat)opacity;

// Can be invoked from a drawRect() method
- (void)drawCGNoise;
- (void)drawCGNoiseWithOpacity:(CGFloat)opacity;
- (void)drawCGNoiseWithOpacity:(CGFloat)opacity blendMode:(CGBlendMode)blendMode;

@end