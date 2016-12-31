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
    
    private var _leftEyeWidth:CGFloat? = nil
    private var _leftEyeCenter:CGPoint? = nil
    private var _leftEyeAngle:CGFloat? = nil
    private var _rightEyeWidth:CGFloat? = nil
    private var _rightEyeCenter:CGPoint? = nil
    private var _rightEyeAngle:CGFloat? = nil
    
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
        _leftEyeWidth = nil
        _leftEyeCenter = nil
        _leftEyeAngle = nil
        _rightEyeWidth = nil
        _rightEyeCenter = nil
        _rightEyeAngle = nil
    }
    
    func leftEyeWidth() -> CGFloat {
        if _leftEyeWidth == nil {
            _leftEyeWidth = leftEyeStart.distanceTo(point: leftEyeEnd)
        }
        return _leftEyeWidth!
    }
    
    func leftEyeCenter() -> CGPoint {
        if _leftEyeCenter == nil {
            _leftEyeCenter = leftEyeStart.centerTo(point: leftEyeEnd)
        }
        return _leftEyeCenter!
    }
    
    func leftEyeAngle() -> CGFloat {
        if _leftEyeAngle == nil {
            _leftEyeAngle = leftEyeStart.angleTo(point: rightEyeEnd)
        }
        return _leftEyeAngle!
    }
    
    func rightEyeWidth() -> CGFloat {
        if _rightEyeWidth == nil {
            _rightEyeWidth = rightEyeStart.distanceTo(point: rightEyeEnd)
        }
        return _rightEyeWidth!
    }
    
    func rightEyeCenter() -> CGPoint {
        if _rightEyeCenter == nil {
            _rightEyeCenter = rightEyeStart.centerTo(point: rightEyeEnd)
        }
        return _rightEyeCenter!
    }
    
    func rightEyeAngle() -> CGFloat {
        if _rightEyeAngle == nil {
            _rightEyeAngle = rightEyeStart.angleTo(point: rightEyeEnd)
        }
        return _rightEyeAngle!
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
