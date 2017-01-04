//
//  FaceItem.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

enum FacePosition {
    case head
    case eyes
    case nose
    case upperLip
    case centerMouth
}

class FaceItem: Equatable {
    let position:FacePosition
    let anchorPoint:CGPoint
    let imageName:String
    let centerOffset:CGPoint
    
    init(position:FacePosition, anchorPoint:CGPoint, imageName:String, centerOffset:CGPoint = CGPoint.zero) {
        self.position = position
        self.anchorPoint = anchorPoint
        self.imageName = imageName
        self.centerOffset = centerOffset
    }
}

func ==(lhs:FaceItem, rhs:FaceItem) -> Bool {
    return lhs.imageName == rhs.imageName
}
