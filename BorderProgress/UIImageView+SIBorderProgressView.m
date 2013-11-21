//
//  UIImageView+SIBorderProgressView.m
//  BorderProgress
//
//  Created by Ivan Sapozhnik on 11/21/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "UIImageView+SIBorderProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static void * const ShapeLayerTagKey = (void *)&ShapeLayerTagKey;
static void * const ProgressTagKey = (void *)&ProgressTagKey;

@implementation UIImageView (SIBorderProgressView)

@dynamic progressLayer;
@dynamic progress;

- (void)setProgress:(CGFloat)aProgress withTheme:(SIBorderProgressTheme *)theme
{
    [self setProgress:aProgress withTheme:theme animaed:NO];
}

- (void)setProgress:(CGFloat)aProgress withTheme:(SIBorderProgressTheme *)theme animaed:(BOOL)anAnimated
{
    if (nil == self.progressLayer || ![[self.layer sublayers] containsObject:self.progressLayer])
    {
        [self setupWithTheme:theme];
    }
    
    if (aProgress > 0.0f) {
        if (anAnimated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.delegate = self;
            animation.fromValue = self.progress == 0.0 ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:aProgress];
            animation.duration = 1;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.removedOnCompletion = YES;
            [self.progressLayer addAnimation:animation forKey:@"animation"];
            self.progressLayer.strokeEnd = aProgress;
            
            if (aProgress == 1.0f)
            {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                animation.delegate = self;
                animation.fromValue = @1.0;
                animation.toValue = @0.0;
                animation.duration = 1;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                animation.removedOnCompletion = NO;
                [self.progressLayer addAnimation:animation forKey:@"opacity"];
                return;
            }
            
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.progressLayer.strokeEnd = aProgress;
            [CATransaction commit];
        }
    }
    
    [self setProgress:aProgress];
}

#pragma mark - Private

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.progressLayer animationForKey:@"opacity"] == anim)
    {
        [self.progressLayer removeFromSuperlayer];
        self.progressLayer = nil;
        [self setProgress:0.0];
    }
}

- (CAShapeLayer *)progressLayer
{
    CAShapeLayer *theLayer = (CAShapeLayer *)objc_getAssociatedObject(self, ShapeLayerTagKey);
    return theLayer;
}

- (void)setProgressLayer:(CAShapeLayer *)newProgressLayer
{
    objc_setAssociatedObject(self, ShapeLayerTagKey, newProgressLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)progress
{
    NSNumber *progressValue = (NSNumber *)objc_getAssociatedObject(self, ProgressTagKey);
    return progressValue ? progressValue.floatValue : 0.0;
}

- (void)setProgress:(CGFloat)newProgress
{
    NSNumber *newProgressValue = [NSNumber numberWithFloat:newProgress];
    objc_setAssociatedObject(self, ProgressTagKey, newProgressValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setupWithTheme:(SIBorderProgressTheme *)theme
{
    self.contentMode = UIViewContentModeRedraw;
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.strokeColor = theme.lineColor.CGColor;
    self.progressLayer.fillColor = nil;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineWidth = theme.lineWidth;
    [self.layer insertSublayer:self.progressLayer atIndex:0];
    
    self.progress = 0.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
    [self updatePath];
}

- (void)updatePath
{
    self.progressLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
