//
//  FacePointAnalyzer.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import FaceTracker

class FacePointAnalyzer: FaceAnalyzer {
    // MARK: Properties
    
    private var points:FacePoints!
    
    var leftEyeStart:CGPoint {
        return points.leftEye[0]
    }
    
    var leftEyeEnd:CGPoint {
        return points.leftEye[5]
    }
    
    var rightEyeStart:CGPoint {
        return points.rightEye[0]
    }
    
    var rightEyeEnd:CGPoint {
        return points.rightEye[5]
    }
    
    private var _outterEyeDistance:CGFloat? = nil
    private var _eyeToEyeCenter:CGPoint? = nil
    private var _leftToRightEyeAngle:CGFloat? = nil
    
    // MARK: init
    
    init() { }
    
    // MARK: Public
    
    func isReady() -> Bool {
        return self.points != nil
    }
    
    // Make this updatable as the number of allocations would happen too often if it was an immutable object
    // TODO: This doesn't make sense. This should be done using the thunk and associatedtype explained in FaceAnalyzer class comments no time to implement at this point as it's not an assignment requirement
    func updatePoints<T>(_ points:T) {
        self.points = points as! FacePoints
        _eyeToEyeCenter = nil
        _outterEyeDistance = nil
        _leftToRightEyeAngle = nil
    }
    
    func outterEyeDistance() -> CGFloat {
        if _outterEyeDistance == nil {
            _outterEyeDistance = leftEyeStart.distanceTo(point: rightEyeEnd)
        }
        return _outterEyeDistance!
    }
    
    func eyeToEyeCenter() -> CGPoint {
        if _eyeToEyeCenter == nil {
            _eyeToEyeCenter = leftEyeStart.centerTo(point: rightEyeEnd)
        }
        return _eyeToEyeCenter!
    }
    
    func leftToRightEyeAngle() -> CGFloat {
        if _leftToRightEyeAngle == nil {
            _leftToRightEyeAngle = leftEyeStart.angleTo(point: rightEyeEnd)
        }
        return _leftToRightEyeAngle!
    }
    
    // MARK: Private
    
    // MAKR: <ProtocolName>
    
}
