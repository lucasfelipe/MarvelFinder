//
//  TabCellPopulator.swift
//  MarvelFinder
//
//  Created by Dev on 1/12/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import Foundation
import UIKit

class CharacterCellPopulator: CollectionViewCellPopulator {
    func populate(_ collectionView: UICollectionView, at indexPath: IndexPath, with data: DataManager.DataType) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCollectionCell.reuseIdentifer, for: indexPath) as! CharacterDetailCollectionCell
        cell.data = data
        return cell
    }
}
