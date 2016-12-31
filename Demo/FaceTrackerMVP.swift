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
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer)
    
    func showHeadViewWithFaceItem(_ faceItem:FaceItem)
    
    func showFacePoints()
    func hideFacePoints()
    func showHeadView()
    func hideHeadView()
    
    func openActionsMenu()
    func closeActionsMenu()
    
    func didBeginTranslation()
    func didTranslateBy(_ translation:CGFloat)
    func didEndTranslation()
    
}

protocol FaceTrackerViewPresenterOps: ActionsDelegate {
    
    func viewDidLoad(withView view:FaceTrackerViewOps)
    
    func didReceiveFacePoints(_ points:FacePoints?)
    
}

protocol FaceTrackerModelPresenterOps {
    
}

protocol FaceTrackerModelOps {
    
    func setFacePointsShown(_ shown:Bool)
    func areFacePointsShown() -> Bool
    
}
