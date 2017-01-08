//
//  HeartAnimation.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class HeartAnimation: Animatable {
    
    // MARK: Properties
    
    let id: String = UUID().uuidString
    var isAnimating: Bool = false
    
    weak var view:UIView?
    var faceAnalyzer:FaceAnalyzer?
    var animatedHeartsTimer:Timer?
    
    // MARK: init
    
    // MARK: Public
    
    // MARK: Private
    
    @objc private func addRandomHeartAndAnimate() {
        guard let view = self.view, let faceAnalyzer = self.faceAnalyzer else {
            stopAnimating()
            return
        }
    
        let forheadSize = Swift.abs(faceAnalyzer.outerEyeDistance());
        let randomX = (view.frame.size.width / 2) - (forheadSize / 2) + CGFloat(arc4random_uniform(UInt32(forheadSize)))
        
        let heartImageView = UIImageView()
        heartImageView.image = UIImage(named: "heart")
        heartImageView.frame = CGRect(x: randomX,
                                      y: faceAnalyzer.eyeToEyeCenter().y - 150,
                                      width: heartImageView.image?.size.width ?? 50,
                                      height: heartImageView.image?.size.height ?? 50)
        heartImageView.alpha = 1.0
        
        //self.animatedHearts.append(heartImageView)
        //view.insertSubview(heartImageView, aboveSubview: faceTrackerContainerView)
        view.insertSubview(heartImageView, at: 1000)
        
        UIView.animate(withDuration: 1.2, animations: {
            heartImageView.center = CGPoint(x: heartImageView.center.x, y: heartImageView.center.y - 50)
            heartImageView.alpha = 0.0
        }) { (complete) in // [unowned self]
            if complete {
                heartImageView.removeFromSuperview()
                // TODO: Probably more efficient to recycle these
                //self.animatedHearts.remove(at: self.animatedHearts.index(of: heartImageView)!)
            }
        }
    }
    
    // MARK: <Animatable>
    
    func startAnimating(in view: UIView, usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        if !self.isAnimating {
            self.isAnimating = true
            self.view = view
            self.faceAnalyzer = faceAnalyzer
            self.animatedHeartsTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                            target: self,
                                                            selector: #selector(self.addRandomHeartAndAnimate),
                                                            userInfo: nil,
                                                            repeats: true);
        }
    }
    
    func update(faceAnalyzer: FaceAnalyzer) {
        self.faceAnalyzer = faceAnalyzer
    }
    
    func stopAnimating() {
        self.animatedHeartsTimer?.invalidate()
        self.animatedHeartsTimer = nil
        self.view = nil
        self.isAnimating = false
    }
    
}
