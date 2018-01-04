//
//  UIViewFocusEnvironment.swift
//  uTilePuzzle
//
//  Created by Augusto Falcão on 9/24/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import UIKit

class UIViewFocusEnvironment: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }

    func motionEffectGroup() -> UIMotionEffectGroup {
        let horizonMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
        horizonMotionEffect.minimumRelativeValue = -1.0
        horizonMotionEffect.maximumRelativeValue = 1.0

        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -1.0
        verticalMotionEffect.maximumRelativeValue = 1.0

        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizonMotionEffect, verticalMotionEffect]

        return motionEffectGroup
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedItem === self {
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
                self.layer.shadowOpacity = 0.2
                self.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
                self.backgroundColor?.withAlphaComponent(1.0)
                self.addMotionEffect(self.motionEffectGroup())
            }, completion: nil)
        } else if context.previouslyFocusedItem === self {
            coordinator.addCoordinatedAnimations({
                self.transform = CGAffineTransform.identity
                self.layer.shadowOpacity = 0.0
                self.backgroundColor?.withAlphaComponent(0.5)
                self.removeMotionEffect(self.motionEffectGroup())
            }, completion: nil)
        }
    }

    override func becomeFirstResponder() -> Bool {
        return false
    }

    override var canBecomeFocused: Bool {
        return false
    }
}
