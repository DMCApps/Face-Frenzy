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
        FaceItem(position: .head, anchorPoint: CGPoint(x:0.5, y:1), imageName: "hat"),
        FaceItem(position: .head, anchorPoint: CGPoint(x:0.5, y:1), imageName: "horns"),
        FaceItem(position: .head, anchorPoint: CGPoint(x:0.5, y:1), imageName: "light"),
        FaceItem(position: .eyes, anchorPoint: CGPoint(x:0.5, y:1), imageName: "heart"),
        FaceItem(position: .nose, anchorPoint: CGPoint(x:0.5, y:1), imageName: "dog_nose"),
        FaceItem(position: .nose, anchorPoint: CGPoint(x:0.5, y:1), imageName: "pig_nose"),
        FaceItem(position: .centerMouth, anchorPoint: CGPoint(x:0.5, y:1), imageName: "lips"),
        FaceItem(position: .upperLip, anchorPoint: CGPoint(x:0.5, y:1), imageName: "mustache", centerOffset: CGPoint(x:0, y:-20)),
        FaceItem(position: .centerMouth, anchorPoint: CGPoint(x:0.5, y:1), imageName: "dog_tongue", centerOffset: CGPoint(x: 0, y: 40))
    ]
    
    
    
}
