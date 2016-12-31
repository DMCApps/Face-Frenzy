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

struct FaceItem {
    let position:FacePosition
    let anchorPoint:CGPoint
    let imageName:String
    
    init(position:FacePosition, anchorPoint:CGPoint, imageName:String) {
        self.position = position
        self.anchorPoint = anchorPoint
        self.imageName = imageName
    }
    
}
