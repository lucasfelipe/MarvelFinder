//
//  CollectionViewCellPopulator.swift
//  MarvelFinder
//
//  Created by Dev on 1/12/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewCellPopulator {
    func populate(_ collectionView: UICollectionView, at indexPath: IndexPath, with data: DataManager.DataType) -> UICollectionViewCell
}
