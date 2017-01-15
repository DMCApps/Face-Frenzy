//
//  LazerBeamShakeAnimation.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-15.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class LaserBeamShake: Animatable {
    
    // MARK: Properties
    
    var id: String = UUID().uuidString
    var isAnimating:Bool = false
    var faceAnalyzer:FaceAnalyzer? = nil
    
    weak var view:UIView? = nil
    var laserImageView:UIImageView? = nil
    let startPoint:AnimationStartPoint
    let condition:((FaceAnalyzer) -> Bool)?
    
    var animationTimer:Timer?
    
    // MARK: init
    
    init(startPoint:AnimationStartPoint, condition:((FaceAnalyzer) -> Bool)? = nil) {
        self.startPoint = startPoint
    }
    
    // MARK: Public
    
    // MARK: Private
    
    @objc func placeView() {
        // Views gone stop animation
        guard let view = self.view else {
            stopAnimating()
            return
        }
        
        guard let faceAnalyzer = self.faceAnalyzer else { return }
        
        if condition != nil && !self.condition!(faceAnalyzer) {
            laserImageView?.removeFromSuperview()
            laserImageView = nil
            return
        }
        
        var center = CGPoint.zero
        var angle = CGFloat(0)
        switch self.startPoint {
        case .leftEye:
            center = faceAnalyzer.leftEyeCenter()
            angle = faceAnalyzer.leftEyeAngle()
            break
        case .rightEye:
            center = faceAnalyzer.rightEyeCenter()
            angle = faceAnalyzer.rightEyeAngle()
            break
        case .mouth:
            center = faceAnalyzer.innerMouthCenter()
            angle = faceAnalyzer.innerMouthAngle()
            break
        default:
            print("Unsupported Float and Fade Animation Start Point!")
            return
        }
        
        let beamImage = UIImage(named:"laser_beam")!
        let beamHeight:CGFloat = beamImage.size.height
        let beamWidth:CGFloat = beamImage.size.width
        if self.laserImageView == nil {
            self.laserImageView = UIImageView()
            self.laserImageView!.image = beamImage
            self.laserImageView!.contentMode = .scaleAspectFit
            view.insertSubview(self.laserImageView!, at: 9999)
        }
        
        guard let laserImageView = self.laserImageView else { return }
        
        laserImageView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5);
        laserImageView.frame = CGRect(x: center.x - 20,
                                            y: center.y - (beamHeight / 2),
                                            width: beamWidth,
                                            height: beamHeight)
        laserImageView.transform = CGAffineTransform.identity
        laserImageView.transform = CGAffineTransform(rotationAngle: angle)
        
        let anim = CAKeyframeAnimation(keyPath:"transform")
        let xTranslation = CGFloat(arc4random_uniform(UInt32(10)))
        let yTranslation = CGFloat(arc4random_uniform(UInt32(10)))
        
        anim.values = [
            NSValue(caTransform3D:CATransform3DMakeTranslation(-xTranslation, -yTranslation, 0)),
            NSValue(caTransform3D:CATransform3DMakeTranslation(xTranslation, yTranslation, 0))
        ]
        anim.duration = 0.1
        
        laserImageView.layer.add(anim, forKey:nil)
    }
    
    // MARK: <Animatable>
    
    func startAnimating(in view: UIView) {
        if !self.isAnimating {
            self.isAnimating = true
            self.view = view
            self.animationTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                       target: self,
                                                       selector: #selector(self.placeView),
                                                       userInfo: nil,
                                                       repeats: true);
        }
    }
    
    func stopAnimating() {
        if let laserImageView = self.laserImageView {
            laserImageView.removeFromSuperview()
        }
        self.animationTimer?.invalidate()
        self.animationTimer = nil
        self.view = nil
        self.laserImageView = nil
        self.isAnimating = false
    }
    
}
