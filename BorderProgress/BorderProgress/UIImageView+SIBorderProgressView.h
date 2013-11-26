//
//  UIImageView+SIBorderProgressView.h
//  BorderProgress
//
//  Created by Ivan Sapozhnik on 11/21/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIBorderProgressTheme.h"

@interface UIImageView (SIBorderProgressView)

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGFloat progress;

- (void)setProgress:(CGFloat)aProgress withTheme:(SIBorderProgressTheme *)theme;
- (void)setProgress:(CGFloat)aProgress withTheme:(SIBorderProgressTheme *)theme animaed:(BOOL)anAnimated;

@end
