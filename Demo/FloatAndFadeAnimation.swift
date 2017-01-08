//
//  HeartAnimation.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FloatAndFadeAnimation: Animatable {
    
    // MARK: Properties
    
    let id: String = UUID().uuidString
    var isAnimating: Bool = false
    
    weak var view:UIView?
    var faceAnalyzer:FaceAnalyzer?
    var animatedHeartsTimer:Timer?
    
    var imageName:String
    private let frequency:TimeInterval
    private let animationStartPoint:AnimationStartPoint
    private let animationEndPoint:AnimationEndPoint
    
    // MARK: init
    
    init(imageName:String, frequency:TimeInterval, animationStartPoint:AnimationStartPoint, animationEndPoint:AnimationEndPoint) {
        self.imageName = imageName
        self.frequency = frequency
        self.animationStartPoint = animationStartPoint
        self.animationEndPoint = animationEndPoint
    }
    
    // MARK: Public
    
    // MARK: Private
    
    @objc private func addRandomHeartAndAnimate() {
        guard let view = self.view else {
            stopAnimating()
            return
        }
        
        guard let faceAnalyzer = self.faceAnalyzer else {
            return
        }
        
        guard let image = UIImage(named: self.imageName) else {
            print("FloatAndFadeAnimation - cannot find image named: \(self.imageName)")
            return
        }
        
        let animatedImageView = UIImageView(image: image)
        
        if self.animationStartPoint == .forehead {
            let forheadSize = Swift.abs(faceAnalyzer.outerEyeDistance());
            let randomX = faceAnalyzer.leftEyeLeftEdge().x + CGFloat(arc4random_uniform(UInt32(forheadSize)))
            
            animatedImageView.frame = CGRect(x: randomX,
                                             y: faceAnalyzer.eyeToEyeCenter().y - 150,
                                             width: image.size.width,
                                             height: image.size.height)
            animatedImageView.alpha = 1.0
        }
        
        view.insertSubview(animatedImageView, at: 1000)
        
        UIView.animate(withDuration: 1.2, animations: {
            if case let .above(value) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x, y: animatedImageView.center.y - value)
            }
            
            animatedImageView.alpha = 0.0
        }) { (complete) in
            if complete {
                animatedImageView.removeFromSuperview()
            }
        }
    }
    
    // MARK: <Animatable>
    
    func startAnimating(in view: UIView, usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        if !self.isAnimating {
            self.isAnimating = true
            self.view = view
            self.faceAnalyzer = faceAnalyzer
            self.animatedHeartsTimer = Timer.scheduledTimer(timeInterval: self.frequency,
                                                            target: self,
                                                            selector: #selector(self.addRandomHeartAndAnimate),
                                                            userInfo: nil,
                                                            repeats: true);
        }
    }
    
    func stopAnimating() {
        self.animatedHeartsTimer?.invalidate()
        self.animatedHeartsTimer = nil
        self.view = nil
        self.isAnimating = false
    }

}
