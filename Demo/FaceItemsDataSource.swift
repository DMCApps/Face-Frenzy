//
//  FaceItemsDataSource.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2017-01-01.
//  Copyright © 2017 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

class FaceItemsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties
    
    let dataSource:[FaceItem]
    let delegate:ActionsDelegate
    
    var activeItems = [FaceItem]()
    
    // MARK: init
    
    init(dataSource:[FaceItem], delegate:ActionsDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    // MARK: Public
    
    // MARK: Private
    
    // MARK: <ProtocolName>
    

    // MARK: <UICollectionViewDataSource>

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! FaceItemCollectionViewCell

        let faceItem = self.dataSource[indexPath.row]
        cell.faceItem = faceItem
        
        if self.activeItems.contains(faceItem) {
            cell.ibImageView.layer.borderColor = UIColor.appPrimary.cgColor
            cell.ibImageView.layer.borderWidth = 2
        } else {
            cell.ibImageView.layer.borderColor = UIColor.clear.cgColor
            cell.ibImageView.layer.borderWidth = 0
        }

        return cell
    }

    // MARK: <UICollectionViewDelegate>

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FaceItemCollectionViewCell
        
        if let index = activeItems.index(of: cell.faceItem) {
            activeItems.remove(at: index)
        } else {
            activeItems.append(cell.faceItem)
        }
        
        collectionView.reloadItems(at: [indexPath])
        self.delegate.didSelectFaceItem(cell.faceItem)
    }
    
}
