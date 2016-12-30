//
//  CGPoint+Calculations.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func centerTo(point: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + point.x) / 2, y: (self.y + point.y) / 2)
    }
    
    func distanceTo(point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
    
    func angleTo(point: CGPoint) -> CGFloat {
        return atan2(point.y - self.y, point.x - self.x)
    }
}
