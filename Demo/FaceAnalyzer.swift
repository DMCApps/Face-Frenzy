//
//  FaceAnalyzer.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

protocol FaceAnalyzerPoints {
    var leftEye: [CGPoint] { get set }
    var rightEye: [CGPoint] { get set }
    var leftBrow: [CGPoint] { get set }
    var rightBrow: [CGPoint] { get set }
    var nose: [CGPoint] { get set }
    var innerMouth: [CGPoint] { get set }
    var outerMouth: [CGPoint] { get set }
    
    func enumeratePoints(_ closure: (CGPoint, Int) -> Swift.Void)
    
    func getTotalNumberOFPoints() -> Int
}

// Using a protocol here means that if we change out the FaceTracker library later we don't have
// to change a lot of the code in the application
protocol FaceAnalyzer {
    func isReady() -> Bool
    
    func updatePoints(_ points:FaceAnalyzerPoints)
    
    func leftEyeLeftEdge() -> CGPoint
    func rightEyeRightEdge() -> CGPoint
    
    func leftEyeWidth() -> CGFloat
    func leftEyeCenter() -> CGPoint
    func leftEyeAngle() -> CGFloat
    func rightEyeWidth() -> CGFloat
    func rightEyeCenter() -> CGPoint
    func rightEyeAngle() -> CGFloat
    
    func outerEyeDistance() -> CGFloat
    func eyeToEyeCenter() -> CGPoint
    func leftToRightEyeAngle() -> CGFloat
    
    func noseWidth() -> CGFloat
    func noseCenter() -> CGPoint
    func noseAngle() -> CGFloat
    
    func innerMouthWidth() -> CGFloat
    func innerMouthCenter() -> CGPoint
    func innerMouthAngle() -> CGFloat
    
    func outerMouthWidth() -> CGFloat
    func outerMouthCenter() -> CGPoint
    func outerMouthAngle() -> CGFloat
    
    func betweenMouthAndNoseCenter() -> CGPoint
    
    func topLipCenter() -> CGPoint
}

// Used Extensions instead of the below but leaving the below in here for future reference
// Maybe change to associatedtype and Thunk:
// See: https://krakendev.io/blog/generic-protocols-and-their-shortcomings
