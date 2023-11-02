//
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import UIKit
import SwiftUI

//wrapper function for firstdrawpathview
struct FirstDrawPathViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FirstDrawPathView
    
    func makeUIViewController(context: Context) -> FirstDrawPathView {
        return FirstDrawPathView()
    }
    
    func updateUIViewController(_ uiViewController: FirstDrawPathView, context: UIViewControllerRepresentableContext<FirstDrawPathViewControllerRepresentable>) {}
}


class DrawPathView: UIView {
    var path: UIBezierPath?

    private let pathLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = nil
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(pathLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        path?.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)

        path = UIBezierPath()
        path?.move(to: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)

        path?.addLine(to: location)
        pathLayer.path = path?.cgPath
    }
}

class FirstDrawPathView: UIViewController {
    lazy var drawPathView: DrawPathView = {
        let view = DrawPathView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(drawPathView)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            drawPathView.topAnchor.constraint(equalTo: view.topAnchor),
            drawPathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            drawPathView.rightAnchor.constraint(equalTo: view.rightAnchor),
            drawPathView.bottomAnchor.constraint(equalTo: button.topAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leftAnchor.constraint(equalTo: view.leftAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func buttonTapped() {
        let secondDrawPathView = SecondDrawPathView()
        secondDrawPathView.firstPath = drawPathView.path
        navigationController?.pushViewController(secondDrawPathView, animated: true)
    }
}

class SecondDrawPathView: UIViewController {
    var firstPath: UIBezierPath?

    lazy var drawPathView: DrawPathView = {
        let view = DrawPathView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(drawPathView)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            drawPathView.topAnchor.constraint(equalTo: view.topAnchor),
            drawPathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            drawPathView.rightAnchor.constraint(equalTo: view.rightAnchor),
            drawPathView.bottomAnchor.constraint(equalTo: button.topAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leftAnchor.constraint(equalTo: view.leftAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func buttonTapped() {
        let finalView = FinalPathView()
        finalView.firstPath = firstPath
        finalView.secondPath = drawPathView.path
        navigationController?.pushViewController(finalView, animated: true)
    }
}

class FinalPathView: UIViewController {
    var firstPath: UIBezierPath?
    var secondPath: UIBezierPath?
    
    let firstButton = AnimatedPointView()
    let secondButton = AnimatedPointView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupButton(buttonView: firstButton, color: .red, path: firstPath)
        setupButton(buttonView: secondButton, color: .blue, path: secondPath)
    }
    
    func setupButton(buttonView: AnimatedPointView, color: UIColor, path: UIBezierPath?) {
        buttonView.button.backgroundColor = color
        buttonView.animateAlong(path: path ?? UIBezierPath())
        view.addSubview(buttonView.button)
        buttonView.button.addTarget(self, action: #selector(buttonDown(sender:)), for: [.touchDown, .touchDragInside])
        buttonView.button.addTarget(self, action: #selector(buttonUp(sender:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc func buttonDown(sender: UIButton) {
        print("button is pressed")
        guard let buttonView = view.subviews.compactMap({ $0 as? AnimatedPointView }).first(where: { $0.button == sender }) else { return }
        buttonView.buttonIsPressed = true
        scaleButton(sender, to: 1.5)
        sender.alpha = 0.5
    }

    @objc func buttonUp(sender: UIButton) {
        guard let buttonView = view.subviews.compactMap({ $0 as? AnimatedPointView }).first(where: { $0.button == sender }) else { return }
        buttonView.buttonIsPressed = false
        scaleButton(sender, to: 1)
        sender.alpha = 1
    }
    
    func scaleButton(_ button: UIButton, to scale: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
    }
}
