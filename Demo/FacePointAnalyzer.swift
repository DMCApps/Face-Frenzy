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
    
    var noseStart:CGPoint {
        return points.nose[0]
    }
    
    var noseEnd:CGPoint {
        return points.nose[6]
    }
    
    var outterMouthStart:CGPoint {
        return points.outerMouth[0]
    }
    
    var outterMouthEnd:CGPoint {
        return points.outerMouth[5]
    }
    
    var innerMouthStart:CGPoint {
        return points.innerMouth[0]
    }
    
    var innerMouthEnd:CGPoint {
        return points.innerMouth[5]
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
    
    private var _noseWidth:CGFloat? = nil
    private var _noseCenter:CGPoint? = nil
    private var _noseAngle:CGFloat? = nil
    
    private var _outterMouthWidth:CGFloat? = nil
    private var _outterMouthCenter:CGPoint? = nil
    private var _outterMouthAngle:CGFloat? = nil
    
    private var _innerMouthWidth:CGFloat? = nil
    private var _innerMouthCenter:CGPoint? = nil
    private var _innerMouthAngle:CGFloat? = nil
    
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
        
        _leftEyeWidth = nil
        _leftEyeCenter = nil
        _leftEyeAngle = nil
        _rightEyeWidth = nil
        _rightEyeCenter = nil
        _rightEyeAngle = nil
        
        _eyeToEyeCenter = nil
        _outterEyeDistance = nil
        _leftToRightEyeAngle = nil
        
        _noseWidth = nil
        _noseCenter = nil
        _noseAngle = nil
        
        _outterMouthWidth = nil
        _outterMouthCenter = nil
        _outterMouthAngle = nil
        
        _innerMouthWidth = nil
        _innerMouthCenter = nil
        _innerMouthAngle = nil
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
    
    func noseWidth() -> CGFloat {
        if _noseWidth == nil {
            _noseWidth = noseStart.distanceTo(point: noseEnd)
        }
        return _noseWidth!
    }
    
    func noseCenter() -> CGPoint {
        if _noseCenter == nil {
            _noseCenter = noseStart.centerTo(point: noseEnd)
        }
        return _noseCenter!
    }
    
    func noseAngle() -> CGFloat {
        if _noseAngle == nil {
            _noseAngle = noseStart.angleTo(point: noseEnd)
        }
        return _noseAngle!
    }
    
    func innerMouthWidth() -> CGFloat {
        if _innerMouthWidth == nil {
            _innerMouthWidth = innerMouthStart.distanceTo(point: innerMouthEnd)
        }
        return _innerMouthWidth!
    }
    
    func innerMouthCenter() -> CGPoint {
        if _innerMouthCenter == nil {
            _innerMouthCenter = innerMouthStart.centerTo(point: innerMouthEnd)
        }
        return _innerMouthCenter!
    }
    
    func innerMouthAngle() -> CGFloat {
        if _innerMouthAngle == nil {
            _innerMouthAngle = innerMouthStart.angleTo(point: innerMouthEnd)
        }
        return _innerMouthAngle!
    }
    
    func outterMouthWidth() -> CGFloat {
        if _outterMouthWidth == nil {
            _outterMouthWidth = outterMouthStart.distanceTo(point: outterMouthEnd)
        }
        return _outterMouthWidth!
    }
    
    func outterMouthCenter() -> CGPoint {
        if _outterMouthCenter == nil {
            _outterMouthCenter = outterMouthStart.centerTo(point: outterMouthEnd)
        }
        return _outterMouthCenter!
    }
    
    func outterMouthAngle() -> CGFloat {
        if _outterMouthAngle == nil {
            _outterMouthAngle = outterMouthStart.angleTo(point: outterMouthEnd)
        }
        return _outterMouthAngle!
    }
    
    // MARK: Private
    
    // MAKR: <ProtocolName>
    
}
