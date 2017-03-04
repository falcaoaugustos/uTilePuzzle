//
//  UIImageViewFocusEnviroment.h
//  bridgingHeaderTvTest
//
//  Created by Augusto Falcão on 2/16/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageViewFocusEnviroment : UIImageView <UIFocusEnvironment> {
    BOOL canBecomeFocused;
}

- (void) awakeFromNib;
- (UIMotionEffectGroup *)motionEffectGroup;
- (void) didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimatorCoordinator:(UIFocusAnimationCoordinator *)coordinator;
- (BOOL) becomeFirstResponder;

@end
