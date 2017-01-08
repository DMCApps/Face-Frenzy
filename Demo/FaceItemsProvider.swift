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
        FaceItemFactory.build(forFacePosition: .head, imageName: "hat"),
        FaceItemFactory.build(forFacePosition: .head, imageName: "horns"),
        FaceItemFactory.build(forFacePosition: .head, imageName: "light"),
        FaceItemFactory.build(forFacePosition: .eyes, imageName: "heart"),
        FaceItemFactory.build(forFacePosition: .eyes, imageName: "star"),
        FaceItemFactory.build(forFacePosition: .nose, imageName: "dog_nose"),
        FaceItemFactory.build(forFacePosition: .nose, imageName: "pig_nose"),
        FaceItemFactory.build(forFacePosition: .centerMouth, imageName: "lips"),
        FaceItemFactory.build(forFacePosition: .centerMouthImageTop, imageName: "dog_tongue"),
        FaceItemFactory.build(forFacePosition: .upperLip, imageName: "mustache")        
    ]
    
    
    
}
