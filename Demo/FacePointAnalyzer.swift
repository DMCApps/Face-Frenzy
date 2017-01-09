//
//  FacePointAnalyzer.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-31.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import FaceTracker

extension FacePoints: FaceAnalyzerPoints {}

class FacePointAnalyzer: FaceAnalyzer {
    // MARK: Properties
    
    private var points:FaceAnalyzerPoints!
    
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
    
    var noseBottomLeft:CGPoint {
        return points.nose[1]
    }
    
    var noseLeftNostralPoint:CGPoint {
        return points.nose[2]
    }
    
    var noseBottomCenter:CGPoint {
        return points.nose[3]
    }
    
    var noseRightNostralPoint:CGPoint {
        return points.nose[4]
    }
    
    var noseBottomRight:CGPoint {
        return points.nose[5]
    }
    
    var outerMouthStart:CGPoint {
        return points.outerMouth[0]
    }
    
    var outerMouthTopLeft:CGPoint {
        return points.outerMouth[2]
    }
    
    var outerMouthTopRight:CGPoint {
        return points.outerMouth[4]
    }
    
    var outerMouthEnd:CGPoint {
        return points.outerMouth[6]
    }
    
    var innerMouthStart:CGPoint {
        return points.innerMouth[0]
    }
    
    var innerMouthEnd:CGPoint {
        return points.innerMouth[4]
    }
    
    private var _leftEyeWidth:CGFloat? = nil
    private var _leftEyeCenter:CGPoint? = nil
    private var _leftEyeAngle:CGFloat? = nil
    private var _rightEyeWidth:CGFloat? = nil
    private var _rightEyeCenter:CGPoint? = nil
    private var _rightEyeAngle:CGFloat? = nil
    
    private var _outerEyeDistance:CGFloat? = nil
    private var _eyeToEyeCenter:CGPoint? = nil
    private var _leftToRightEyeAngle:CGFloat? = nil
    
    private var _noseWidth:CGFloat? = nil
    private var _noseCenter:CGPoint? = nil
    private var _noseAngle:CGFloat? = nil
    
    private var _bottomNoseCenter:CGPoint? = nil
    
    private var _outerMouthWidth:CGFloat? = nil
    private var _outerMouthCenter:CGPoint? = nil
    private var _outerMouthAngle:CGFloat? = nil
    
    private var _innerMouthWidth:CGFloat? = nil
    private var _innerMouthCenter:CGPoint? = nil
    private var _innerMouthAngle:CGFloat? = nil
    
    private var _topLipCenter:CGPoint? = nil
    private var _betweenMouthAndNoseCenter:CGPoint? = nil
    
    // MARK: init
    
    init() { }
    
    // MARK: Public
    
    func isReady() -> Bool {
        return self.points != nil
    }
    
    // Make this updatable as the number of allocations would happen too often if it was an immutable object
    func updatePoints(_ points:FaceAnalyzerPoints) {
        self.points = points as! FacePoints
        
        _leftEyeWidth = nil
        _leftEyeCenter = nil
        _leftEyeAngle = nil
        _rightEyeWidth = nil
        _rightEyeCenter = nil
        _rightEyeAngle = nil
        
        _eyeToEyeCenter = nil
        _outerEyeDistance = nil
        _leftToRightEyeAngle = nil
        
        _noseWidth = nil
        _noseCenter = nil
        _noseAngle = nil
        
        _bottomNoseCenter = nil
        
        _outerMouthWidth = nil
        _outerMouthCenter = nil
        _outerMouthAngle = nil
        
        _innerMouthWidth = nil
        _innerMouthCenter = nil
        _innerMouthAngle = nil
        
        _topLipCenter = nil
        _betweenMouthAndNoseCenter = nil
    }
    
    func leftEyeLeftEdge() -> CGPoint {
        return leftEyeStart
    }
    
    func rightEyeRightEdge() -> CGPoint {
        return rightEyeEnd
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
    
    func outerEyeDistance() -> CGFloat {
        if _outerEyeDistance == nil {
            _outerEyeDistance = leftEyeStart.distanceTo(point: rightEyeEnd)
        }
        return _outerEyeDistance!
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
    
    func noseLeftNostral() -> CGPoint {
        return noseLeftNostralPoint
    }
    
    func noseRightNostral() -> CGPoint {
        return noseRightNostralPoint
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
    
    func outerMouthWidth() -> CGFloat {
        if _outerMouthWidth == nil {
            _outerMouthWidth = outerMouthStart.distanceTo(point: outerMouthEnd)
        }
        return _outerMouthWidth!
    }
    
    func outerMouthCenter() -> CGPoint {
        if _outerMouthCenter == nil {
            _outerMouthCenter = outerMouthStart.centerTo(point: outerMouthEnd)
        }
        return _outerMouthCenter!
    }
    
    func outerMouthAngle() -> CGFloat {
        if _outerMouthAngle == nil {
            _outerMouthAngle = outerMouthStart.angleTo(point: outerMouthEnd)
        }
        return _outerMouthAngle!
    }
    
    func topLipCenter() -> CGPoint {
        if _topLipCenter == nil {
            _topLipCenter = outerMouthTopLeft.centerTo(point: outerMouthTopRight)
        }
        return _topLipCenter!
    }
    
    func betweenMouthAndNoseCenter() -> CGPoint {
        if _betweenMouthAndNoseCenter == nil {
            let topLipCenter = self.topLipCenter()
            _betweenMouthAndNoseCenter = topLipCenter.centerTo(point: self.noseBottomCenter)
        }
        return _betweenMouthAndNoseCenter!
    }
    
    // MARK: Private
    
    // MAKR: <ProtocolName>
    
}
