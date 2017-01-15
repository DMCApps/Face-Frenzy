//
//  ImagePreviewMVP.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-14.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation

protocol ImagePreviewViewOps: NSObjectProtocol {
    
    func showActionChoices()
    
    func showFailedToShareImage()
    func showSuccessfullySharedImage()
    
    func dismissView()
    
}

protocol ImagePreviewViewPresenterOps {
    
    func viewDidLoad(withView view:ImagePreviewViewOps)
    
    func didClickTrash()
    func didClickAction()
    
    func didFailToShareImage()
    func didSuccessfullyShareImage()

}

protocol ImagePreviewModelPresenterOps {
    
}

protocol ImagePreviewModelOps {
    
}
