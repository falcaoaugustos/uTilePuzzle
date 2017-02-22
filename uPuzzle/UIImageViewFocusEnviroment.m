//
//  UIImageViewFocusEnviroment.m
//  bridgingHeaderTvTest
//
//  Created by Augusto Falcão on 2/16/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

#import "UIImageViewFocusEnviroment.h"

@implementation UIImageViewFocusEnviroment

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 1;
    self.backgroundColor = [[UIColor alloc] initWithWhite: 1.0 alpha: 0.5];
}

- (UIMotionEffectGroup *)motionEffectGroup {
    
    UIInterpolatingMotionEffect *horizonMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizonMotionEffect.minimumRelativeValue = @-1.0;
    horizonMotionEffect.maximumRelativeValue = @1.0;
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    [verticalMotionEffect setMinimumRelativeValue: @-1.0];
    [verticalMotionEffect setMaximumRelativeValue: @1.0];
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    [motionEffectGroup setMotionEffects: [[NSArray alloc] initWithObjects: horizonMotionEffect, verticalMotionEffect, nil]];
    return motionEffectGroup;
}

- (void) didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimatorCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    if (context.nextFocusedItem == self) {
        [coordinator addCoordinatedAnimations: ^{
            self.transform = CGAffineTransformMakeScale(2.0, 2.0);
            self.layer.borderWidth = 2.0f;
            self.layer.borderColor = [UIColor blackColor].CGColor;
            [self.layer setShadowOpacity: 0.2];
            [self.layer setShadowOffset: CGSizeMake(0, 15)];
            self.backgroundColor = [self.backgroundColor colorWithAlphaComponent: 1.0];
            [self addMotionEffect: self.motionEffectGroup];
        } completion: ^{
            nil;
        }];
    } else if (context.previouslyFocusedItem == self) {
        [coordinator addCoordinatedAnimations: ^{
            self.transform = CGAffineTransformIdentity;
            [self.layer setShadowOpacity: 0.0];
            //[self.layer setShadowOffset: CGSizeMake(0, 15)];
            self.backgroundColor = [self.backgroundColor colorWithAlphaComponent: 0.5];
            [self removeMotionEffect: self.motionEffectGroup];
        } completion: ^{
            nil;
        }];
    }
}

- (BOOL) becomeFirstResponder {
    return YES;
}

- (BOOL) canBecomeFocused {
    return YES;
}

@end
