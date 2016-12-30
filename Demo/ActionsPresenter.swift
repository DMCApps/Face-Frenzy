//
//  ActionsPresenter.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation

class ActionsPresenter: ActionsViewPresenterOps, ActionsModelPresenterOps {
    
    weak private var view:ActionsViewOps?
    private var model:ActionsModelOps!
    
    // Mark: ActionsViewPresenterOps
    
    func viewDidLoad(withView view:ActionsViewOps) {
        self.view = view
        self.model = ActionsModel(presenter: self)
    }
    
    func didClickOpenClose() {
        self.model.toggleMenuState()
        if self.model.isMenuOpen() {
            self.view?.openActionsMenu()
        }
        else {
            self.view?.closeActionsMenu()
        }
    }
    
    // Mark: ActionsModelPresenterOps
    
}
