//
//  FaceTrackerPresenter.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
// TODO: I need this for CGFloat/CGPoint etc. is there a way to get rid of it?
import UIKit

class FaceTrackerPresenter: FaceTrackerViewPresenterOps, FaceTrackerModelPresenterOps {
    
    weak private var view:FaceTrackerViewOps?
    private var model:FaceTrackerModelOps!
    
    private let faceAnalyzer:FaceAnalyzer = FacePointAnalyzer()
    
    // MARK: Private
    
    func manageAnimations(for faceItem:FaceItem, previousFaceItem:FaceItem?) {
        if let previousFaceItem = previousFaceItem, let previousAnimations = previousFaceItem.animations {
            previousAnimations.forEach { animation in
                removeAnimation(animation)
            }
        }
        
        if let animations = faceItem.animations {
            for var animation in animations {
                if self.model.activeAnimations.contains(where: { $0 == animation }) {
                    removeAnimation(animation)
                } else {
                    animation.faceAnalyzer = self.faceAnalyzer
                    self.model.activeAnimations.append(animation)
                }
            }
        }
        
        self.view?.runAnimations(model.activeAnimations)
    }
    
    func removeAnimation(_ animation:Animatable) {
        animation.stopAnimating()
        if let index = (model.activeAnimations.index{ $0 == animation }) {
            model.activeAnimations.remove(at: index)
        }
    }
    
    func clearAllAnimations() {
        model.activeAnimations.forEach { animation in
            animation.stopAnimating()
        }
        
        model.activeAnimations.removeAll()
    }
    
    func clearHeadFaceItem() {
        self.model.headFaceItem = nil
        self.view?.hideHeadView()
    }
    
