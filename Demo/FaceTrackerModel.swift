//
//  FaceTrackerModel.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

class FaceTrackerModel: FaceTrackerModelOps {
    
    // MARK: Properties
    
    var areFacePointsShown:Bool = true
    var headFaceItem:FaceItem? = nil
    var eyesFaceItem:FaceItem? = nil
    var noseFaceItem:FaceItem? = nil
    var lipFaceItem:FaceItem? = nil
    var mouthFaceItem:FaceItem? = nil
    var lastTranslationAmount: Double = 0
    var lastTranslationDirection: TranslationDirection = .unknown
    
    private let presenter:FaceTrackerModelPresenterOps
    
    // MARK: init
    
    init(presenter:FaceTrackerModelPresenterOps) {
        self.presenter = presenter
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <FaceTrackerModelPresenterOps>
    
}
