//
//  Animatable.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

// http://stackoverflow.com/questions/31921972/swift-protocol-implements-equatable
// Greate Explanation of Equatable use.
// I went with method 3 as I don't have a reaquirement for the Equatable and would like to be able to have a generic list of Animatable
protocol Animatable {
    
    var id: String { get }
    var isAnimating:Bool { get set }
    
    func startAnimating(in view: UIView, usingAnalyzer faceAnalyzer:FaceAnalyzer)
    func update(faceAnalyzer:FaceAnalyzer)
    func stopAnimating()
    
}

func ==(lhs:Animatable, rhs:Animatable) -> Bool {
    return lhs.id == rhs.id
}
