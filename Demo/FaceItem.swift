//
//  FaceItem.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

// Use of value types that are immutable
// https://developer.apple.com/videos/play/wwdc2015/414/

enum FacePosition {
    case head
    case eyes
    case nose
    case upperLip
    case centerMouth
}

enum AnchorPosition {
    case above
    case center
}

struct FaceItem: Equatable {
    let position:FacePosition
    let anchorPosition:AnchorPosition
    let anchorPoint:CGPoint
    let imageName:String
    let centerOffset:CGPoint
    let widthAdjustment:CGFloat
    let widthMultiplier:CGFloat
    
    init(position:FacePosition,
         anchorPosition:AnchorPosition = .center,
         anchorPoint:CGPoint,
         imageName:String,
         centerOffset:CGPoint = CGPoint.zero,
         widthAdjustment:CGFloat = 0.0,
         widthMultiplier:CGFloat = 1.0) {
        
        self.position = position
        self.anchorPosition = anchorPosition
        self.anchorPoint = anchorPoint
        self.imageName = imageName
        self.centerOffset = centerOffset
        self.widthAdjustment = widthAdjustment
        self.widthMultiplier = widthMultiplier
        
    }
}

func ==(lhs:FaceItem, rhs:FaceItem) -> Bool {
    return lhs.imageName == rhs.imageName
}

protocol FaceView {
    
    func adjustLayoutFor(faceItem:FaceItem, center:CGPoint, width:CGFloat, angle:CGFloat)
    
}

extension UIImageView: FaceView {
    
    func adjustLayoutFor(faceItem: FaceItem, center:CGPoint, width:CGFloat, angle:CGFloat) {
        let adjustedWidth = faceItem.widthMultiplier * width + faceItem.widthAdjustment
        let height = (self.image!.size.height / self.image!.size.width) * adjustedWidth
        
        self.transform = CGAffineTransform.identity
        
        let adjustedCenter = center + faceItem.centerOffset
        switch faceItem.anchorPosition {
        case .center:
            self.frame = CGRect(x: adjustedCenter.x - adjustedWidth / 2,
                                y: adjustedCenter.y - height / 2,
                                width: adjustedWidth,
                                height: height)
        case .above:
            self.frame = CGRect(x: adjustedCenter.x - adjustedWidth / 2,
                                y: adjustedCenter.y - height,
                                width: adjustedWidth,
                                height: height)
        }
        
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    
}
