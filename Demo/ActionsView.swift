//
//  ActionsViewController.swift
//  Demo
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ActionsDelegate {
    
    func openActionsMenu()
    func closeActionsMenu()
    
}

class ActionsView: UIViewController, ActionsViewOps {
    
    // MARK: Properties
    
    @IBOutlet weak var ibOpenCloseButton: UIButton!
    
    public var delegate:ActionsDelegate!
    
    private var presenter:ActionsViewPresenterOps!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Object Lifecycle
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ActionsPresenter()
        self.presenter.viewDidLoad(withView:self)
        
        self.view.layer.cornerRadius = 12
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
    
    @IBAction func openCloseClick(_ sender: UIButton) {
        self.presenter.didClickOpenClose()
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <NameOfProtocol>
    
    // MARK: <ActionsViewOps>
    
    func openActionsMenu() {
        self.delegate.openActionsMenu()
    }
    
    func closeActionsMenu() {
        self.delegate.closeActionsMenu()
    }
    
}
