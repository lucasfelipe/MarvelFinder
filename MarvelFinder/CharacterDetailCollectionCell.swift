//
//  CharacterDetailCollectionCell.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 10/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit

class CharacterDetailCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    
    static let reuseIdentifer = "CollectionCell"
    var data : CollectionItem! {
        didSet {
            preecherDados()
        }
    }
    
    private func preecherDados() {
        let urlString = "\(data.thumbnail!)/portrait_medium.\(data.thumbFormat!)"
        
        self.collectionImage.af_setImage(withURL: URL(string: urlString)!, placeholderImage: UIImage(named: "placeholder_search"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
        self.collectionName.text = data.description

    }
    
}
