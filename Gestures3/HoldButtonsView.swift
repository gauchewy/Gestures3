//
//  HoldButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import SwiftUI
import UIKit

struct HoldButtonViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = HoldButtonsViewController

    func makeUIViewController(context: Context) -> HoldButtonsViewController {
        return HoldButtonsViewController()
    }

    func updateUIViewController(_ uiViewController: HoldButtonsViewController, context: Context) {
    }
}

class HoldButtonsView: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        path = UIBezierPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let location = touchPoint.location(in: self)
        
        path.move(to: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let location = touchPoint.location(in: self)
        
        path.addLine(to: location)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        path.lineWidth = 2.0
        UIColor.red.setStroke()
        path.stroke()
    }
}

class HoldButtonsViewController: UIViewController {
    
    var drawView: HoldButtonsView!
    var animateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DrawView
        drawView = HoldButtonsView(frame: self.view.frame)
        self.view.addSubview(drawView)
        
        // Animate Button
        let buttonSize: CGFloat = 50
        animateButton = UIButton(frame: CGRect(x: buttonSize/2, y: buttonSize/2, width: buttonSize, height: buttonSize))
        animateButton.backgroundColor = .blue
        animateButton.layer.cornerRadius = buttonSize/2

        animateButton.addTarget(self, action: #selector(animateButtonAction), for: .touchUpInside)
        
        self.view.addSubview(animateButton)
    }
    
    @objc func animateButtonAction() {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.path = drawView.path.cgPath
        animation.speed = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        animateButton.layer.add(animation, forKey: "animation")
    }
}
