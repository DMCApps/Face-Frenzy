//
//  ActionsModel.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

class ActionsModel: ActionsModelOps {
    
    // MARK: Properties
    
    private var _isMenuOpen:Bool = false
    
    private let presenter:ActionsModelPresenterOps
    
    // MARK: init
    
    init(presenter:ActionsModelPresenterOps) {
        self.presenter = presenter
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MAKR: <ActionsModelOps>
    
    func toggleMenuState() {
        self._isMenuOpen = !self._isMenuOpen
    }
    
    func isMenuOpen() -> Bool {
        return self._isMenuOpen
    }
    
}
