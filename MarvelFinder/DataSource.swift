//
//  DataSource.swift
//  MarvelFinder
//
//  Created by Dev on 1/12/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import Foundation
import UIKit

class DataSource<T: DataManager, U: CollectionViewCellPopulator> : NSObject, UICollectionViewDataSource {
    
    internal let dataManager: T
    private let cellPopulator: U
    
    init(dataManager: T, cellPopulator: U) {
        self.dataManager = dataManager
        self.cellPopulator = cellPopulator
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataManager.sectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellPopulator.populate(collectionView, at: indexPath, with: dataManager.itemAtIndexPath(indexPath: indexPath))
    }
}
