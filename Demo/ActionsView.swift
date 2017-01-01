//
//  ActionsViewController.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ActionsDelegate {
    
    func openActionsMenu()
    func closeActionsMenu()
    
    func didBeginTranslation()
    func didTranslateBy(_ translation:CGFloat)
    func didEndTranslation()
    
    func showFacePoints()
    func hideFacePoints()
    
    func didSelectFaceItem(_ faceItem:FaceItem)
    
}

class ActionsView: UIViewController, ActionsViewOps {
    
    // MARK: Properties
    
    @IBOutlet weak var ibOpenCloseButton: UIButton!
    @IBOutlet weak var ibShowPointsSwitch: UISwitch!
    @IBOutlet weak var ibFaceItemCollectionsView: UICollectionView!
    
    public var delegate:ActionsDelegate!
    
    private var presenter:ActionsViewPresenterOps!
    
    private var faceItemDataSource:FaceItemsDataSource!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ActionsPresenter()
        self.presenter.viewDidLoad(withView:self)
        
        self.view.layer.cornerRadius = 12
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag))
        self.ibOpenCloseButton.addGestureRecognizer(panGesture)
        
        faceItemDataSource = FaceItemsDataSource(dataSource: FaceItemProvider.items, delegate:self.delegate)
        self.ibFaceItemCollectionsView.dataSource = faceItemDataSource
        self.ibFaceItemCollectionsView.delegate = faceItemDataSource
        self.ibFaceItemCollectionsView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Segues
    
    // MARK: Accessors
    
    // MARK: Actions
    
    @IBAction func openCloseClick(_ sender: UIButton) {
        self.presenter.didClickOpenClose()
    }
    
    @IBAction func toggleFacePointsClick(_ sender: UIButton) {
        self.presenter.didClickToggleFacePoints()
    }
    
    // MARK: Public
    
    // MARK: Private
    
    func onDrag(gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        switch gesture.state {
        case .began:
            self.delegate.didBeginTranslation()
        case .changed:
            self.delegate.didTranslateBy(-1 * translation.y)
        case .ended:
            self.delegate.didEndTranslation()
        default:
            break
        }
    }
    
    // MARK: <NameOfProtocol>
    
    // MARK: <ActionsViewOps>
    
    func openActionsMenu() {
        self.delegate.openActionsMenu()
    }
    
    func closeActionsMenu() {
        self.delegate.closeActionsMenu()
    }
    
    func showFacePoints() {
        self.delegate.showFacePoints()
    }
    
    func hideFacePoints() {
        self.delegate.hideFacePoints()
    }
    
    func toggleShowFacePointsOn() {
        self.ibShowPointsSwitch.setOn(true, animated: true)
    }
    
    func toggleShowFacePointsOff() {
        self.ibShowPointsSwitch.setOn(false, animated: true)
    }
    
}
