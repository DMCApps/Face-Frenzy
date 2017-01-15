//
//  FaceItemsProvider.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FaceItemProvider {
    
    static let items = [
        FaceItemFactory.build(forFacePosition: .none,
                              imageName: "laser_beam",
                              animations: [
                                LaserBeamShake(startPoint: .leftEye) { $0.isLeftEyeWideOpen() },
                                LaserBeamShake(startPoint: .rightEye) { $0.isRightEyeWideOpen() },
                                LaserBeamShake(startPoint: .mouth) { $0.isMouthOpen() }
            ]),         
        FaceItemFactory.build(forFacePosition: .head, imageName: "hat"),
        FaceItemFactory.build(forFacePosition: .head,
                              imageName: "horns",
                              animations:[FloatAndFadeAnimation(imageName: "smoke",
                                                                frequency:1.0,
                                                                animationStartPoint: .leftNostral,
                                                                animationEndPoint: .belowLeft(100, 50)),
                                          FloatAndFadeAnimation(imageName: "smoke",
                                                                frequency:1.0,
                                                                animationStartPoint: .rightNostral,
                                                                animationEndPoint: .belowRight(100, 50))]),
        FaceItemFactory.build(forFacePosition: .head, imageName: "light"),
        FaceItemFactory.build(forFacePosition: .eyes,
                              imageName: "heart",
                              animations:[FloatAndFadeAnimation(imageName:"heart",
                                                                frequency:0.2,
                                                                animationStartPoint:.forehead,
                                                                animationEndPoint:.above(100))]),
        FaceItemFactory.build(forFacePosition: .eyes,
                              imageName: "star",
                              animations:[FloatAndFadeAnimation(imageName:"star",
                                                                frequency:0.2,
                                                                animationStartPoint:.forehead,
                                                                animationEndPoint:.above(100))]),
        
        FaceItemFactory.build(forFacePosition: .nose, imageName: "dog_nose"),
        FaceItemFactory.build(forFacePosition: .nose, imageName: "pig_nose"),
        FaceItemFactory.build(forFacePosition: .centerMouth, imageName: "lips"),
        FaceItemFactory.build(forFacePosition: .centerMouthImageTop, imageName: "dog_tongue"),
        FaceItemFactory.build(forFacePosition: .upperLip, imageName: "mustache")        
    ]
    
    
    
}
