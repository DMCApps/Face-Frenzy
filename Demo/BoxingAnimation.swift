//
//  BoxingAnimation.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-15.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

enum PunchDirection: Int {
    case fromLeft = 0
    case fromRight = 1
}

class BoxingAnimation: Animatable {
    
    // MARK: Properties
    
    var id: String = UUID().uuidString
    var isAnimating:Bool = false
    var faceAnalyzer:FaceAnalyzer? = nil
    
    weak var view:UIView? = nil
    
    var boxingGloveImageView:UIImageView?
    var powImageView:UIImageView?
    var dazedStarsAnimation:Animatable?
    
    var animationStartTimer:Timer?
    
    // MARK: init
    
    // MARK: Public
    
    // MARK: Private
    
    @objc private func throwPunch() {
        guard let view = self.view else {
            stopAnimating()
            return
        }
        guard let faceAnalyzer = self.faceAnalyzer, faceAnalyzer.isReady() else { return }
        
        self.animationStartTimer?.invalidate()
        self.animationStartTimer = nil
        
        let random = arc4random_uniform(UInt32(2))
        let direction = PunchDirection(rawValue: Int(random))!
        
        var image:UIImage!
        self.boxingGloveImageView = UIImageView()
        view.insertSubview(self.boxingGloveImageView!, at: 9999)
        var endCenter:CGPoint = .zero
        
        switch direction {
        case .fromLeft:
            image = UIImage(named: "boxing_glove_left")!
            self.boxingGloveImageView?.frame = CGRect(x: -image.size.width,
                                                      y: faceAnalyzer.noseCenter().y,
                                                      width:image.size.width,
                                                      height: image.size.height)
            
            endCenter = CGPoint(x: faceAnalyzer.noseCenter().x - (image.size.width / 2),
                                y: faceAnalyzer.noseCenter().y)
        case .fromRight:
            image = UIImage(named: "boxing_glove_right")!
            self.boxingGloveImageView?.frame = CGRect(x: view.frame.size.width + image.size.width,
                                                      y: faceAnalyzer.noseCenter().y,
                                                      width:image.size.width,
                                                      height: image.size.height)
            
            endCenter = CGPoint(x: faceAnalyzer.noseCenter().x + (image.size.width / 2),
                                y: faceAnalyzer.noseCenter().y)
        }
        
        self.boxingGloveImageView?.image = image
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.boxingGloveImageView?.center = endCenter
        }) { [weak self] (complete) in
            guard let `self` = self else { return }
            
            self.boxingGloveImageView?.removeFromSuperview()
            
            if self.isAnimating {
                self.showPunchConnected()
            }
        }
    }
    
    private func showPunchConnected() {
        guard let view = self.view else {
            stopAnimating()
            return
        }
        guard let faceAnalyzer = self.faceAnalyzer, faceAnalyzer.isReady() else { return }
        
        let image = UIImage(named: "pow")!
        self.powImageView = UIImageView()
        view.insertSubview(self.powImageView!, at: 9999)
        self.powImageView?.image = image
        self.powImageView?.frame = CGRect(x: faceAnalyzer.noseCenter().x,
                                          y: faceAnalyzer.noseCenter().y,
                                          width: 0,
                                          height: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        
                        self.powImageView?.frame = CGRect(x: faceAnalyzer.noseCenter().x - (image.size.width / 2),
                                                          y: faceAnalyzer.noseCenter().y - (image.size.height / 2),
                                                          width: image.size.width,
                                                          height: image.size.height)
        }) { [weak self] (complete) in
            guard let `self` = self else { return }
            
            self.powImageView?.removeFromSuperview()
            
            if self.isAnimating {
                self.showDazedStars()
            }
        }
    }
    
    private func showDazedStars() {
        guard let view = self.view else {
            stopAnimating()
            return
        }
        guard let faceAnalyzer = self.faceAnalyzer, faceAnalyzer.isReady() else { return }
        
        self.dazedStarsAnimation = FloatAndFadeAnimation(imageName: "star",
                                                         frequency: 0.1,
                                                         animationStartPoint: .forehead,
                                                         animationEndPoint: .above(100))
        
        self.dazedStarsAnimation?.faceAnalyzer = self.faceAnalyzer
        self.dazedStarsAnimation?.startAnimating(in: view)
    }
    
    // MARK: <ProtocolName>
    
    // MARK: <Animatable>
    
    func startAnimating(in view: UIView) {
        if !self.isAnimating {
            self.isAnimating = true
            self.view = view
            self.animationStartTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                            target: self,
                                                            selector: #selector(self.throwPunch),
                                                            userInfo: nil,
                                                            repeats: true);
        }
    }
    
    func stopAnimating() {
        self.dazedStarsAnimation?.stopAnimating()
        self.dazedStarsAnimation = nil
        
        self.animationStartTimer?.invalidate()
        self.animationStartTimer = nil
        
        self.boxingGloveImageView?.removeFromSuperview()
        self.powImageView?.removeFromSuperview()
        
        self.view = nil
        self.isAnimating = false
    }
    
}
