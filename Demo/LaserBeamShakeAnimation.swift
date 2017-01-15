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
    
    var beamSize:CGSize = CGSize(width: 0, height: 0)
    
    var animationTimer:Timer?
    
    // MARK: init
    
    init(startPoint:AnimationStartPoint, condition:((FaceAnalyzer) -> Bool)? = nil) {
        self.startPoint = startPoint
        self.condition = condition
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
            self.laserImageView?.removeFromSuperview()
            self.laserImageView = nil
            return
        }
        
        if self.laserImageView == nil {
            let beamImage = UIImage(named:"laser_beam")!
            self.beamSize = beamImage.size
            self.laserImageView = UIImageView()
            self.laserImageView?.translatesAutoresizingMaskIntoConstraints = false
            self.laserImageView!.image = beamImage
            self.laserImageView!.contentMode = .scaleAspectFit
            view.insertSubview(self.laserImageView!, at: 9999)
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
        
        guard let laserImageView = self.laserImageView else { return }
        laserImageView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5);
        laserImageView.frame = CGRect(x: center.x - 20,
                                      y: center.y - (self.beamSize.height / 2),
                                      width: self.beamSize.width,
                                      height: self.beamSize.height)
        laserImageView.bounds = CGRect(x: 0,
                                       y: 0,
                                       width: self.beamSize.width,
                                       height: self.beamSize.height)
        
        laserImageView.transform = CGAffineTransform.identity
        laserImageView.transform = CGAffineTransform(rotationAngle: angle)
        
        let xTranslation = 5 - CGFloat(arc4random_uniform(UInt32(10)))
        let yTranslation = 5 - CGFloat(arc4random_uniform(UInt32(10)))
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.fromValue = CGPoint(x: laserImageView.center.x - xTranslation,
                                  y: laserImageView.center.y - yTranslation)
        shake.toValue = CGPoint(x: laserImageView.center.x + xTranslation,
                                y: laserImageView.center.y + yTranslation)
        laserImageView.layer.add(shake, forKey: "position")
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
