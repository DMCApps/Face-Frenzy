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
    
    func showHeadView()
    func hideHeadView()
    func showHeadViewWithFaceItem(_ faceItem:FaceItem)
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showEyesView()
    func hideEyesView()
    func showEyesViewWithFaceItem(_ faceItem:FaceItem)
    func repositionEyesView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showNoseView()
    func hideNoseView()
    func showNoseViewWithFaceItem(_ faceItem:FaceItem)
    func repositionNoseView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showLipView()
    func hideLipView()
    func showLipViewWithFaceItem(_ faceItem:FaceItem)
    func repositionLipView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showMouthView()
    func hideMouthView()
    func showMouthViewWithFaceItem(_ faceItem:FaceItem)
    func repositionMouthView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showFacePoints()
    func hideFacePoints()
    
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
    
    var areFacePointsShown:Bool { get set }
    var headFaceItem:FaceItem? { get set }
    var eyesFaceItem:FaceItem? { get set }
    var noseFaceItem:FaceItem? { get set }
    var lipFaceItem:FaceItem? { get set }
    var mouthFaceItem:FaceItem? { get set }
    
}
