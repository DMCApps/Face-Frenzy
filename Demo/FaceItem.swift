//
//  FaceItem.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

// Use of value types that are immutable
// https://developer.apple.com/videos/play/wwdc2015/414/

enum FacePosition {
    case none
    case head
    case eyes
    case leftEye
    case rightEye
    case nose
    case upperLip
    case centerMouth
    case centerMouthImageTop
}

enum AnchorPosition {
    case above
    case center
    case below
}

struct FaceItem: Equatable {
    
    // MARK: Properties
    let position:FacePosition
    let anchorPosition:AnchorPosition
    let anchorPoint:CGPoint
    let imageName:String
    let centerOffset:CGPoint
    let widthAdjustment:CGFloat
    let widthMultiplier:CGFloat
    let animations:[Animatable]?
    
    // MARK: init
    
    init(position:FacePosition,
         anchorPosition:AnchorPosition = .center,
         anchorPoint:CGPoint,
         imageName:String,
         centerOffset:CGPoint = CGPoint.zero,
         widthAdjustment:CGFloat = 0.0,
         widthMultiplier:CGFloat = 1.0,
         animations:[Animatable]? = nil) {
        
        self.position = position
        self.anchorPosition = anchorPosition
        self.anchorPoint = anchorPoint
        self.imageName = imageName
        self.centerOffset = centerOffset
        self.widthAdjustment = widthAdjustment
        self.widthMultiplier = widthMultiplier
        self.animations = animations
    }
    
    // MARK: Public
    
    func withPosition(_ facePosition:FacePosition) -> FaceItem {
        return FaceItem(position: facePosition,
                        anchorPosition: self.anchorPosition,
                        anchorPoint: self.anchorPoint,
                        imageName: self.imageName,
                        centerOffset: self.centerOffset,
                        widthAdjustment: self.widthAdjustment,
                        widthMultiplier: self.widthMultiplier)
    }
    
    func positionData(usingAnalyzer faceAnalyzer:FaceAnalyzer) -> (CGFloat, CGPoint, CGFloat) {
        var width:CGFloat = 0.0
        var center = CGPoint(x: 0, y: 0)
        var angle:CGFloat = 0.0
        
        switch self.position {
        case .head:
            width = faceAnalyzer.outerEyeDistance()
            center = faceAnalyzer.eyeToEyeCenter()
            angle = faceAnalyzer.leftToRightEyeAngle()
        case .eyes:
            print("Defaulting to left eye for eye position: .eyes")
            print("Please use the FaceItem.withPosition(FacePosition) to create a .leftEye and .rightEye value")
            
            width = faceAnalyzer.leftEyeWidth()
            center = faceAnalyzer.leftEyeCenter()
            angle = faceAnalyzer.leftEyeAngle()
        case .leftEye:
            width = faceAnalyzer.leftEyeWidth()
            center = faceAnalyzer.leftEyeCenter()
            angle = faceAnalyzer.leftEyeAngle()
        case .rightEye:
            width = faceAnalyzer.rightEyeWidth()
            center = faceAnalyzer.rightEyeCenter()
            angle = faceAnalyzer.rightEyeAngle()
        case .nose:
            width = faceAnalyzer.noseWidth()
            center = faceAnalyzer.noseCenter()
            angle = faceAnalyzer.noseAngle()
        case .upperLip:
            width = faceAnalyzer.outerMouthWidth()
            center = faceAnalyzer.betweenMouthAndNoseCenter()
            angle = faceAnalyzer.outerMouthAngle()
        case .centerMouth:
            width = faceAnalyzer.innerMouthWidth()
            center = faceAnalyzer.innerMouthCenter()
            angle = faceAnalyzer.innerMouthAngle()
        case .centerMouthImageTop:
            width = faceAnalyzer.innerMouthWidth()
            center = faceAnalyzer.innerMouthCenter()
            angle = faceAnalyzer.innerMouthAngle()
        case .none:
            return (0, CGPoint(x:0, y:0), 0)
        }
        
        width = self.widthMultiplier * width + self.widthAdjustment
        center = center + self.centerOffset
        
        return (width, center, angle)
    }
    
    // MARK: Private
    
    // MARK: <ProtocolName>
}

func ==(lhs:FaceItem, rhs:FaceItem) -> Bool {
    return lhs.imageName == rhs.imageName
}

protocol FaceView {
    
    func adjustLayoutFor(faceItem:FaceItem, usingAnalyzer faceAnalyzer:FaceAnalyzer)
    
}

extension UIImageView: FaceView {
    
    func adjustLayoutFor(faceItem: FaceItem, usingAnalyzer faceAnalyzer:FaceAnalyzer) {
        let (width, center, angle) = faceItem.positionData(usingAnalyzer: faceAnalyzer)
        let height = (self.image!.size.height / self.image!.size.width) * width
        
        self.transform = CGAffineTransform.identity
        
        switch faceItem.anchorPosition {
        case .center:
            self.frame = CGRect(x: center.x - width / 2,
                                y: center.y - height / 2,
                                width: width,
                                height: height)
        case .above:
            self.frame = CGRect(x: center.x - width / 2,
                                y: center.y - height,
                                width: width,
                                height: height)
        case .below:
            self.frame = CGRect(x: center.x - width / 2,
                                y: center.y,
                                width: width,
                                height: height)
        }
        
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    
}
