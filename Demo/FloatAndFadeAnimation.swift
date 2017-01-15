//
//  HeartAnimation.swift
//  Face Frenzy
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
    var faceAnalyzer:FaceAnalyzer?
    
    weak var view:UIView?
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
    
    @objc private func addImageAndAnimate() {
        guard let view = self.view else {
            stopAnimating()
            return
        }
        
        guard let faceAnalyzer = self.faceAnalyzer else { return }
        
        guard let image = UIImage(named: self.imageName) else {
            print("FloatAndFadeAnimation - cannot find image named: \(self.imageName)")
            stopAnimating()
            return
        }
        
        let animatedImageView = UIImageView(image: image)
        
        switch self.animationStartPoint {
        case .forehead:
            let forheadSize = Swift.abs(faceAnalyzer.outerEyeDistance());
            let randomX = faceAnalyzer.leftEyeLeftEdge().x + CGFloat(arc4random_uniform(UInt32(forheadSize)))
            
            animatedImageView.frame = CGRect(x: randomX,
                                             y: faceAnalyzer.eyeToEyeCenter().y - 150,
                                             width: image.size.width,
                                             height: image.size.height)
        case .leftNostral:
            let leftNostralCenter = faceAnalyzer.noseLeftNostral()
            animatedImageView.frame = CGRect(x: leftNostralCenter.x - (image.size.width / 2),
                                             y: leftNostralCenter.y - (image.size.height / 2),
                                             width: image.size.width,
                                             height: image.size.height)
            break
        case .rightNostral:
            let rightNostralCenter = faceAnalyzer.noseRightNostral()
            animatedImageView.frame = CGRect(x: rightNostralCenter.x - (image.size.width / 2),
                                             y: rightNostralCenter.y - (image.size.width / 2),
                                             width: image.size.width,
                                             height: image.size.height)
            break
        default:
            print("Unsupported Float and Fade Animation Start Point!")
            return
        }
        
        animatedImageView.alpha = 1.0
        view.insertSubview(animatedImageView, at: 1000)
        
        UIView.animate(withDuration: 1.2, animations: {
            if case let .above(amount) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x, y: animatedImageView.center.y - amount)
            } else if case let .aboveLeft(amountUp, amountLeft) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x - amountLeft,
                                                   y: animatedImageView.center.y - amountUp)
            } else if case let .aboveRight(amountUp, amountRight) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x + amountRight,
                                                   y: animatedImageView.center.y - amountUp)
            } else if case let .below(amount) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x, y: animatedImageView.center.y + amount)
            } else if case let .belowLeft(amountDown, amountLeft) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x - amountLeft,
                                                   y: animatedImageView.center.y + amountDown)
            } else if case let .belowRight(amountDown, amountRight) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x + amountRight,
                                                   y: animatedImageView.center.y + amountDown)
            } else if case let .toLeft(amount) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x - amount, y: animatedImageView.center.y)
            } else if case let .toRight(amount) = self.animationEndPoint {
                animatedImageView.center = CGPoint(x: animatedImageView.center.x + amount, y: animatedImageView.center.y)
            }
            
            animatedImageView.alpha = 0.0
        }) { (complete) in
            if complete {
                animatedImageView.removeFromSuperview()
            }
        }
    }
    
    // MARK: <Animatable>
    
    func startAnimating(in view: UIView) {
        if !self.isAnimating {
            self.isAnimating = true
            self.view = view
            self.animatedHeartsTimer = Timer.scheduledTimer(timeInterval: self.frequency,
                                                            target: self,
                                                            selector: #selector(self.addImageAndAnimate),
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
