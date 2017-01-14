//
//  FaceTrackerView.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import UIKit
import FaceTracker
import AudioToolbox

class FaceTrackerView: UIViewController, FaceTrackerViewOps, FaceTrackerViewControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var faceTrackerContainerView: UIView!
    @IBOutlet weak var ibActionMenuTopToContainerConstraint: NSLayoutConstraint!
    
    // Design decission. I put the take picture button in the bottom right to easily take a picture in the right hand.
    @IBOutlet weak var ibTakePictureButton: UIButton!
    
    var faceTrackerViewController: FaceTrackerViewController?
    var actionsView: ActionsView?
    
    var headImageView = UIImageView()
    var leftEyeImageView = UIImageView()
    var rightEyeImageView = UIImageView()
    var noseImageView = UIImageView()
    var lipImageView = UIImageView()
    let mouthImageView = UIImageView()
    
    let imageCaptureFlashView = UIView()
    
    var pointViews = [UIView]()
    
    var startTranslationConstraintConstant:CGFloat?
    
    private var presenter:FaceTrackerViewPresenterOps = FaceTrackerPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad(withView:self)
        
        self.ibTakePictureButton.layer.cornerRadius = 25.0
        
        imageCaptureFlashView.alpha = 0
        imageCaptureFlashView.backgroundColor = UIColor.black
        self.view.insertSubview(imageCaptureFlashView, aboveSubview: faceTrackerContainerView)
        
        self.view.insertSubview(headImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(leftEyeImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(rightEyeImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(noseImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(lipImageView, aboveSubview: faceTrackerContainerView)
        self.view.insertSubview(mouthImageView, aboveSubview: faceTrackerContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTrackerViewController!.startTracking { () -> Void in
            self.presenter.faceTrackerDidFinishLoading()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedFaceTrackerViewController" {
            faceTrackerViewController = segue.destination as? FaceTrackerViewController
            faceTrackerViewController!.delegate = self
        }
        else if segue.identifier == "embedActionsViewController" {
            actionsView = segue.destination as? ActionsView
            actionsView!.delegate = self.presenter
        }
    }
    
    // MARK: Accessors
    
    // MARK: Actions
    
    @IBAction func clickTakePicture(_ sender: UIButton) {
        self.presenter.didClickTakePicture()
    }
    
    // MARK: Public
    
    // MARK: Private
    
    func animateActionMenuTo(_ value:CGFloat, withDuration duration:TimeInterval = 0.33) {
        self.ibActionMenuTopToContainerConstraint.constant = value
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
            self.presenter.didFailTakeImage()
        } else {
            self.presenter.didSuccessfullyTakeImage()
        }
    }
    
    // MARK: <NameOfProtocol>
    
    // MARK: <FaceTrackerViewControllerDelegate>
    
    func faceTrackerDidUpdate(_ points: FacePoints?) {
        self.presenter.didReceiveFaceAnalyzerPoints(points)
    }
    
    // MARK: <FaceTrackerViewOps>
    
    func stopLoadingAnimation() {
        self.activityIndicator.stopAnimating()
    }
    
    func positionFaceAnalyzerPoints(_ points:FaceAnalyzerPoints) {
        if (pointViews.count == 0) {
            let numPoints = points.getTotalNumberOFPoints()
            for _ in 0...numPoints {
                let view = UIView()
                view.backgroundColor = UIColor.green
                self.view.addSubview(view)
                
                pointViews.append(view)
            }
        }
        
        points.enumeratePoints({ (point, index) -> Void in
            let pointView = self.pointViews[index]
            let pointSize: CGFloat = 4
            
            pointView.frame = CGRect(x: point.x - pointSize / 2,
                                     y: point.y - pointSize / 2,
                                     width: pointSize,
                                     height: pointSize).integral
        })
    }
    
    func swapCamera() {
        faceTrackerViewController?.swapCamera()
    }
    
    func prepareViewForImageCapture() {
        self.actionsView?.view.isHidden = true
        self.ibTakePictureButton.isHidden = true
    }
    
    func revertViewFromImageCapture() {
        self.actionsView?.view.isHidden = false
        self.ibTakePictureButton.isHidden = false
    }
    
    func captureCurrentImage() {
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let screenCap = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenCap, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func showFailedImageCapture() {
        UIAlertController.Builder()
            .withTitle("face_tracker_alert_failed_image_capture_title")
            .withMessage("face_tracker_alert_failed_image_capture_msg")
            .addOkAction()
            .show(in: self)
    }
    
    func playCameraSound() {
        AudioServicesPlayAlertSound(1108)
    }
    
    func showCameraFlash() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .autoreverse, animations: { [weak self] () -> Void in
            guard let `self` = self else {
                return
            }
            
            self.imageCaptureFlashView.alpha = 1
        }, completion: nil)
    }
    
    func runAnimations(_ animations: [Animatable]?) {
        animations?.forEach({ (animation) in
            if !animation.isAnimating {
               animation.startAnimating(in: self.view)
            }
        })
    }
    
    func stopAnimations(_ animations: [Animatable]?) {
        animations?.forEach({ (animation) in
            if animation.isAnimating {
                animation.stopAnimating()
            }
        })
    }
    
    func showHeadView() {
        headImageView.isHidden = false
    }
    
    func hideHeadView() {
        headImageView.isHidden = true
    }
    
    func showHeadViewWithFaceItem(_ faceItem: FaceItem) {
        headImageView.image = UIImage(named: faceItem.imageName)
        headImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionHeadView(usingAnalyzer faceAnalyzer:FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        guard faceAnalyzer.isReady(), !headImageView.isHidden, headImageView.image != nil else {
                return
        }
        
        headImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
    }
    
    func showEyesView() {
        showLeftEyeView()
        showRightEyeView()
    }
    
    func hideEyesView() {
        hideLeftEyeView()
        hideRightEyeView()
    }
    
    func showEyesViewWithFaceItem(_ faceItem: FaceItem) {
        showLeftEyeViewWithFaceItem(faceItem)
        showRightEyeViewWithFaceItem(faceItem)
    }
    
    func repositionEyesView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        repositionLeftEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: faceItem)
        repositionRightEyeView(usingAnalyzer: faceAnalyzer, andFaceItem: faceItem)
    }
    
    func showLeftEyeView() {
        leftEyeImageView.isHidden = false
    }
    
    func hideLeftEyeView() {
        leftEyeImageView.isHidden = true
    }
    
    func showLeftEyeViewWithFaceItem(_ faceItem: FaceItem) {
        leftEyeImageView.image = UIImage(named: faceItem.imageName)
        leftEyeImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionLeftEyeView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !leftEyeImageView.isHidden,
            leftEyeImageView.image != nil {
            
            leftEyeImageView.adjustLayoutFor(faceItem: faceItem.withPosition(.leftEye), usingAnalyzer: faceAnalyzer)
            
        }
    }
    
    func showRightEyeView() {
        rightEyeImageView.isHidden = false
    }
    
    func hideRightEyeView() {
        rightEyeImageView.isHidden = true
    }
    
    func showRightEyeViewWithFaceItem(_ faceItem: FaceItem) {
        rightEyeImageView.image = UIImage(named: faceItem.imageName)
        rightEyeImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionRightEyeView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !rightEyeImageView.isHidden,
            rightEyeImageView.image != nil {
            
            rightEyeImageView.adjustLayoutFor(faceItem: faceItem.withPosition(.rightEye), usingAnalyzer: faceAnalyzer)
            
        }
    }
    
    func showNoseView() {
        noseImageView.isHidden = false
    }
    
    func hideNoseView() {
        noseImageView.isHidden = true
    }
    
    func showNoseViewWithFaceItem(_ faceItem: FaceItem) {
        noseImageView.image = UIImage(named: faceItem.imageName)
        noseImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionNoseView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !noseImageView.isHidden,
            noseImageView.image != nil {
            
            noseImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
        }
    }
    
    func showLipView() {
        lipImageView.isHidden = false
    }
    
    func hideLipView() {
        lipImageView.isHidden = true
    }
    
    func showLipViewWithFaceItem(_ faceItem: FaceItem) {
        lipImageView.image = UIImage(named: faceItem.imageName)
        lipImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionLipView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !lipImageView.isHidden,
            lipImageView.image != nil {
            
            lipImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
        }
    }
    
    func showMouthView() {
        mouthImageView.isHidden = false
    }
    
    func hideMouthView() {
        mouthImageView.isHidden = true
    }
    
    func showMouthViewWithFaceItem(_ faceItem: FaceItem) {
        mouthImageView.image = UIImage(named: faceItem.imageName)
        mouthImageView.anchorTo(point: faceItem.anchorPoint)
    }
    
    func repositionMouthView(usingAnalyzer faceAnalyzer: FaceAnalyzer, andFaceItem faceItem:FaceItem) {
        if faceAnalyzer.isReady(),
            !mouthImageView.isHidden,
            mouthImageView.image != nil {
            
            mouthImageView.adjustLayoutFor(faceItem: faceItem, usingAnalyzer: faceAnalyzer)
        }
    }
    
    func hideFacePoints() {
        for view in pointViews {
            view.isHidden = true
        }
    }
    
    func openActionsMenu() {
        animateActionMenuTo(190)
    }
    
    func closeActionsMenu() {
        animateActionMenuTo(30)
    }
    
    func showFacePoints() {
        for pointView in pointViews {
            pointView.isHidden = false
        }
    }
    
    func didBeginTranslation() {
        self.startTranslationConstraintConstant = self.ibActionMenuTopToContainerConstraint.constant
    }
    
    func didTranslateBy(_ translation: CGFloat) {
        guard let startTranslationConstraintConstant = self.startTranslationConstraintConstant else {
            return
        }
        
        var newConstraintConstant = startTranslationConstraintConstant + translation
        newConstraintConstant = newConstraintConstant.clamp(to: (30 ... 190))
        animateActionMenuTo(newConstraintConstant, withDuration: 0.05)
    }
    
    func didEndTranslation() {
        self.startTranslationConstraintConstant = nil
    }
    
}
