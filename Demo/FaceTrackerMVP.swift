//
//  FaceTrackerMVP.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import FaceTracker

protocol FaceTrackerViewOps: NSObjectProtocol {
    
    func positionFacePoints(_ points:FacePoints)
    func repositionHatView(usingAnalyzer faceAnalyzer:FaceAnalyzer)
    
    func hideFacePoints()
    func hideHatView()
    
}

protocol FaceTrackerViewPresenterOps {
    
    func viewDidLoad(withView view:FaceTrackerViewOps)
    
    func didReceiveFacePoints(_ points:FacePoints?)
    
}

protocol FaceTrackerModelPresenterOps {
    
}

protocol FaceTrackerModelOps {
    
}
