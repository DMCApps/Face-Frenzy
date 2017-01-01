//
//  FaceItemsDataSource.swift
//  Demo
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

        cell.faceItem = self.dataSource[indexPath.row]

        return cell
    }

    // MARK: <UICollectionViewDelegate>

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FaceItemCollectionViewCell
        self.delegate.didSelectFaceItem(cell.faceItem)
    }
    
}
