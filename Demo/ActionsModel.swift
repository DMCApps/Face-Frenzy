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
    
    var isMenuOpen:Bool = false
    var areFacePointsShown:Bool = true
    
    private let presenter:ActionsModelPresenterOps
    
    // MARK: init
    
    init(presenter:ActionsModelPresenterOps) {
        self.presenter = presenter
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MAKR: <ActionsModelOps>
    
    func toggleMenuState() {
        self.isMenuOpen = !self.isMenuOpen
    }
    
    func toggleFacePointsState() {
        self.areFacePointsShown = !self.areFacePointsShown
    }
    
}
