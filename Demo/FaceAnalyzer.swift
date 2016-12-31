//
//  FaceAnalyzer.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

// Using a protocol here means that if we change out the FaceTracker library later we don't have
// to change a lot of the code in the application
protocol FaceAnalyzer {
    var leftEyeStart:CGPoint { get }
    var leftEyeEnd:CGPoint { get }
    var rightEyeStart:CGPoint { get }
    var rightEyeEnd:CGPoint { get }
    
    func isReady() -> Bool
    
    func updatePoints<T>(_ points:T)
    func outterEyeDistance() -> CGFloat
    func eyeToEyeCenter() -> CGPoint
    func leftToRightEyeAngle() -> CGFloat
}

// Maybe change to associatedtype and Thunk:
// See: https://krakendev.io/blog/generic-protocols-and-their-shortcomings

//By making this class a generic class, we can define a type T that we forward to our dependency injected MythicalType.
//Since this class conforms to our MythicalType protocol, we can call MythicalType's functions regularly.

//class AnyFaceAnalyzer<T>: FaceAnalyzer {
//    //These variables are private, preventing others from assigning to them or calling them directly.
//    //Since each type is the exact same type as the functions in our MythicalType, we can assign a MythicalType instance's function signatures to these variables.
//    //By assigning a MythicalType instance's function signatures to these variables, we can effectively forward any calls made to AnyMythicalType's functions to the original Spaceship instance.
//    private let _updatePoints = ((T) -> ())
//    
//    //By creating only one required init, we ensure that we can only initialize this class one way.
//    required init<U: FaceAnalyzer>(_ analyzer: U) where U.PointType == T {
//        _updatePoints = analyzer.updatePoints
//    }
//    
//    //Because this forwarding class does conform to the MythicalType protocol, we can call the MythicalType functions directly on this class. This class, as you can see, will forward that message to the function signatures that we assigned at the time of initialization.
//    func updatePoints(_ points: Self.PointType) {
//        return _updatePoints(points)
//    }
//}
