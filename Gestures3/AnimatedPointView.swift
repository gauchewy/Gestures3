//
//  AnimatedPointView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import UIKit


class AnimatedPointView: UIView {
    let button = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
    var pathLayer = CALayer()
    var buttonIsPressed = false
    
    func animateAlong(path: UIBezierPath) {
        let animation = CAKeyframeAnimation()
        animation.path = path.cgPath
        animation.keyPath = "position"
        animation.speed = 0.1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        button.layer.add(animation, forKey: nil)
    }
}