    func addHeadFaceItem(_ faceItem:FaceItem) {
        self.model.headFaceItem = faceItem
        self.view?.showHeadViewWithFaceItem(faceItem)
        self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearEyesFaceItem() {
        self.model.leftEyeFaceItem = nil
        self.model.rightEyeFaceItem = nil
        self.view?.hideEyesView()
    }
    
    func addEyesFaceItem(_ faceItem:FaceItem) {
        self.model.leftEyeFaceItem = faceItem
        self.model.rightEyeFaceItem = faceItem
        
        self.view?.showEyesViewWithFaceItem(faceItem)
        self.view?.repositionEyesView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearLeftEyeFaceItem() {
        self.model.leftEyeFaceItem = nil
        self.view?.hideLeftEyeView()
    }
    
    func addLeftEyeFaceItem(_ faceItem:FaceItem) {
        self.model.leftEyeFaceItem = faceItem
        
        self.view?.showLeftEyeViewWithFaceItem(faceItem)
        self.view?.repositionLeftEyeView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearRightEyeFaceItem() {
        self.model.rightEyeFaceItem = nil
        self.view?.hideRightEyeView()
    }
    
    func addRightEyeFaceItem(_ faceItem:FaceItem) {
        self.model.rightEyeFaceItem = faceItem
        
        self.view?.showRightEyeViewWithFaceItem(faceItem)
        self.view?.repositionRightEyeView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearNoseFaceItem() {
        self.model.noseFaceItem = nil
        self.view?.hideNoseView()
    }
    
    func addNoseFaceItem(_ faceItem:FaceItem) {
        self.model.noseFaceItem = faceItem
        self.view?.showNoseViewWithFaceItem(faceItem)
        self.view?.repositionNoseView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearLipFaceItem() {
        self.model.lipFaceItem = nil
        self.view?.hideLipView()
    }
    
    func addLipFaceItem(_ faceItem:FaceItem) {
        self.model.lipFaceItem = faceItem
        self.view?.showLipViewWithFaceItem(faceItem)
        self.view?.repositionLipView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }
    
    func clearMouthFaceItem() {
        self.model.mouthFaceItem = nil
        self.view?.hideMouthView()
    }
    
    func addMouthFaceItem(_ faceItem:FaceItem) {
        self.model.mouthFaceItem = faceItem
        self.view?.showMouthViewWithFaceItem(faceItem)
        self.view?.repositionMouthView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
    }

    // MARK: <ActionsDelegate>
    
    func openActionsMenu() {
        self.view?.openActionsMenu()
    }
    
    func closeActionsMenu() {
        self.view?.closeActionsMenu()
    }
    
    func showFacePoints() {
        self.view?.showFacePoints()
        self.model.areFacePointsShown = true
    }
    
    func hideFacePoints() {
        self.view?.hideFacePoints()
        self.model.areFacePointsShown = false
    }
    
    func didBeginTranslation() {
        self.view?.didBeginTranslation()
        
        self.model.lastTranslationDirection = .unknown
        self.model.lastTranslationAmount = 0
    }
    
    func didTranslateBy(_ translation: CGFloat) {
        self.view?.didTranslateBy(translation)
        
        self.model.lastTranslationDirection = (CGFloat(self.model.lastTranslationAmount) - translation) < 0 ? .up : .down
        self.model.lastTranslationAmount = Double(translation)
    }
    
    func didEndTranslation() {
        if self.model.lastTranslationDirection == .up {
            self.view?.openActionsMenu()
        }
        else if self.model.lastTranslationDirection == .down {
            self.view?.closeActionsMenu()
        }
        self.view?.didEndTranslation()
    }
    
    func didSelectFaceItem(_ faceItem: FaceItem) {
        var previousFaceItem:FaceItem?
        
        switch faceItem.position {
        case .head:
            if let currentFaceItem = self.model.headFaceItem, currentFaceItem == faceItem {
                clearHeadFaceItem()
            } else {
                previousFaceItem = self.model.headFaceItem
                addHeadFaceItem(faceItem)
            }
        case .eyes:
            if let currentFaceItem = self.model.leftEyeFaceItem, currentFaceItem == faceItem {
                clearEyesFaceItem()
            } else {
                previousFaceItem = self.model.leftEyeFaceItem
                addEyesFaceItem(faceItem)
            }
        case .leftEye:
            if let currentFaceItem = self.model.leftEyeFaceItem, currentFaceItem == faceItem {
                clearLeftEyeFaceItem()
            } else {
                previousFaceItem = self.model.leftEyeFaceItem
                addLeftEyeFaceItem(faceItem)
            }
        case .rightEye:
            if let currentFaceItem = self.model.rightEyeFaceItem, currentFaceItem == faceItem {
                clearRightEyeFaceItem()
            } else {
                previousFaceItem = self.model.rightEyeFaceItem
                addRightEyeFaceItem(faceItem)
            }
        case .nose:
            if let currentFaceItem = self.model.noseFaceItem, currentFaceItem == faceItem {
                clearNoseFaceItem()
            } else {
                previousFaceItem = self.model.noseFaceItem
                addNoseFaceItem(faceItem)
            }
        case .upperLip:
            if let currentFaceItem = self.model.lipFaceItem, currentFaceItem == faceItem {
                clearLipFaceItem()
            } else {
                previousFaceItem = self.model.lipFaceItem
                addLipFaceItem(faceItem)
            }
        case .centerMouth:
            if let currentFaceItem = self.model.mouthFaceItem, currentFaceItem == faceItem {
                clearMouthFaceItem()
            } else {
                previousFaceItem = self.model.mouthFaceItem
                addMouthFaceItem(faceItem)
            }
        case .centerMouthImageTop:
            if let currentFaceItem = self.model.mouthFaceItem, currentFaceItem == faceItem {
                clearMouthFaceItem()
            } else {
                previousFaceItem = self.model.mouthFaceItem
                addMouthFaceItem(faceItem)
            }
        case .none:
            break
        }
        
        manageAnimations(for: faceItem, previousFaceItem: previousFaceItem)
    }
    
    func swapCamera() {
        self.view?.swapCamera()
    }
    
    func clearAllFaceItems() {
        clearHeadFaceItem()
        clearLeftEyeFaceItem()
        clearRightEyeFaceItem()
        clearNoseFaceItem()
        clearLipFaceItem()
        clearMouthFaceItem()
        clearAllAnimations()
    }
    
    func didClickTakePicture() {
        self.view?.prepareViewForImageCapture()
        self.view?.captureCurrentImage()
        self.view?.revertViewFromImageCapture()
    }
    
    func didSuccessfullyTakeImage() {
        self.view?.playCameraSound()
        self.view?.showCameraFlash()
    }
    
    func didFailTakeImage() {
        self.view?.showFailedImageCapture()
    }
    
    // Mark: FaceTrackerViewPresenterOps
    
    func faceTrackerDidFinishLoading() {
        self.view?.stopLoadingAnimation()
    }
    
    func viewDidLoad(withView view:FaceTrackerViewOps) {
        self.view = view
        self.model = FaceTrackerModel(presenter: self)
    }
    
    func didReceiveFaceAnalyzerPoints(_ points:FaceAnalyzerPoints?) {
        if let points = points {
            faceAnalyzer.updatePoints(points)
            
            if let headFaceItem = self.model.headFaceItem {
                self.view?.showHeadView()
                self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer, andFaceItem:headFaceItem)
            }
            else {
                self.view?.hideHeadView()
            }
            
            if let leftEyeFaceItem = self.model.leftEyeFaceItem {
                self.view?.showLeftEyeView()
                self.view?.repositionLeftEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: leftEyeFaceItem)
            }
            else {
                self.view?.hideLeftEyeView()
            }
            
            if let rightEyeFaceItem = self.model.leftEyeFaceItem {
                self.view?.showRightEyeView()
                self.view?.repositionRightEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: rightEyeFaceItem)
            }
            else {
                self.view?.hideRightEyeView()
            }
            
            if let noseFaceItem = self.model.noseFaceItem {
                self.view?.showNoseView()
                self.view?.repositionNoseView(usingAnalyzer: faceAnalyzer, andFaceItem:noseFaceItem)
            }
            else {
                self.view?.hideNoseView()
            }
            
            if let lipFaceItem = self.model.lipFaceItem {
                self.view?.showLipView()
                self.view?.repositionLipView(usingAnalyzer: faceAnalyzer, andFaceItem:lipFaceItem)
            }
            else {
                self.view?.hideLipView()
            }
            
            if let mouthFaceItem = self.model.mouthFaceItem {
                // TODO: Animate this and make it proper
                // Added this in as a quick demo. need to animate this.
                if mouthFaceItem.imageName != "dog_tongue"
                    || (mouthFaceItem.imageName == "dog_tongue" && faceAnalyzer.isMouthOpen()) {
                    self.view?.showMouthView()
                    self.view?.repositionMouthView(usingAnalyzer: faceAnalyzer, andFaceItem:mouthFaceItem)
                } else {
                    self.view?.hideMouthView()
                }
            }
            else {
                self.view?.hideMouthView()
            }
            
            if self.model.areFacePointsShown {
                self.view?.positionFaceAnalyzerPoints(points)
                self.view?.showFacePoints()
            }
            else {
                self.view?.hideFacePoints()
            }
        }
        else {
            self.view?.hideFacePoints()
            self.view?.hideHeadView()
            self.view?.hideEyesView()
            self.view?.hideNoseView()
            self.view?.hideLipView()
            self.view?.hideMouthView()
        }
    }
    
    // Mark: FaceTrackerModelPresenterOps
    
}
