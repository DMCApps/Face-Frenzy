//
//  ImagePreviewView.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-14.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewView: UIViewController, ImagePreviewViewOps {
    
    // MARK: Properties
    
    @IBOutlet weak var ibImagePreviewImageView: UIImageView!
    @IBOutlet weak var ibActionBarButtonItem: UIBarButtonItem!
    
    var image = UIImage()
    
    private var presenter:ImagePreviewViewPresenterOps!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ImagePreviewPresenter()
        self.presenter.viewDidLoad(withView:self)
        
        self.ibImagePreviewImageView.image = image
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
    
    @IBAction func clickTrash(_ sender: UIBarButtonItem) {
        self.presenter.didClickTrash()
    }
    
    @IBAction func clickAction(_ sender: UIBarButtonItem) {
        self.presenter.didClickAction()
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <NameOfProtocol>
    
    // MARK: <ImagePreviewViewOps>
    
    func showActionChoices() {
        guard let image = self.ibImagePreviewImageView.image else { return }
        
        let objectsToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = self.ibActionBarButtonItem
        activityViewController.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
            guard let `self` = self else {
                return
            }
            
            guard success else {
                // If this is nil then it was a user cancel that caused the succes = false
                if error != nil {
                    self.presenter.didFailToShareImage()
                }
                return
            }
            
            self.presenter.didSuccessfullyShareImage()
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func showFailedToShareImage() {
        // Note for the assignment we need to use our own code per coursera requirements.
        // I'd rather show SVProgressHUD (https://cocoapods.org/pods/SVProgressHUD) for these smaller messages
        UIAlertController.okAlert(withTitle: "image_preview_alert_did_fail_share_image_title",
                                  withMessage: "image_preview_alert_did_fail_share_image_msg")
            .show(in: self)
    }
    
    func showSuccessfullySharedImage() {
        // Note for the assignment we need to use our own code per coursera requirements. 
        // I'd rather show SVProgressHUD (https://cocoapods.org/pods/SVProgressHUD) for these smaller messages
        UIAlertController.okAlert(withTitle: "image_preview_alert_did_successfully_share_image_title")
            .show(in: self)
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}
