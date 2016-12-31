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
        self.model.setFacePointsShown(true)
    }
    
    func hideFacePoints() {
        self.view?.hideFacePoints()
        self.model.setFacePointsShown(false)
    }
    
    func didBeginTranslation() {
        self.view?.didBeginTranslation()
    }
    
    func didTranslateBy(_ translation: CGFloat) {
        self.view?.didTranslateBy(translation)
    }
    
    func didEndTranslation() {
        self.view?.didEndTranslation()
    }
    
    func didSelectFaceItem(_ faceItem: FaceItem) {
        switch faceItem.position {
        case .head:
            self.view?.showHeadViewWithFaceItem(faceItem)
            self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer)
        case .eyes:
            self.view?.showEyesViewWithFaceItem(faceItem)
            self.view?.repositionEyesView(usingAnalyzer: faceAnalyzer)
        default:
            break
        }
    }
    
    // Mark: FaceTrackerViewPresenterOps
    
    func viewDidLoad(withView view:FaceTrackerViewOps) {
        self.view = view
        self.model = FaceTrackerModel(presenter: self)
    }
    
    // TODO: Should FacePoints be passed or just the raw values so that we don't have to import FaceTracker?
    func didReceiveFacePoints(_ points:FacePoints?) {
        if let points = points {
            faceAnalyzer.updatePoints(points)
            self.view?.positionFacePoints(points)
            self.view?.showHeadView()
            self.view?.repositionHeadView(usingAnalyzer: faceAnalyzer)
            self.view?.showEyesView()
            self.view?.repositionEyesView(usingAnalyzer: faceAnalyzer)
            
            if self.model.areFacePointsShown() {
                self.view?.showFacePoints()
            }
        }
        else {
            self.view?.hideFacePoints()
            self.view?.hideHeadView()
        }
    }
    
    // Mark: FaceTrackerModelPresenterOps
    
}
