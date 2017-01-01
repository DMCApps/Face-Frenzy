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
    
    private let faceAnalyzer:FaceAnalyzer = FacePointAnalyzer()
    
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
        switch faceItem.position {
        case .head:
            if let currentFaceItem = self.model.headFaceItem,
                currentFaceItem == faceItem {
                
                self.model.headFaceItem = nil
                self.view?.hideHeadView()
            }
            else {
                self.model.headFaceItem = faceItem
                self.view?.showHeadViewWithFaceItem(faceItem)
                self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
            }
        case .eyes:
            if let currentFaceItem = self.model.eyesFaceItem,
                currentFaceItem == faceItem {
                
                // TODO: How do I make this into a nice model
                if faceItem.imageName == "heart" {
                    self.view?.stopAnimatingHearts()
                }
                
                self.model.eyesFaceItem = nil
                self.view?.hideEyesView()
            }
            else {
                self.model.eyesFaceItem = faceItem
                
                // TODO: How do I make this into a nice model and actionable item
                if faceItem.imageName == "heart" {
                    self.view?.startAnimatingHearts()
                }
                
                self.view?.showEyesViewWithFaceItem(faceItem)
                self.view?.repositionEyesView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
            }
        case .nose:
            if let currentFaceItem = self.model.noseFaceItem,
                currentFaceItem == faceItem {
                
                self.model.noseFaceItem = nil
                self.view?.hideNoseView()
            }
            else {
                self.model.noseFaceItem = faceItem
                self.view?.showNoseViewWithFaceItem(faceItem)
                self.view?.repositionNoseView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
            }
        case .upperLip:
            if let currentFaceItem = self.model.lipFaceItem,
                currentFaceItem == faceItem {
                
                self.model.lipFaceItem = nil
                self.view?.hideLipView()
            }
            else {
                self.model.lipFaceItem = faceItem
                self.view?.showLipViewWithFaceItem(faceItem)
                self.view?.repositionLipView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
            }
        case .centerMouth:
            if let currentFaceItem = self.model.mouthFaceItem,
                currentFaceItem == faceItem {
                
                self.model.mouthFaceItem = nil
                self.view?.hideMouthView()
            }
            else {
                self.model.mouthFaceItem = faceItem
                self.view?.showMouthViewWithFaceItem(faceItem)
                self.view?.repositionMouthView(usingAnalyzer: faceAnalyzer, andFaceItem:faceItem)
            }
        }
    }
    
    // Mark: FaceTrackerViewPresenterOps
    
    func faceTrackerDidFinishLoading() {
        self.view?.stopLoadingAnimation()
    }
    
    func viewDidLoad(withView view:FaceTrackerViewOps) {
        self.view = view
        self.model = FaceTrackerModel(presenter: self)
    }
    
    // TODO: Should FacePoints be passed or just the raw values so that we don't have to import FaceTracker?
    func didReceiveFacePoints(_ points:FacePoints?) {
        if let points = points {
            faceAnalyzer.updatePoints(points)
            
            if let headFaceItem = self.model.headFaceItem {
                self.view?.showHeadView()
                self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer, andFaceItem:headFaceItem)
            }
            else {
                self.view?.hideHeadView()
            }
            
            if let eyesFaceItem = self.model.eyesFaceItem {
                self.view?.showEyesView()
                self.view?.repositionEyesView(usingAnalyzer: faceAnalyzer, andFaceItem:eyesFaceItem)
            }
            else {
                self.view?.hideEyesView()
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
                self.view?.showMouthView()
                self.view?.repositionMouthView(usingAnalyzer: faceAnalyzer, andFaceItem:mouthFaceItem)
            }
            else {
                self.view?.hideMouthView()
            }
            
            if self.model.areFacePointsShown {
                self.view?.positionFacePoints(points)
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
