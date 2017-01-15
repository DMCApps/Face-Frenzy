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
        guard let image = self.ibImagePreviewImageView.image else {
            return
        }
        
        let objectsToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = self.ibActionBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}
