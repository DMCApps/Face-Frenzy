//
//  FaceTrackerPresenter.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import FaceTracker

class FaceTrackerPresenter: FaceTrackerViewPresenterOps, FaceTrackerModelPresenterOps {
    
    weak private var view:FaceTrackerViewOps?
    private var model:FaceTrackerModelOps!
    
    // Mark: FaceTrackerViewPresenterOps
    
    func viewDidLoad(withView view:FaceTrackerViewOps) {
        self.view = view
        self.model = FaceTrackerModel(presenter: self)
    }
    
    // TODO: Should FacePoints be passed or just the raw values so that we don't have to import FaceTracker?
    func didReceiveFacePoints(_ points:FacePoints?) {
        if let points = points {
            self.view?.showFacePoints(points)
            self.view?.repositionHatViewForPoints(points)
        }
        else {
            self.view?.hideFacePoints()
            self.view?.hideHatView()
        }
    }
    
    // Mark: FaceTrackerModelPresenterOps
    
}
