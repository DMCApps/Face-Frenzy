//
//  FaceItemCollectionViewCell.swift
//  Demo
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FaceItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ibImageView:UIImageView!
    
    var faceItem:FaceItem! {
        didSet {
            ibImageView.image = UIImage(named:self.faceItem.imageName)
        }
    }
    
}
