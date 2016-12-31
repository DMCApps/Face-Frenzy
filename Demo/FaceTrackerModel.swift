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
    
    private var _areFacePointsShown:Bool = true
    
    private let presenter:FaceTrackerModelPresenterOps
    
    // MARK: init
    
    init(presenter:FaceTrackerModelPresenterOps) {
        self.presenter = presenter
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <FaceTrackerModelPresenterOps>
    
    func setFacePointsShown(_ shown:Bool) {
        self._areFacePointsShown = shown
    }
    
    func areFacePointsShown() -> Bool {
        return self._areFacePointsShown
    }
    
}
