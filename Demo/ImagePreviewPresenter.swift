//
//  ImagePreviewPresenter.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-14.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation

class ImagePreviewPresenter: ImagePreviewViewPresenterOps, ImagePreviewModelPresenterOps {
    
    weak private var view:ImagePreviewViewOps?
    private var model:ImagePreviewModelOps!
    
    // Mark: ImagePreviewViewPresenterOps
    
    func viewDidLoad(withView view:ImagePreviewViewOps) {
        self.view = view
        self.model = ImagePreviewModel(presenter: self)
    }
    
    // Mark: ImagePreviewModelPresenterOps
    
    func didClickAction() {
        self.view?.showActionChoices()
    }
    
    func didClickTrash() {
        self.view?.dismissView()
    }
    
}
