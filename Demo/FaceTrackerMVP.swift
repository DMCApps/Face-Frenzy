//
//  FaceTrackerMVP.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

protocol FaceTrackerViewOps: NSObjectProtocol {
    
}

protocol FaceTrackerViewPresenterOps {
    
    func viewDidLoad(withView view:FaceTrackerViewOps)
    
}

protocol FaceTrackerModelPresenterOps {
    
}

protocol FaceTrackerModelOps {
    
}
