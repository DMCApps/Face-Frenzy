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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)

        let faceItem = self.dataSource[indexPath.row];
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: faceItem.imageName)

        return cell
    }

    // MARK: <UICollectionViewDelegate>

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectFaceItem(self.dataSource[indexPath.row])
    }
    
}

//class FaceItemsDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    // MARK: Properties
//    
//    // MARK: <UICollectionViewDataSource>
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ActionsView.faceItems.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
//        
//        let faceItem = ActionsView.faceItems[indexPath.row];
//        let imageView = cell.viewWithTag(1000) as! UIImageView
//        imageView.image = UIImage(named: faceItem.imageName)
//        
//        return cell
//    }
//    
//    // MARK: <UICollectionViewDelegate>
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate.didSelectFaceItem(ActionsView.faceItems[indexPath.row])
//    }
//    
//}
