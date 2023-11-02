//
//  AnimatedPointView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import UIKit

class AnimatedPointView: UIView {
    var button: UIButton!
    var pathLayer = CALayer()
    var buttonIsPressed = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(button)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(button)
    }

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
