//
//  ActionsMVP.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

protocol ActionsViewOps: NSObjectProtocol {
    
    func openActionsMenu()
    func closeActionsMenu()
    
}

protocol ActionsViewPresenterOps {
    
    func viewDidLoad(withView view:ActionsViewOps)
    
    func didClickOpenClose()
    
}

protocol ActionsModelPresenterOps {
    
}

protocol ActionsModelOps {
    func toggleMenuState()
    func isMenuOpen() -> Bool
    
}
