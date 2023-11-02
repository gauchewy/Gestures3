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

    lazy var firstPathView: DrawPathView = {
        let view = DrawPathView()
        view.path = firstPath
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var secondPathView: DrawPathView = {
        let view = DrawPathView()
        view.path = secondPath
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(firstPathView)
        view.addSubview(secondPathView)
        
        NSLayoutConstraint.activate([
            firstPathView.topAnchor.constraint(equalTo: view.topAnchor),
            firstPathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            firstPathView.rightAnchor.constraint(equalTo: view.rightAnchor),
            firstPathView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            secondPathView.topAnchor.constraint(equalTo: view.topAnchor),
            secondPathView.leftAnchor.constraint(equalTo: view.leftAnchor),
            secondPathView.rightAnchor.constraint(equalTo: view.rightAnchor),
            secondPathView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}
