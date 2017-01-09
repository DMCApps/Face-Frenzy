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
    
    func stopLoadingAnimation()
    
    func positionFaceAnalyzerPoints(_ points:FaceAnalyzerPoints)
    
    // TODO: Likely just have a start and stop animation method that takes in an animation
    // Then have the animations accociated with the FaceItems and perform start and stop as items are added?
    func startAnimatingHearts(usingAnalyzer faceAnalyzer:FaceAnalyzer)
    func updateAnimatingHearts(faceAnalyzer:FaceAnalyzer)
    func stopAnimatingHearts()
    
    func startAnimatingStars(usingAnalyzer faceAnalyzer:FaceAnalyzer)
    func updateAnimatingStars(faceAnalyzer:FaceAnalyzer)
    func stopAnimatingStars()
    
    func startNoseSmokeAnimation(usingAnalyzer faceAnalyzer:FaceAnalyzer)
    func updateNoseSmokeAnimation(faceAnalyzer:FaceAnalyzer)
    func stopNoseSmokeAnimation()
    
    func showHeadView()
    func hideHeadView()
    func showHeadViewWithFaceItem(_ faceItem:FaceItem)
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showEyesView()
    func hideEyesView()
    func showEyesViewWithFaceItem(_ faceItem:FaceItem)
    func repositionEyesView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showLeftEyeView()
    func hideLeftEyeView()
    func showLeftEyeViewWithFaceItem(_ faceItem:FaceItem)
    func repositionLeftEyeView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
    func showRightEyeView()
    func hideRightEyeView()
    func showRightEyeViewWithFaceItem(_ faceItem:FaceItem)
    func repositionRightEyeView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem)
    
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
    
    func swapCamera()
    
    func didBeginTranslation()
    func didTranslateBy(_ translation:CGFloat)
    func didEndTranslation()
    
}

protocol FaceTrackerViewPresenterOps: ActionsDelegate {
    
    func viewDidLoad(withView view:FaceTrackerViewOps)
    
    func didReceiveFaceAnalyzerPoints(_ points:FaceAnalyzerPoints?)
    
    func faceTrackerDidFinishLoading()
    
}

protocol FaceTrackerModelPresenterOps {
    
}

enum TranslationDirection {
    case unknown
    case up
    case down
}

protocol FaceTrackerModelOps {
    
    var areFacePointsShown:Bool { get set }
    var headFaceItem:FaceItem? { get set }
    var leftEyeFaceItem:FaceItem? { get set }
    var rightEyeFaceItem:FaceItem? { get set }
    var noseFaceItem:FaceItem? { get set }
    var lipFaceItem:FaceItem? { get set }
    var mouthFaceItem:FaceItem? { get set }
    var lastTranslationAmount:Double { get set }
    var lastTranslationDirection:TranslationDirection { get set }
    
}
