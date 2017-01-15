//
//  FaceTrackerModel.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

class FaceTrackerModel: FaceTrackerModelOps {
    
    // MARK: Properties
    
    var didStartFaceTracker: Bool = false
    var areFacePointsShown:Bool = true
    var headFaceItem:FaceItem? = nil
    var leftEyeFaceItem:FaceItem? = nil
    var rightEyeFaceItem:FaceItem? = nil
    var noseFaceItem:FaceItem? = nil
    var lipFaceItem:FaceItem? = nil
    var mouthFaceItem:FaceItem? = nil
    var lastTranslationAmount: Double = 0
    var lastTranslationDirection: TranslationDirection = .unknown
    var activeAnimations = [Animatable]()
    
    private let presenter:FaceTrackerModelPresenterOps
    
    // MARK: init
    
    init(presenter:FaceTrackerModelPresenterOps) {
        self.presenter = presenter
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <FaceTrackerModelPresenterOps>
    
}
