//
//  FaceItemsProvider.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FaceItemProvider {
    
    static let items = [
        FaceItem(position: .head,
                 anchorPosition: .above,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "hat",
                 centerOffset: CGPoint(x:0, y:-75),
                 widthMultiplier: 2.0),
        
        FaceItem(position: .head,
                 anchorPosition: .above,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "horns",
                 centerOffset: CGPoint(x:0, y:-75),
                 widthMultiplier: 2.0),
        
        FaceItem(position: .head,
                 anchorPosition: .above,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "light",
                 centerOffset: CGPoint(x:0, y:-75),
                 widthMultiplier: 2.0),
        
        FaceItem(position: .eyes,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "heart",
                 widthAdjustment:20.0),
        
        FaceItem(position: .nose,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "dog_nose",
                 widthAdjustment:20.0),
        
        FaceItem(position: .nose,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "pig_nose",
                 widthAdjustment:20.0),
        
        FaceItem(position: .centerMouth,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "lips",
                 widthAdjustment:20.0),
        
        FaceItem(position: .centerMouth,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "dog_tongue",
                 centerOffset: CGPoint(x: 0, y: 40)),
        
        FaceItem(position: .upperLip,
                 anchorPoint: CGPoint(x:0.5, y:1),
                 imageName: "mustache",
                 //centerOffset: CGPoint(x:0, y:-10),
                 widthAdjustment:60.0)
        
    ]
    
    
    
}
