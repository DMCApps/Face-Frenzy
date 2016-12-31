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
    
    // MARK: init
    
    init() { }
    
    // MARK: Public
    
    // Make this updatable as the number of allocations would happen too often if it was an immutable object
    // TODO: This doesn't make sense. This should be done using the thunk and associated type explained in FaceAnalyzer class
    func updatePoints<T>(_ points:T) {
        self.points = points as! FacePoints
        _eyeToEyeCenter = nil
        _outterEyeDistance = nil
    }
    
    func outterEyeDistance() -> CGFloat {
        if _outterEyeDistance == nil {
            _outterEyeDistance = self.leftEyeStart.distanceTo(point: self.rightEyeEnd)
        }
        return _outterEyeDistance!
    }
    
    func eyeToEyeCenter() -> CGPoint {
        if _eyeToEyeCenter == nil {
            _eyeToEyeCenter = self.leftEyeStart.centerTo(point: self.rightEyeEnd)
        }
        return _eyeToEyeCenter!
    }
    
    // MARK: Private
    
    // MAKR: <ProtocolName>
    
}
