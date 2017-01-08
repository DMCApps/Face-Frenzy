//
//  FaceItemFactory.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-08.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FaceItemFactory {
    
    static func build(forFacePosition position:FacePosition, imageName:String) -> FaceItem {
        switch position {
        case .head:
            return FaceItem(position: .head,
                            anchorPosition: .above,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            centerOffset: CGPoint(x:0, y:-75),
                            widthMultiplier: 2.0)
        case .eyes:
            return FaceItem(position: .eyes,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        case .leftEye:
            return FaceItem(position: .leftEye,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        case .rightEye:
            return FaceItem(position: .rightEye,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        case .nose:
            return FaceItem(position: .nose,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        case .upperLip:
            return FaceItem(position: .upperLip,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:60.0)
        case .centerMouth:
            return FaceItem(position: .centerMouth,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        case .centerMouthImageTop:
            return FaceItem(position: .centerMouth,
                            anchorPosition: .below,
                            anchorPoint: CGPoint(x:0.5, y:1),
                            imageName: imageName,
                            widthAdjustment:20.0)
        }
    }
    
}
