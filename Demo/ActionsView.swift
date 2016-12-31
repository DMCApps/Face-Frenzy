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
    
    func didSelectImageNamed(_ name:String)
    
}

class ActionsView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ActionsViewOps {
    
    // MARK: Properties
    
    @IBOutlet weak var ibOpenCloseButton: UIButton!
    @IBOutlet weak var ibShowPointsSwitch: UISwitch!
    
    public var delegate:ActionsDelegate!
    
    private var presenter:ActionsViewPresenterOps!
    
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
    
    func images() -> [String] {
        return [
            "hat",
            "horns",
            "light",
            "heart",
            "dog_nose",
            "pig_nose",
            "beard",
            "lips",
            "mustache",
            "dog_tongue"
        ]
    }
    
    // MARK: <NameOfProtocol>
    
    // MARK: <UICollectionViewDataSource>
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: images()[indexPath.row])
        
        return cell
    }
    
    // MARK: <UICollectionViewDelegate>
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectImageNamed(images()[indexPath.row])
    }
    
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
