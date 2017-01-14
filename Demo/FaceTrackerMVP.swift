//
//  FaceTrackerMVP.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import FaceTracker

protocol FaceTrackerViewOps: NSObjectProtocol {
    
    func stopLoadingAnimation()
    
    func positionFaceAnalyzerPoints(_ points:FaceAnalyzerPoints)
    
    func runAnimations(_ animations:[Animatable]?)
    func stopAnimations(_ animations:[Animatable]?)
    
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
    
    func prepareViewForImageCapture()
    func captureCurrentImage()
    func revertViewFromImageCapture()
    func showFailedImageCapture()
    func playCameraSound()
    func showCameraFlash()
    
    func didBeginTranslation()
    func didTranslateBy(_ translation:CGFloat)
    func didEndTranslation()
    
}

protocol FaceTrackerViewPresenterOps: ActionsDelegate {
    
    func viewDidLoad(withView view:FaceTrackerViewOps)
    
    func didReceiveFaceAnalyzerPoints(_ points:FaceAnalyzerPoints?)
    
    func faceTrackerDidFinishLoading()
    
    func didClickTakePicture()
    func didSuccessfullyTakeImage()
    func didFailTakeImage()
    
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
    var activeAnimations:[Animatable] { get set }
    
}
