//
//  Animatable.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

enum AnimationStartPoint {
    case forehead
    case leftNostral
    case rightNostral
    case leftEye
    case rightEye
    case mouth
}

enum AnimationEndPoint {
    case above(CGFloat)
    case aboveLeft(CGFloat, CGFloat)
    case aboveRight(CGFloat, CGFloat)
    case below(CGFloat)
    case belowLeft(CGFloat, CGFloat)
    case belowRight(CGFloat, CGFloat)
    case toLeft(CGFloat)
    case toRight(CGFloat)
}

enum AnimationCondition {
    case openMouth
}

// http://stackoverflow.com/questions/31921972/swift-protocol-implements-equatable
// Greate Explanation of Equatable use.
// I went with method 3 as I don't have a reaquirement for the Equatable and would like to be able to have a generic list of Animatable
// Although it does suck to have lost out on the Equatable extensions for Arrays :(
protocol Animatable {
    
    var id: String { get }
    var isAnimating:Bool { get set }
    var faceAnalyzer:FaceAnalyzer? { get set }
    
    func startAnimating(in view: UIView)
    func stopAnimating()
    
}

func ==(lhs:Animatable, rhs:Animatable) -> Bool {
    return lhs.id == rhs.id
}
