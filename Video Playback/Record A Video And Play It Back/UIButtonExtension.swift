//
//  UIButtonExtension.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 6/6/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

extension UIButton {
    func pulsate() {
         let pulse = CASpringAnimation(keyPath: "transform.scale")
         pulse.duration = 0.9
         pulse.fromValue = 1
         pulse.toValue = 1.5
         pulse.autoreverses = true
         pulse.repeatCount = .infinity
         pulse.initialVelocity = 0.5
         pulse.damping = 1.0
         pulse.stiffness = 5
         
         layer.add(pulse, forKey: "pulse")
    }
}
